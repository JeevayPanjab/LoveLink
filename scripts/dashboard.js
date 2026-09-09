// LoveLink — dashboard.js

async function loadDashboard() {
  const shell = await initAppShell();
  if (!shell) return;
  const userId = shell.session.user.id;

  // New likes received (people who liked me, I haven't acted on yet)
  const { count: likeCount } = await supabaseClient
    .from('likes')
    .select('*', { count: 'exact', head: true })
    .eq('liked_id', userId);

  // Matches
  const { data: matches, count: matchCount } = await supabaseClient
    .from('matches')
    .select('id, user_a, user_b, created_at', { count: 'exact' })
    .or(`user_a.eq.${userId},user_b.eq.${userId}`)
    .order('created_at', { ascending: false })
    .limit(8);

  // Unread messages
  const { count: unreadCount } = await supabaseClient
    .from('messages')
    .select('*', { count: 'exact', head: true })
    .eq('recipient_id', userId)
    .eq('is_read', false);

  document.getElementById('statLikes').textContent = likeCount ?? 0;
  document.getElementById('statMatches').textContent = matchCount ?? 0;
  document.getElementById('statMessages').textContent = unreadCount ?? 0;
  document.getElementById('statViews').textContent = '—'; // profile_views tracking is a future enhancement
  document.getElementById('unreadCount').textContent = unreadCount ?? 0;

  if (!matches || matches.length === 0) {
    document.getElementById('recentMatches').innerHTML =
      '<p style="color:var(--text-muted); font-size:14px;">No matches yet — head to Discover to start swiping.</p>';
    return;
  }

  const otherIds = matches.map(m => (m.user_a === userId ? m.user_b : m.user_a));
  const { data: otherProfiles } = await supabaseClient
    .from('profiles')
    .select('id, full_name, photo_urls')
    .in('id', otherIds);

  const grid = document.getElementById('recentMatches');
  grid.innerHTML = otherProfiles.map(p => `
    <a href="messages.html?with=${p.id}" class="match-tile">
      <div class="photo" style="${p.photo_urls?.[0] ? `background-image:url('${p.photo_urls[0]}'); background-size:cover; background-position:center;` : ''}"></div>
      <div class="label">${p.full_name || 'LoveLink member'}</div>
    </a>
  `).join('');
}

loadDashboard();
