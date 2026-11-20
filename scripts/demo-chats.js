// LoveLink — Demo Chats (admin dashboard tab)
// Lets the admin read and reply to conversations between demo/seed users
// (profiles.is_demo = true) and real users, AS the demo user. All data goes
// through the 'demo-chats' edge function (service role, admin-checked) —
// the admin never impersonates anyone client-side and no RLS change is needed.
// Depends on supabase-client.js, app-shell.js and admin.js (guardAdmin).
// Loaded after admin.js on pages/admin/index.html.
//
// SECURITY: every piece of user-supplied text (names, message content) is
// rendered with textContent or escapeHtml — never raw innerHTML. (The rest of
// the codebase still interpolates user text into innerHTML; this file does not.)

let demoActiveThread = null; // { demoId, userId, demoName, userName }

function escapeHtml(value) {
  return String(value ?? '').replace(/[&<>"']/g, (c) => ({
    '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;',
  }[c]));
}

function el(tag, className, text) {
  const node = document.createElement(tag);
  if (className) node.className = className;
  if (text !== undefined && text !== null) node.textContent = text;
  return node;
}

function safePhotoUrl(photoUrls) {
  const url = Array.isArray(photoUrls) && photoUrls[0];
  return typeof url === 'string' && url.startsWith('http') ? url : '';
}

function formatTime(iso) {
  try {
    return new Date(iso).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
  } catch {
    return '';
  }
}

async function callDemoChats(body) {
  const { data, error } = await supabaseClient.functions.invoke('demo-chats', { body });
  if (error) throw new Error(error.message || 'Request failed');
  if (data && data.error) throw new Error(data.error);
  return data || {};
}

async function loadDemoThreads() {
  const listEl = document.getElementById('demoThreadList');
  if (!listEl) return;
  listEl.textContent = '';
  listEl.appendChild(el('p', null, 'Loading…')).style.cssText = 'padding:16px; color:var(--text-muted); font-size:13px;';

  let res;
  try {
    res = await callDemoChats({ action: 'list-threads' });
  } catch (err) {
    listEl.textContent = '';
    const p = el('p', null, 'Could not load demo chats: ' + err.message);
    p.style.cssText = 'padding:16px; color:var(--text-muted); font-size:13px;';
    listEl.appendChild(p);
    return;
  }

  const threads = res.threads || [];
  listEl.textContent = '';
  if (threads.length === 0) {
    const p = el('p', null, 'No demo conversations yet. When a real user messages a demo user, the chat shows up here.');
    p.style.cssText = 'padding:16px; color:var(--text-muted); font-size:13px;';
    listEl.appendChild(p);
    return;
  }

  for (const t of threads) {
    const item = el('div', 'thread-item');
    item.dataset.demoId = t.demo.id;
    item.dataset.userId = t.user.id;
    item.dataset.demoName = t.demo.full_name || 'Demo user';
    item.dataset.userName = t.user.full_name || 'LoveLink member';
    if (demoActiveThread && demoActiveThread.demoId === t.demo.id && demoActiveThread.userId === t.user.id) {
      item.classList.add('active');
    }

    const avatarWrap = el('div', 'avatar-wrap');
    avatarWrap.style.position = 'relative';
    const avatar = el('img', 'avatar');
    avatar.alt = '';
    avatar.src = safePhotoUrl(t.demo.photo_urls);
    avatarWrap.appendChild(avatar);
    item.appendChild(avatarWrap);

    const meta = el('div', 'meta');
    meta.appendChild(el('strong', null, t.user.full_name || 'LoveLink member'));
    const sub = el('span', null, (t.lastFromDemo ? 'You (as ' + (t.demo.full_name || 'demo') + '): ' : '') + (t.lastMessage || ''));
    meta.appendChild(sub);
    const asLine = el('span', null, 'as ' + (t.demo.full_name || 'Demo user'));
    asLine.style.color = 'var(--text-faint)';
    meta.appendChild(asLine);
    item.appendChild(meta);

    if (t.unread > 0) {
      item.appendChild(el('span', 'unread', String(t.unread)));
    }

    item.addEventListener('click', () => openDemoThread(t.demo, t.user, item));
    listEl.appendChild(item);
  }
}

async function openDemoThread(demo, user, itemEl) {
  demoActiveThread = {
    demoId: demo.id,
    userId: user.id,
    demoName: demo.full_name || 'Demo user',
    userName: user.full_name || 'LoveLink member',
  };
  document.querySelectorAll('#demoThreadList .thread-item').forEach((node) => node.classList.remove('active'));
  itemEl.classList.add('active');
  // Phones: show the chat window; the back button returns to the list.
  document.querySelector('#tabDemoChats .chat-shell')?.classList.add('thread-open');

  const headerName = document.getElementById('demoChatName');
  if (headerName) headerName.textContent = demoActiveThread.userName;
  const headerSub = document.getElementById('demoChatSub');
  if (headerSub) headerSub.textContent = 'Replying as ' + demoActiveThread.demoName;
  const headerAvatar = document.getElementById('demoChatAvatar');
  if (headerAvatar) headerAvatar.src = safePhotoUrl(user.photo_urls);

  const box = document.getElementById('demoChatMessages');
  if (box) {
    box.textContent = '';
    box.appendChild(el('p', null, 'Loading…')).style.cssText = 'color:var(--text-muted); font-size:13px;';
  }
  document.getElementById('demoChatInputRow')?.classList.remove('hidden');

  let res;
  try {
    res = await callDemoChats({ action: 'get-thread', demo_user_id: demo.id, other_id: user.id });
  } catch (err) {
    showToast('Could not load this conversation.');
    return;
  }

  renderDemoMessages(res.messages || [], demo.id);

  // Mark the real user's messages as read, then refresh the unread badges.
  try {
    await callDemoChats({ action: 'mark-read', demo_user_id: demo.id, other_id: user.id });
    loadDemoThreads();
  } catch {
    /* badges stay as-is; not fatal */
  }
}

function renderDemoMessages(messages, demoId) {
  const box = document.getElementById('demoChatMessages');
  if (!box) return;
  box.textContent = '';
  if (messages.length === 0) {
    box.appendChild(el('p', null, 'No messages in this conversation yet.')).style.cssText = 'color:var(--text-muted); font-size:13px;';
    return;
  }
  for (const m of messages) {
    const bubble = el('div', 'bubble ' + (m.sender_id === demoId ? 'out' : 'in'), m.content);
    bubble.appendChild(el('span', 'time', formatTime(m.created_at)));
    box.appendChild(bubble);
  }
  box.scrollTop = box.scrollHeight;
}

async function sendDemoMessage() {
  if (!demoActiveThread) return;
  const input = document.getElementById('demoChatInput');
  const content = input.value.trim();
  if (!content) return;
  input.value = '';

  let res;
  try {
    res = await callDemoChats({
      action: 'send',
      demo_user_id: demoActiveThread.demoId,
      recipient_id: demoActiveThread.userId,
      content,
    });
  } catch (err) {
    showToast(err.message || 'Message could not be sent.');
    input.value = content;
    return;
  }

  const box = document.getElementById('demoChatMessages');
  if (box && res.message) {
    const empty = box.querySelector('p');
    if (empty && box.children.length === 1) box.textContent = '';
    const bubble = el('div', 'bubble out', res.message.content);
    bubble.appendChild(el('span', 'time', formatTime(res.message.created_at)));
    box.appendChild(bubble);
    box.scrollTop = box.scrollHeight;
  }
  loadDemoThreads();
}

(async function initDemoChats() {
  const shell = await guardAdmin();
  if (!shell) return;

  document.querySelector('button[data-tab="demoChats"]')?.addEventListener('click', loadDemoThreads);
  document.getElementById('demoChatBack')?.addEventListener('click', () => {
    document.querySelector('#tabDemoChats .chat-shell')?.classList.remove('thread-open');
  });
  document.getElementById('demoChatSend')?.addEventListener('click', sendDemoMessage);
  document.getElementById('demoChatInput')?.addEventListener('keydown', (e) => {
    if (e.key === 'Enter') sendDemoMessage();
  });
})();
