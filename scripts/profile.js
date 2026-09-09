// LoveLink — profile-setup.js

const PHOTO_SLOTS = 6;
let photoUrls = [];
let selectedInterests = [];

function buildPhotoGrid() {
  const grid = document.getElementById('photoGrid');
  grid.innerHTML = '';
  for (let i = 0; i < PHOTO_SLOTS; i++) {
    const slot = document.createElement('div');
    slot.className = 'photo-slot';
    slot.dataset.index = i;
    const existing = photoUrls[i];
    slot.innerHTML = `
      ${existing ? `<img src="${existing}">` : '➕'}
      <input type="file" accept="image/*" data-index="${i}">
      <button type="button" class="remove" data-index="${i}">✕</button>
    `;
    if (existing) slot.classList.add('filled');
    grid.appendChild(slot);
  }

  grid.querySelectorAll('input[type=file]').forEach(input => {
    input.addEventListener('change', (e) => handlePhotoSelect(e, parseInt(input.dataset.index)));
  });
  grid.querySelectorAll('.remove').forEach(btn => {
    btn.addEventListener('click', (e) => {
      e.preventDefault();
      const idx = parseInt(btn.dataset.index);
      photoUrls[idx] = null;
      buildPhotoGrid();
    });
  });
}

// Center-crop the selected image to a 3:4 portrait square before upload,
// so every card in the deck is visually consistent.
function cropImageToPortrait(file) {
  return new Promise((resolve) => {
    const img = new Image();
    const reader = new FileReader();
    reader.onload = (e) => (img.src = e.target.result);
    img.onload = () => {
      const targetRatio = 3 / 4;
      let sx = 0, sy = 0, sw = img.width, sh = img.height;
      const currentRatio = sw / sh;
      if (currentRatio > targetRatio) {
        sw = sh * targetRatio;
        sx = (img.width - sw) / 2;
      } else {
        sh = sw / targetRatio;
        sy = (img.height - sh) / 2;
      }
      const canvas = document.createElement('canvas');
      canvas.width = 720;
      canvas.height = 960;
      const ctx = canvas.getContext('2d');
      ctx.drawImage(img, sx, sy, sw, sh, 0, 0, canvas.width, canvas.height);
      canvas.toBlob((blob) => resolve(blob), 'image/jpeg', 0.88);
    };
    reader.readAsDataURL(file);
  });
}

async function handlePhotoSelect(event, index) {
  const file = event.target.files[0];
  if (!file) return;

  const blob = await cropImageToPortrait(file);
  const userId = currentSession.user.id;
  const path = `${userId}/photo-${index}-${Date.now()}.jpg`;

  const { error } = await supabaseClient.storage.from('profile-photos').upload(path, blob, {
    contentType: 'image/jpeg',
    upsert: true
  });

  if (error) {
    showToast('Photo upload failed — try again.');
    return;
  }

  const { data } = supabaseClient.storage.from('profile-photos').getPublicUrl(path);
  photoUrls[index] = data.publicUrl;
  buildPhotoGrid();
  showToast('Photo added.');
}

function populateForm(profile) {
  if (!profile) return;
  const form = document.getElementById('profileForm');
  form.full_name.value = profile.full_name || '';
  form.username.value = profile.username || '';
  form.age.value = profile.age || '';
  form.height_cm.value = profile.height_cm || '';
  form.gender.value = profile.gender || '';
  form.relationship_goal.value = profile.relationship_goal || '';
  form.location_city.value = profile.location_city || '';
  form.occupation.value = profile.occupation || '';
  form.education.value = profile.education || '';
  form.languages.value = (profile.languages || []).join(', ');
  form.hobbies.value = (profile.hobbies || []).join(', ');
  form.bio.value = profile.bio || '';

  photoUrls = [...(profile.photo_urls || [])];
  buildPhotoGrid();

  selectedInterests = profile.interested_in || [];
  document.querySelectorAll('#interestedInChips .chip').forEach(chip => {
    chip.classList.toggle('selected', selectedInterests.includes(chip.dataset.value));
  });
}

async function loadProfileSetup() {
  const shell = await initAppShell();
  if (!shell) return;
  buildPhotoGrid();
  populateForm(shell.profile);
}

document.querySelectorAll('#interestedInChips .chip').forEach(chip => {
  chip.addEventListener('click', () => {
    const value = chip.dataset.value;
    if (selectedInterests.includes(value)) {
      selectedInterests = selectedInterests.filter(v => v !== value);
    } else {
      selectedInterests.push(value);
    }
    chip.classList.toggle('selected');
  });
});

document.getElementById('profileForm').addEventListener('submit', async (event) => {
  event.preventDefault();
  const form = event.target;
  const messageEl = form.querySelector('.form-message');
  const submitBtn = form.querySelector('button[type="submit"]');
  submitBtn.disabled = true;
  submitBtn.textContent = 'Saving…';

  const updates = {
    full_name: form.full_name.value.trim(),
    username: form.username.value.trim() || null,
    age: parseInt(form.age.value) || null,
    height_cm: parseInt(form.height_cm.value) || null,
    gender: form.gender.value || null,
    relationship_goal: form.relationship_goal.value || null,
    interested_in: selectedInterests,
    location_city: form.location_city.value.trim(),
    occupation: form.occupation.value.trim(),
    education: form.education.value.trim(),
    languages: form.languages.value.split(',').map(s => s.trim()).filter(Boolean),
    hobbies: form.hobbies.value.split(',').map(s => s.trim()).filter(Boolean),
    bio: form.bio.value.trim(),
    photo_urls: photoUrls.filter(Boolean),
    onboarding_done: true
  };

  const { error } = await supabaseClient
    .from('profiles')
    .update(updates)
    .eq('id', currentSession.user.id);

  submitBtn.disabled = false;
  submitBtn.textContent = 'Save profile';

  if (error) {
    messageEl.textContent = error.message;
    messageEl.className = 'form-message show error';
    return;
  }

  messageEl.textContent = 'Profile saved.';
  messageEl.className = 'form-message show success';
});

loadProfileSetup();
