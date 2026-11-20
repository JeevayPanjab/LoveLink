// Supabase Edge Function — demo-chats
// Deploy: supabase functions deploy demo-chats
// Secrets needed: SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY
// (both are auto-provided to edge functions by Supabase — no extra secrets
//  need to be set. The service role key is required because the admin acts
//  on behalf of demo users, which RLS would otherwise block.)
//
// Lets an admin read and reply to conversations between demo/seed users
// (profiles.is_demo = true) and real users, AS the demo user. The real user
// sees the reply from the demo profile they matched — the admin account
// itself never appears in the chat.
//
// Actions (POST JSON body { action, ... }):
//   list-threads — { } → { threads: [{ demo, user, lastMessage, lastAt, unread }] }
//     One entry per (demo user, real user) pair that has a match AND at least
//     one message, newest first.
//   get-thread — { demo_user_id, other_id } → { messages: [...], demo, user }
//     Last 100 messages between the two, oldest first.
//   send — { demo_user_id, recipient_id, content } → { message: {...} }
//     Inserts a message as the demo user. Requires a match between the two.
//   mark-read — { demo_user_id, other_id } → { updated: n }
//     Marks messages from the real user to the demo user as read.
//
// Every action requires a valid JWT for an admin (profiles.is_admin = true).
// No RLS changes are needed: all reads/writes use the service-role client
// after the admin check. Demo users themselves never need to log in.

import { serve } from 'https://deno.land/std@0.192.0/http/server.ts';
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

const SUPABASE_URL = Deno.env.get('SUPABASE_URL')!;
const SERVICE_ROLE_KEY = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!;

const MAX_CONTENT_LENGTH = 2000;

function json(body: unknown, status = 200): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { 'Content-Type': 'application/json' },
  });
}

async function requireAdmin(supabase: ReturnType<typeof createClient>, userId: string): Promise<boolean> {
  const { data } = await supabase
    .from('profiles')
    .select('is_admin')
    .eq('id', userId)
    .single();
  return data?.is_admin === true;
}

async function isDemoUser(supabase: ReturnType<typeof createClient>, userId: string): Promise<boolean> {
  const { data } = await supabase
    .from('profiles')
    .select('is_demo')
    .eq('id', userId)
    .single();
  return data?.is_demo === true;
}

async function matchExists(
  supabase: ReturnType<typeof createClient>,
  a: string,
  b: string,
): Promise<boolean> {
  const { data } = await supabase
    .from('matches')
    .select('id')
    .or(`and(user_a.eq.${a},user_b.eq.${b}),and(user_a.eq.${b},user_b.eq.${a})`)
    .limit(1);
  return (data?.length ?? 0) > 0;
}

function pairKey(a: string, b: string): string {
  return [a, b].sort().join('_');
}

serve(async (req) => {
  try {
    const authHeader = req.headers.get('Authorization');
    if (!authHeader) return json({ error: 'Missing auth' }, 401);

    const supabase = createClient(SUPABASE_URL, SERVICE_ROLE_KEY);
    const jwt = authHeader.replace('Bearer ', '');
    const { data: userData, error: userErr } = await supabase.auth.getUser(jwt);
    if (userErr || !userData.user) return json({ error: 'Invalid session' }, 401);

    if (!(await requireAdmin(supabase, userData.user.id))) {
      return json({ error: 'Admin access required' }, 403);
    }

    const body = await req.json().catch(() => ({}));
    const action = body?.action;

    // ------------------------------------------------------------------
    // list-threads
    // ------------------------------------------------------------------
    if (action === 'list-threads') {
      const { data: demos } = await supabase
        .from('profiles')
        .select('id, full_name, photo_urls')
        .eq('is_demo', true);

      const demoIds = (demos || []).map((d) => d.id);
      if (demoIds.length === 0) return json({ success: true, threads: [] });

      const [byA, byB] = await Promise.all([
        supabase.from('matches').select('user_a, user_b, created_at').in('user_a', demoIds),
        supabase.from('matches').select('user_a, user_b, created_at').in('user_b', demoIds),
      ]);
      const matches = [...(byA.data || []), ...(byB.data || [])];

      // De-duplicate pairs and collect the real-user ids we need profiles for.
      const seen = new Set<string>();
      const pairs: Array<{ demoId: string; userId: string }> = [];
      for (const m of matches) {
        const demoId = demoIds.includes(m.user_a) ? m.user_a : m.user_b;
        const userId = demoId === m.user_a ? m.user_b : m.user_a;
        const key = pairKey(demoId, userId);
        if (seen.has(key)) continue;
        seen.add(key);
        pairs.push({ demoId, userId });
      }

      const userIds = [...new Set(pairs.map((p) => p.userId))];
      const { data: users } = userIds.length
        ? await supabase.from('profiles').select('id, full_name, photo_urls').in('id', userIds)
        : { data: [] };
      const userById = new Map((users || []).map((u) => [u.id, u]));
      const demoById = new Map((demos || []).map((d) => [d.id, d]));

      const threads = [];
      for (const { demoId, userId } of pairs) {
        const { data: last } = await supabase
          .from('messages')
          .select('content, created_at, sender_id')
          .or(`and(sender_id.eq.${demoId},recipient_id.eq.${userId}),and(sender_id.eq.${userId},recipient_id.eq.${demoId})`)
          .order('created_at', { ascending: false })
          .limit(1);
        if (!last || last.length === 0) continue; // pair with no messages yet

        const { count: unread } = await supabase
          .from('messages')
          .select('*', { count: 'exact', head: true })
          .eq('sender_id', userId)
          .eq('recipient_id', demoId)
          .eq('is_read', false);

        const demo = demoById.get(demoId) as { full_name?: string; photo_urls?: string[] } | undefined;
        const user = userById.get(userId) as { full_name?: string; photo_urls?: string[] } | undefined;
        threads.push({
          demo: { id: demoId, full_name: demo?.full_name || 'Demo user', photo_urls: demo?.photo_urls || [] },
          user: { id: userId, full_name: user?.full_name || 'LoveLink member', photo_urls: user?.photo_urls || [] },
          lastMessage: last[0].content,
          lastAt: last[0].created_at,
          lastFromDemo: last[0].sender_id === demoId,
          unread: unread || 0,
        });
      }

      threads.sort((a, b) => new Date(b.lastAt).getTime() - new Date(a.lastAt).getTime());
      return json({ success: true, threads });
    }

    // ------------------------------------------------------------------
    // get-thread
    // ------------------------------------------------------------------
    if (action === 'get-thread') {
      const { demo_user_id, other_id } = body;
      if (!demo_user_id || !other_id) return json({ error: 'demo_user_id and other_id are required' }, 400);
      if (!(await isDemoUser(supabase, demo_user_id))) {
        return json({ error: 'demo_user_id is not a demo user' }, 403);
      }
      if (!(await matchExists(supabase, demo_user_id, other_id))) {
        return json({ error: 'No match between these users' }, 400);
      }

      const { data: messages } = await supabase
        .from('messages')
        .select('id, sender_id, recipient_id, content, is_read, created_at')
        .or(`and(sender_id.eq.${demo_user_id},recipient_id.eq.${other_id}),and(sender_id.eq.${other_id},recipient_id.eq.${demo_user_id})`)
        .order('created_at', { ascending: true })
        .limit(100);
      return json({ success: true, messages: messages || [] });
    }

    // ------------------------------------------------------------------
    // send
    // ------------------------------------------------------------------
    if (action === 'send') {
      const { demo_user_id, recipient_id, content } = body;
      if (!demo_user_id || !recipient_id || typeof content !== 'string' || !content.trim()) {
        return json({ error: 'demo_user_id, recipient_id and non-empty content are required' }, 400);
      }
      if (content.trim().length > MAX_CONTENT_LENGTH) {
        return json({ error: `Message is too long (max ${MAX_CONTENT_LENGTH} characters)` }, 400);
      }
      if (!(await isDemoUser(supabase, demo_user_id))) {
        return json({ error: 'demo_user_id is not a demo user' }, 403);
      }
      if (!(await matchExists(supabase, demo_user_id, recipient_id))) {
        return json({ error: 'No match between these users' }, 400);
      }

      const { data: message, error: insertErr } = await supabase
        .from('messages')
        .insert({ sender_id: demo_user_id, recipient_id, content: content.trim() })
        .select('id, sender_id, recipient_id, content, is_read, created_at')
        .single();
      if (insertErr) return json({ error: insertErr.message }, 500);
      return json({ success: true, message });
    }

    // ------------------------------------------------------------------
    // mark-read
    // ------------------------------------------------------------------
    if (action === 'mark-read') {
      const { demo_user_id, other_id } = body;
      if (!demo_user_id || !other_id) return json({ error: 'demo_user_id and other_id are required' }, 400);
      if (!(await isDemoUser(supabase, demo_user_id))) {
        return json({ error: 'demo_user_id is not a demo user' }, 403);
      }

      const { data, error: updateErr } = await supabase
        .from('messages')
        .update({ is_read: true })
        .eq('sender_id', other_id)
        .eq('recipient_id', demo_user_id)
        .eq('is_read', false)
        .select('id');
      if (updateErr) return json({ error: updateErr.message }, 500);
      return json({ success: true, updated: data?.length ?? 0 });
    }

    return json({ error: 'Unknown action' }, 400);
  } catch (err) {
    return json({ success: false, error: (err as Error).message }, 500);
  }
});
