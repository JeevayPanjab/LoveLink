// LoveLink — discover.js

let deck = [];
let deckIndex = 0;

async function loadDeck() {
  const userId = currentSession.user.id;

  // People I've already swiped on
  const { data: swiped } = await supabaseClient
    .from('swipes')
    .select('target_id')
    .eq('swiper_id', userId);
  const excludeIds = new Set((swiped || []).map(s => s.target_id));
  excludeIds.add(userId);

  let query = supabaseClient.from('profiles').select('*').eq('onboarding_done', true).limit(20);

  const myGender = currentProfile?.gender;
  const myInterests = currentProfile?.interested_in || [];
  if (myInterests.length && !myInterests.includes('everyone')) {
    query = query.in('gender', myInterests);
  }

  const { data: candidates } = await query;
  deck = (candidates || []).filter(p => !excludeIds.has(p.id));
  deckIndex = 0;
  renderDeck();
}

function renderDeck() {
  const container = document.getElementById('swipeDeck');
  const remaining = deck.slice(deckIndex, deckIndex + 3);

  if (remaining.length === 0) {
    container.innerHTML = `
      <div class="deck-empty">
        <div class="icon">🌙</div>
        <p>You're all caught up. Check back later for new people.</p>
      </div>`;
    return;
  }

  container.innerHTML = remaining.map((p, i) => {
    const pos = remaining.length - 1 - i; // last in array = top card
    const layerClass = pos === 0 ? 'top' : pos === 1 ? 'behind-1' : 'behind-2';
    const photo = p.photo_urls?.[0];
    return `
      <div class="swipe-card ${layerClass}" data-id="${p.id}">
        <div class="photo-area" style="${photo ? `background-image:url('${photo}'); background-size:cover; background-position:center;` : ''}"></div>
        <span class="swipe-tag like">LIKE</span>
        <span class="swipe-tag nope">NOPE</span>
        <div class="info">
          <h2>${p.full_name || 'LoveLink member'}${p.age ? `, ${p.age}` : ''}</h2>
          <div class="distance">${p.location_city || 'Nearby'}</div>
          ${p.bio ? `<div class="bio">${p.bio}</div>` : ''}
        </div>
      </div>`;
  }).join('');

  attachDrag(container.querySelector('.swipe-card.top'));
}

function attachDrag(card) {
  if (!card) return;
  let startX = 0, currentX = 0, dragging = false;

  const onDown = (x) => { dragging = true; startX = x; card.style.transition = 'none'; };
  const onMove = (x) => {
    if (!dragging) return;
    currentX = x - startX;
    card.style.transform = `translateX(${currentX}px) rotate(${currentX / 20}deg)`;
    const likeTag = card.querySelector('.swipe-tag.like');
    const nopeTag = card.querySelector('.swipe-tag.nope');
    likeTag.style.opacity = currentX > 30 ? Math.min(currentX / 100, 1) : 0;
    nopeTag.style.opacity = currentX < -30 ? Math.min(-currentX / 100, 1) : 0;
  };
  const onUp = () => {
    if (!dragging) return;
    dragging = false;
    card.style.transition = '';
    if (currentX > 110) resolveSwipe('like');
    else if (currentX < -110) resolveSwipe('pass');
    else card.style.transform = '';
    currentX = 0;
  };

  card.addEventListener('mousedown', (e) => onDown(e.clientX));
  window.addEventListener('mousemove', (e) => onMove(e.clientX));
  window.addEventListener('mouseup', onUp);

  card.addEventListener('touchstart', (e) => onDown(e.touches[0].clientX));
  card.addEventListener('touchmove', (e) => onMove(e.touches[0].clientX));
  card.addEventListener('touchend', onUp);
}

async function resolveSwipe(type) {
  const container = document.getElementById('swipeDeck');
  const card = container.querySelector('.swipe-card.top');
  if (!card) return;

  const targetId = card.dataset.id;
  const direction = type === 'pass' ? 'leaving-left' : type === 'super_like' ? 'leaving-up' : 'leaving-right';
  card.classList.add(direction);

  const userId = currentSession.user.id;
  const { data: matchResult } = await supabaseClient.rpc('record_swipe', {
    p_target_id: targetId,
    p_type: type
  }).select();

  if (type !== 'pass') {
    spawnHeartBurst(type === 'super_like' ? '⭐' : '💜');
  }
  if (matchResult && matchResult.matched) {
    showToast("It's a match! 💜");
  }

  setTimeout(() => {
    deckIndex += 1;
    renderDeck();
  }, 300);
}

function spawnHeartBurst(emoji) {
  const el = document.createElement('div');
  el.className = 'heart-burst';
  el.textContent = emoji;
  el.style.left = '50%';
  el.style.top = '40%';
  el.style.transform = 'translate(-50%, -50%)';
  document.body.appendChild(el);
  setTimeout(() => el.remove(), 700);
}

document.getElementById('btnPass').addEventListener('click', () => resolveSwipe('pass'));
document.getElementById('btnLike').addEventListener('click', () => resolveSwipe('like'));
document.getElementById('btnSuper').addEventListener('click', () => resolveSwipe('super_like'));

(async function start() {
  const shell = await initAppShell();
  if (!shell) return;
  await loadDeck();
})();
