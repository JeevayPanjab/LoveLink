// LoveLink — Supabase client
// Loaded via CDN in each HTML page BEFORE this script:
// <script src="https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2/dist/umd/supabase.min.js"></script>
//
// Replace the two placeholders below with your project's values
// (Supabase dashboard → Project Settings → API). The anon key is safe
// to expose client-side — it only has the access your RLS policies grant it.

const SUPABASE_URL = 'https://umdvnqhyilgzfodxncmy.supabase.co';
const SUPABASE_ANON_KEY = 'sb_publishable_NEpLhRiayZU-YKd7Vioq_A_QEnNtThK';

const supabaseClient = window.supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);

// Redirect a signed-in user away from auth pages, and gate dashboard pages
// for signed-out users. Call from each page as needed.
async function requireGuest(redirectTo = '../pages/dashboard.html') {
  const { data: { session } } = await supabaseClient.auth.getSession();
  if (session) window.location.href = redirectTo;
}

async function requireAuth(redirectTo = 'login.html') {
  const { data: { session } } = await supabaseClient.auth.getSession();
  if (!session) window.location.href = redirectTo;
  return session;
}
