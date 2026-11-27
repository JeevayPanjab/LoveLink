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
  // No photo → initial-letter avatar (an <img> with no src shows a
  // broken-image icon).
  if (avatarEl) avatarEl.src = profile?.photo_urls?.[0] || avatarDataUri(profile?.full_name);
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

// Data-URI SVG avatar with the person's initial — used when a profile has
// no photo, so an <img> never gets an empty src (broken-image icon).
// Defined here (app-shell.js loads before the page scripts that use it).
function avatarDataUri(name) {
  const initial = (name || 'L').trim().charAt(0).toUpperCase();
  const svg = '<svg xmlns="http://www.w3.org/2000/svg" width="72" height="72">'
    + '<rect width="72" height="72" fill="#7B2FF7"/>'
    + '<text x="36" y="48" font-family="Arial, sans-serif" font-size="34" font-weight="700" fill="#fff" text-anchor="middle">' + initial + '</text></svg>';
  return 'data:image/svg+xml,' + encodeURIComponent(svg);
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

/* ---------------------------------------------------------------------------
   Mobile bottom navigation + "More" sheet (with Log out).
   Built from the sidebar's own links so paths are right on every page
   (including pages/admin/). Does nothing if the page has no sidebar.
   If the page already has a static bottom nav in its HTML, that nav is
   used as the bar (only the "More" button + sheet are added) so phones
   never get two bottom bars. CSS only shows it on screens <= 960px,
   where the sidebar is hidden.
   --------------------------------------------------------------------------- */
// "More" sheet (remaining links + Log out) shared by the injected bar and
// by a page's own static bottom nav.
function attachMoreSheet(restLinks, iconOf) {
  const backdrop = document.createElement('div');
  backdrop.id = 'mobileSheetBackdrop';
  backdrop.className = 'mobile-sheet-backdrop';

  const sheet = document.createElement('div');
  sheet.id = 'mobileSheet';
  sheet.className = 'mobile-sheet';
  sheet.innerHTML = `
    <div class="who"><strong id="mobileSheetName"></strong><span id="mobileSheetPlan"></span></div>
    ${restLinks.map(a => `<a href="${a.getAttribute('href')}" class="${a.classList.contains('hidden') ? 'hidden' : ''}" data-admin="${a.id === 'adminNavLink'}"><span class="ic">${iconOf(a)}</span> ${a.textContent.replace(iconOf(a), '').trim()}</a>`).join('')}
    <button type="button" class="logout" id="mobileLogoutBtn"><span class="ic">⎋</span> Log out</button>`;

  document.body.append(backdrop, sheet);

  const close = () => { sheet.classList.remove('open'); backdrop.classList.remove('open'); };
  document.getElementById('mobileMoreBtn').addEventListener('click', () => {
    // Refresh name/plan/admin-link visibility (filled in by initAppShell after load)
    sheet.querySelector('#mobileSheetName').textContent = document.getElementById('sidebarName')?.textContent || '';
    sheet.querySelector('#mobileSheetPlan').textContent = document.getElementById('sidebarPlan')?.textContent || '';
    const sideAdmin = document.getElementById('adminNavLink');
    const sheetAdmin = sheet.querySelector('a[data-admin="true"]');
    if (sideAdmin && sheetAdmin) sheetAdmin.classList.toggle('hidden', sideAdmin.classList.contains('hidden'));
    sheet.classList.add('open'); backdrop.classList.add('open');
  });
  backdrop.addEventListener('click', close);
  // Reuse the existing logout handler on the (hidden) sidebar button
  document.getElementById('mobileLogoutBtn').addEventListener('click', () => {
    close();
    document.getElementById('logoutBtn')?.click();
  });
}

function injectMobileNav() {
  const sidebar = document.querySelector('.sidebar');
  if (!sidebar) return;

  // Let iOS expose the bottom safe-area inset (home indicator)
  const vp = document.querySelector('meta[name="viewport"]');
  if (vp && !/viewport-fit/.test(vp.content)) vp.content += ', viewport-fit=cover';

  const links = Array.from(sidebar.querySelectorAll('nav a'));
  const mainFiles = ['dashboard.html', 'discover.html', 'matches.html', 'messages.html', 'profile-setup.html'];
  const labels = { 'dashboard.html': 'Home', 'discover.html': 'Discover', 'matches.html': 'Matches', 'messages.html': 'Chats', 'profile-setup.html': 'Profile' };
  const fileOf = (a) => (a.getAttribute('href') || '').split('/').pop();
  const iconOf = (a) => (a.querySelector('.ic')?.textContent || '').trim();

  const mainLinks = links.filter(a => mainFiles.includes(fileOf(a)));
  // Admin pages have no main links — show their own sidebar links instead
  const barLinks = mainLinks.length ? mainLinks : links;
  const restLinks = mainLinks.length ? links.filter(a => !mainLinks.includes(a)) : [];

  // The app pages already carry a static bottom nav in their HTML — use
  // it as the bar instead of injecting a second one (two bars would
  // double the bottom navigation on phones). Only the "More" button and
  // its sheet are added to it.
  const staticNav = document.querySelector('.app-shell .bottom-nav');
  if (staticNav) {
    if (document.getElementById('mobileMoreBtn')) return;
    const current = window.location.pathname.split('/').pop();
    staticNav.querySelectorAll('a').forEach(a => {
      if (fileOf(a) === current) a.classList.add('active');
    });
    const list = staticNav.querySelector('.bottom-nav-list') || staticNav;
    const moreBtn = document.createElement('button');
    moreBtn.type = 'button';
    moreBtn.id = 'mobileMoreBtn';
    moreBtn.setAttribute('aria-label', 'More');
    moreBtn.innerHTML = '<span class="ic">☰</span><span>More</span>';
    list.appendChild(moreBtn);
    attachMoreSheet(restLinks, iconOf);
    return;
  }

  if (document.getElementById('mobileNav')) return;

  const nav = document.createElement('nav');
  nav.id = 'mobileNav';
  nav.className = 'mobile-nav';
  nav.innerHTML = barLinks.map(a => `
    <a href="${a.getAttribute('href')}" class="${a.classList.contains('active') ? 'active' : ''}">
      <span class="ic">${iconOf(a)}</span><span>${labels[fileOf(a)] || a.textContent.replace(iconOf(a), '').trim()}</span>
    </a>`).join('') + `
    <button type="button" id="mobileMoreBtn" aria-label="More"><span class="ic">☰</span><span>More</span></button>`;

  document.body.append(nav);
  attachMoreSheet(restLinks, iconOf);
}

document.addEventListener('DOMContentLoaded', injectMobileNav);
