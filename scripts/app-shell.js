// LoveLink — shared app shell (auth guard, sidebar, toast)
// Depends on supabase-client.js. Include on every page inside /pages that
// uses the .app-shell layout, BEFORE the page's own script.

let currentSession = null;
let currentProfile = null;

async function initAppShell() {
  currentSession = await requireAuth();
  if (!currentSession) return null;

  const { data: profile } = await supabaseClient
    .from('profiles')
    .select('*')
    .eq('id', currentSession.user.id)
    .single();

  currentProfile = profile;

  const nameEl = document.getElementById('sidebarName');
  const planEl = document.getElementById('sidebarPlan');
  const avatarEl = document.getElementById('sidebarAvatar');
  const greetingEl = document.getElementById('greeting');

  if (nameEl) nameEl.textContent = profile?.full_name || 'Your profile';
  if (planEl) planEl.textContent = profile?.is_premium ? 'Premium member' : 'Free plan';
  if (avatarEl && profile?.photo_urls?.[0]) avatarEl.src = profile.photo_urls[0];
  if (greetingEl && profile?.full_name) {
    greetingEl.textContent = `Welcome back, ${profile.full_name.split(' ')[0]}`;
  }

  // Show the Admin sidebar link only for accounts with is_admin = true
  const adminLink = document.getElementById('adminNavLink');
  if (adminLink) adminLink.classList.toggle('hidden', !profile?.is_admin);

  // Mark online + keep last_seen fresh
  await supabaseClient.from('profiles').update({ is_online: true, last_seen_at: new Date().toISOString() }).eq('id', currentSession.user.id);
  window.addEventListener('beforeunload', () => {
    navigator.sendBeacon && supabaseClient.from('profiles').update({ is_online: false }).eq('id', currentSession.user.id);
  });

  document.getElementById('logoutBtn')?.addEventListener('click', async () => {
    await supabaseClient.from('profiles').update({ is_online: false }).eq('id', currentSession.user.id);
    await supabaseClient.auth.signOut();
    // Admin page lives one folder deeper (pages/admin/), so it needs an extra ../
    const isAdminPage = window.location.pathname.includes('/pages/admin/');
    window.location.href = isAdminPage ? '../../index.html' : '../index.html';
  });

  return { session: currentSession, profile };
}

function showToast(message) {
  let toast = document.querySelector('.toast');
  if (!toast) {
    toast = document.createElement('div');
    toast.className = 'toast';
    document.body.appendChild(toast);
  }
  toast.textContent = message;
  toast.classList.add('show');
  clearTimeout(toast._timer);
  toast._timer = setTimeout(() => toast.classList.remove('show'), 2600);
}

document.addEventListener('DOMContentLoaded', initAppShell);

// Highlight the matching link in the mobile bottom nav (new — additive only)
function highlightBottomNav() {
  const current = window.location.pathname.split('/').pop() || 'dashboard.html';
  document.querySelectorAll('.bottom-nav-list a').forEach(a => {
    a.classList.toggle('active', a.getAttribute('href') === current);
  });
}

document.addEventListener('DOMContentLoaded', highlightBottomNav);
