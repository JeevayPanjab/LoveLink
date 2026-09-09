// LoveLink — chat.js

let activeThreadId = null; // the other user's id
let messageChannel = null;
let typingChannel = null;
let typingTimeout = null;

function urlParam(name) {
  return new URLSearchParams(window.location.search).get(name);
}

async function loadThreads() {
  const userId = currentSession.user.id;

  const { data: matches } = await supabaseClient
    .from('matches')
    .select('id, user_a, user_b')
    .or(`user_a.eq.${userId},user_b.eq.${userId}`);

  if (!matches || matches.length === 0) {
    document.getElementById('threadItems').innerHTML =
      '<p style="padding:16px; color:var(--text-muted); font-size:13px;">No conversations yet.</p>';
    return;
  }

  const otherIds = matches.map(m => (m.user_a === userId ? m.user_b : m.user_a));
  const { data: profiles } = await supabaseClient
    .from('profiles')
    .select('id, full_name, photo_urls, is_online')
    .in('id', otherIds);

  // Last message + unread count per thread, sequential (thread count is small per user)
  const threads = [];
  for (const p of profiles) {
    const { data: lastMsg } = await supabaseClient
      .from('messages')
      .select('content, created_at, sender_id')
      .or(`and(sender_id.eq.${userId},recipient_id.eq.${p.id}),and(sender_id.eq.${p.id},recipient_id.eq.${userId})`)
      .order('created_at', { ascending: false })
      .limit(1);

    const { count: unread } = await supabaseClient
      .from('messages')
      .select('*', { count: 'exact', head: true })
      .eq('sender_id', p.id)
      .eq('recipient_id', userId)
      .eq('is_read', false);

    threads.push({ profile: p, lastMsg: lastMsg?.[0], unread: unread || 0 });
  }

  threads.sort((a, b) => new Date(b.lastMsg?.created_at || 0) - new Date(a.lastMsg?.created_at || 0));

  const container = document.getElementById('threadItems');
  container.innerHTML = threads.map(t => `
    <div class="thread-item" data-id="${t.profile.id}" data-name="${t.profile.full_name || ''}">
      <div class="avatar-wrap" style="position:relative;">
        <img class="avatar" src="${t.profile.photo_urls?.[0] || ''}" alt="">
        ${t.profile.is_online ? '<span class="online-dot"></span>' : ''}
      </div>
      <div class="meta">
        <strong>${t.profile.full_name || 'LoveLink member'}</strong>
        <span>${t.lastMsg ? t.lastMsg.content : 'Say hi 👋'}</span>
      </div>
      ${t.unread > 0 ? `<span class="unread">${t.unread}</span>` : ''}
    </div>
  `).join('');

  container.querySelectorAll('.thread-item').forEach(item => {
    item.addEventListener('click', () => openThread(item.dataset.id, item.dataset.name, item));
  });

  const preselect = urlParam('with');
  if (preselect) {
    const match = container.querySelector(`.thread-item[data-id="${preselect}"]`);
    if (match) match.click();
  }
}

async function openThread(otherId, otherName, itemEl) {
  activeThreadId = otherId;
  document.querySelectorAll('.thread-item').forEach(el => el.classList.remove('active'));
  itemEl?.classList.add('active');

  const userId = currentSession.user.id;

  document.getElementById('chatWindow').innerHTML = `
    <div class="chat-header">
      <img class="avatar" id="chatAvatar" alt="">
      <div>
        <strong>${otherName || 'LoveLink member'}</strong>
        <div class="status" id="chatStatus"></div>
      </div>
    </div>
    <div class="chat-messages" id="chatMessages"></div>
    <div id="typingRow"></div>
    <div class="chat-input-row">
      <input type="text" id="chatInput" placeholder="Type a message…" autocomplete="off">
      <button id="chatSend">➤</button>
    </div>
  `;

  const { data: msgs } = await supabaseClient
    .from('messages')
    .select('*')
    .or(`and(sender_id.eq.${userId},recipient_id.eq.${otherId}),and(sender_id.eq.${otherId},recipient_id.eq.${userId})`)
    .order('created_at', { ascending: true });

  renderMessages(msgs || [], userId);

  // Mark incoming messages as read
  await supabaseClient.from('messages').update({ is_read: true }).eq('sender_id', otherId).eq('recipient_id', userId).eq('is_read', false);

  subscribeToThread(otherId, userId);

  document.getElementById('chatSend').addEventListener('click', () => sendMessage(otherId, userId));
  document.getElementById('chatInput').addEventListener('keydown', (e) => {
    if (e.key === 'Enter') sendMessage(otherId, userId);
    else broadcastTyping(otherId, userId);
  });
}

function renderMessages(msgs, userId) {
  const box = document.getElementById('chatMessages');
  box.innerHTML = msgs.map(m => `
    <div class="bubble ${m.sender_id === userId ? 'out' : 'in'}">
      ${m.content}
      <span class="time">${new Date(m.created_at).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}</span>
    </div>
  `).join('');
  box.scrollTop = box.scrollHeight;
}

async function sendMessage(otherId, userId) {
  const input = document.getElementById('chatInput');
  const content = input.value.trim();
  if (!content) return;
  input.value = '';

  await supabaseClient.from('messages').insert({ sender_id: userId, recipient_id: otherId, content });
}

function subscribeToThread(otherId, userId) {
  if (messageChannel) supabaseClient.removeChannel(messageChannel);
  if (typingChannel) supabaseClient.removeChannel(typingChannel);

  const roomId = [userId, otherId].sort().join('_');

  messageChannel = supabaseClient
    .channel(`messages-${roomId}`)
    .on('postgres_changes', {
      event: 'INSERT', schema: 'public', table: 'messages',
      filter: `recipient_id=eq.${userId}`
    }, async (payload) => {
      if (payload.new.sender_id !== otherId) return;
      const box = document.getElementById('chatMessages');
      box.insertAdjacentHTML('beforeend', `
        <div class="bubble in">${payload.new.content}
          <span class="time">${new Date(payload.new.created_at).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}</span>
        </div>`);
      box.scrollTop = box.scrollHeight;
      await supabaseClient.from('messages').update({ is_read: true }).eq('id', payload.new.id);
    })
    .subscribe();

  typingChannel = supabaseClient
    .channel(`typing-${roomId}`)
    .on('broadcast', { event: 'typing' }, (payload) => {
      if (payload.payload.from !== userId) showTypingIndicator();
    })
    .subscribe();
}

function broadcastTyping(otherId, userId) {
  typingChannel?.send({ type: 'broadcast', event: 'typing', payload: { from: userId } });
}

function showTypingIndicator() {
  const row = document.getElementById('typingRow');
  if (!row) return;
  row.innerHTML = '<div class="typing-indicator">Typing…</div>';
  clearTimeout(typingTimeout);
  typingTimeout = setTimeout(() => (row.innerHTML = ''), 2000);
}

(async function start() {
  const shell = await initAppShell();
  if (!shell) return;
  await loadThreads();
})();
