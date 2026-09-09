// LoveLink — admin.js
// Every query here relies on RLS policies that only grant access when
// profiles.is_admin = true for the requesting user (see supabase/schema-phase5.sql).

async function guardAdmin() {
  const shell = await initAppShell();
  if (!shell) return null;
  if (!shell.profile?.is_admin) {
    document.querySelector('.app-main').innerHTML = '<p style="padding:40px; color:var(--text-muted);">You don\'t have access to this page.</p>';
    return null;
  }
  return shell;
}

async function loadStats() {
  const { count: total } = await supabaseClient.from('profiles').select('*', { count: 'exact', head: true });
  const { count: premium } = await supabaseClient.from('profiles').select('*', { count: 'exact', head: true }).eq('is_premium', true);
  const weekAgo = new Date(Date.now() - 7 * 24 * 60 * 60 * 1000).toISOString();
  const { count: signups } = await supabaseClient.from('profiles').select('*', { count: 'exact', head: true }).gte('created_at', weekAgo);
  const { count: openReports } = await supabaseClient.from('reports').select('*', { count: 'exact', head: true }).eq('status', 'open');

  document.getElementById('statTotal').textContent = total ?? 0;
  document.getElementById('statPremium').textContent = premium ?? 0;
  document.getElementById('statSignups').textContent = signups ?? 0;
  document.getElementById('statReports').textContent = openReports ?? 0;
}

async function loadUsers(search = '') {
  let query = supabaseClient.from('profiles').select('id, full_name, username, gender, account_status, created_at, photo_urls').order('created_at', { ascending: false }).limit(50);
  if (search) query = query.or(`full_name.ilike.%${search}%,username.ilike.%${search}%`);
  const { data: users } = await query;

  document.getElementById('usersBody').innerHTML = (users || []).map(u => {
    const photo = u.photo_urls?.[0];
    const avatar = photo
      ? `<img src="${photo}" alt="" style="width:36px; height:36px; border-radius:50%; object-fit:cover; display:block;">`
      : `<div style="width:36px; height:36px; border-radius:50%; background:var(--glass); display:flex; align-items:center; justify-content:center; font-size:14px; color:var(--text-faint);">${(u.full_name || '?').charAt(0).toUpperCase()}</div>`;
    return `
    <tr>
      <td>${avatar}</td>
      <td>${u.full_name || '—'}${u.username ? ` <span style="color:var(--text-faint);">@${u.username}</span>` : ''}</td>
      <td>${u.gender || '—'}</td>
      <td>${new Date(u.created_at).toLocaleDateString()}</td>
      <td><span class="status-pill ${u.account_status}">${u.account_status}</span></td>
      <td class="row-actions">
        <button data-action="suspend" data-id="${u.id}">Suspend</button>
        <button data-action="ban" data-id="${u.id}">Ban</button>
        <button data-action="verify" data-id="${u.id}">Verify</button>
        <button data-action="delete" data-id="${u.id}">Delete</button>
      </td>
    </tr>
  `;
  }).join('');

  document.querySelectorAll('#usersBody button').forEach(btn => {
    btn.addEventListener('click', () => handleUserAction(btn.dataset.action, btn.dataset.id));
  });
}

async function handleUserAction(action, userId) {
  if (action === 'delete') {
    if (!confirm('Permanently delete this user\'s profile row? This does not remove their auth account.')) return;
    await supabaseClient.from('profiles').delete().eq('id', userId);
  } else if (action === 'verify') {
    await supabaseClient.from('profiles').update({ is_verified: true }).eq('id', userId);
  } else {
    const status = action === 'suspend' ? 'suspended' : 'banned';
    await supabaseClient.from('profiles').update({ account_status: status }).eq('id', userId);
  }
  showToast('Updated.');
  loadUsers(document.getElementById('userSearch').value.trim());
}

async function loadReports() {
  const { data: reports } = await supabaseClient
    .from('reports')
    .select('id, report_type, reason, status, reported_id, profiles!reports_reported_id_fkey(full_name)')
    .order('created_at', { ascending: false })
    .limit(50);

  document.getElementById('reportsBody').innerHTML = (reports || []).map(r => `
    <tr>
      <td>${r.report_type}</td>
      <td>${r.profiles?.full_name || r.reported_id}</td>
      <td>${r.reason || '—'}</td>
      <td><span class="status-pill ${r.status === 'open' ? 'suspended' : 'active'}">${r.status}</span></td>
      <td class="row-actions">
        <button data-report="${r.id}" data-status="resolved">Resolve</button>
        <button data-report="${r.id}" data-status="dismissed">Dismiss</button>
      </td>
    </tr>
  `).join('');

  document.querySelectorAll('#reportsBody button').forEach(btn => {
    btn.addEventListener('click', async () => {
      await supabaseClient.from('reports').update({ status: btn.dataset.status }).eq('id', btn.dataset.report);
      showToast('Report updated.');
      loadReports();
    });
  });
}

async function loadPayments() {
  const { data: payments } = await supabaseClient
    .from('payments')
    .select('id, plan, cycle, status, created_at, profiles(full_name)')
    .order('created_at', { ascending: false })
    .limit(50);

  document.getElementById('paymentsBody').innerHTML = (payments || []).map(p => `
    <tr>
      <td>${p.profiles?.full_name || '—'}</td>
      <td>${p.plan}</td>
      <td>${p.cycle}</td>
      <td><span class="status-pill ${p.status === 'success' ? 'active' : 'banned'}">${p.status}</span></td>
      <td>${new Date(p.created_at).toLocaleDateString()}</td>
    </tr>
  `).join('');
}

document.querySelectorAll('.admin-tabs button').forEach(btn => {
  btn.addEventListener('click', () => {
    document.querySelectorAll('.admin-tabs button').forEach(b => b.classList.remove('active'));
    btn.classList.add('active');
    ['users', 'reports', 'payments'].forEach(t => {
      document.getElementById(`tab${t[0].toUpperCase()}${t.slice(1)}`).style.display = t === btn.dataset.tab ? 'block' : 'none';
    });
  });
});

document.getElementById('userSearch')?.addEventListener('input', (e) => loadUsers(e.target.value.trim()));

(async function start() {
  const shell = await guardAdmin();
  if (!shell) return;
  await loadStats();
  await loadUsers();
  await loadReports();
  await loadPayments();
})();
