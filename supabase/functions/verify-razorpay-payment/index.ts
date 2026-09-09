// Supabase Edge Function — verify-razorpay-payment
// Deploy: supabase functions deploy verify-razorpay-payment
// Secrets needed: RAZORPAY_KEY_SECRET, SUPABASE_URL, SUPABASE_SERVICE_ROLE_KEY
// (the service role key is required to write subscriptions/payments as this
// function acts on the user's behalf after verifying their JWT below)

import { serve } from 'https://deno.land/std@0.192.0/http/server.ts';
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

const RAZORPAY_KEY_SECRET = Deno.env.get('RAZORPAY_KEY_SECRET')!;
const SUPABASE_URL = Deno.env.get('SUPABASE_URL')!;
const SERVICE_ROLE_KEY = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!;

async function hmacSha256Hex(secret: string, message: string) {
  const key = await crypto.subtle.importKey(
    'raw', new TextEncoder().encode(secret),
    { name: 'HMAC', hash: 'SHA-256' }, false, ['sign']
  );
  const sig = await crypto.subtle.sign('HMAC', key, new TextEncoder().encode(message));
  return Array.from(new Uint8Array(sig)).map(b => b.toString(16).padStart(2, '0')).join('');
}

serve(async (req) => {
  try {
    const authHeader = req.headers.get('Authorization');
    if (!authHeader) return new Response(JSON.stringify({ error: 'Missing auth' }), { status: 401 });

    const supabase = createClient(SUPABASE_URL, SERVICE_ROLE_KEY);
    const jwt = authHeader.replace('Bearer ', '');
    const { data: userData, error: userErr } = await supabase.auth.getUser(jwt);
    if (userErr || !userData.user) return new Response(JSON.stringify({ error: 'Invalid session' }), { status: 401 });

    const { razorpay_order_id, razorpay_payment_id, razorpay_signature, plan, cycle } = await req.json();

    const expectedSignature = await hmacSha256Hex(RAZORPAY_KEY_SECRET, `${razorpay_order_id}|${razorpay_payment_id}`);
    if (expectedSignature !== razorpay_signature) {
      return new Response(JSON.stringify({ success: false, error: 'Signature mismatch' }), { status: 400 });
    }

    const userId = userData.user.id;
    const periodDays = cycle === 'yearly' ? 365 : 30;
    const expiresAt = new Date(Date.now() + periodDays * 24 * 60 * 60 * 1000).toISOString();

    await supabase.from('payments').insert({
      user_id: userId,
      razorpay_order_id,
      razorpay_payment_id,
      plan,
      cycle,
      status: 'success'
    });

    await supabase.from('subscriptions').upsert({
      user_id: userId,
      plan,
      cycle,
      status: 'active',
      current_period_end: expiresAt
    }, { onConflict: 'user_id' });

    await supabase.from('profiles').update({ is_premium: true }).eq('id', userId);

    return new Response(JSON.stringify({ success: true }), {
      headers: { 'Content-Type': 'application/json' }
    });
  } catch (err) {
    return new Response(JSON.stringify({ success: false, error: err.message }), { status: 500 });
  }
});
