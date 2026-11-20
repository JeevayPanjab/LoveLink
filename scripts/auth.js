// LoveLink — Auth flows (Supabase Auth)
// Depends on supabase-client.js being loaded first.

function showMessage(el, text, type = 'error') {
  el.textContent = text;
  el.className = `form-message show ${type}`;
}

function setFieldError(fieldEl, message) {
  fieldEl.classList.add('has-error');
  const errorEl = fieldEl.querySelector('.field-error');
  if (errorEl) errorEl.textContent = message;
}

function clearFieldError(fieldEl) {
  fieldEl.classList.remove('has-error');
}

function setLoading(button, isLoading, loadingText = 'Please wait…') {
  if (isLoading) {
    button.dataset.originalText = button.textContent;
    button.textContent = loadingText;
    button.disabled = true;
  } else {
    button.textContent = button.dataset.originalText || button.textContent;
    button.disabled = false;
  }
}

/* ---------------------------- Email + password signup ---------------------------- */

async function handleSignup(event) {
  event.preventDefault();
  const form = event.target;
  const messageEl = form.querySelector('.form-message');
  const submitBtn = form.querySelector('button[type="submit"]');

  const name = form.name.value.trim();
  const email = form.email.value.trim();
  const password = form.password.value;

  let valid = true;
  if (name.length < 2) { setFieldError(form.name.closest('.field'), 'Enter your full name.'); valid = false; }
  if (!/^\S+@\S+\.\S+$/.test(email)) { setFieldError(form.email.closest('.field'), 'Enter a valid email.'); valid = false; }
  if (password.length < 8) { setFieldError(form.password.closest('.field'), 'Use at least 8 characters.'); valid = false; }
  if (!valid) return;

  setLoading(submitBtn, true, 'Creating your account…');

  const { data, error } = await supabaseClient.auth.signUp({
    email,
    password,
    options: { data: { full_name: name } }
  });

  setLoading(submitBtn, false);

  if (error) {
    showMessage(messageEl, error.message, 'error');
    return;
  }

  // A trigger (see supabase/schema.sql) creates the matching `profiles` row
  // automatically on signup — no separate insert needed here.
  showMessage(messageEl, 'Account created — check your email to confirm, then log in.', 'success');
  form.reset();
}

/* ---------------------------- Email + password login ---------------------------- */

async function handleLogin(event) {
  event.preventDefault();
  const form = event.target;
  const messageEl = form.querySelector('.form-message');
  const submitBtn = form.querySelector('button[type="submit"]');

  const email = form.email.value.trim();
  const password = form.password.value;

  setLoading(submitBtn, true, 'Logging in…');

  const { data, error } = await supabaseClient.auth.signInWithPassword({ email, password });

  setLoading(submitBtn, false);

  if (error) {
    showMessage(messageEl, 'Incorrect email or password.', 'error');
    return;
  }

  window.location.href = 'dashboard.html';
}

/* ---------------------------- Forgot / reset password ---------------------------- */

async function handleForgotPassword(event) {
  event.preventDefault();
  const form = event.target;
  const messageEl = form.querySelector('.form-message');
  const submitBtn = form.querySelector('button[type="submit"]');
  const email = form.email.value.trim();

  setLoading(submitBtn, true, 'Sending link…');
  const { error } = await supabaseClient.auth.resetPasswordForEmail(email, {
    redirectTo: `${window.location.origin}/pages/reset-password.html`
  });
  setLoading(submitBtn, false);

  if (error) {
    showMessage(messageEl, error.message, 'error');
    return;
  }
  showMessage(messageEl, 'If that email exists, a reset link is on its way.', 'success');
  form.reset();
}

async function handleResetPassword(event) {
  event.preventDefault();
  const form = event.target;
  const messageEl = form.querySelector('.form-message');
  const submitBtn = form.querySelector('button[type="submit"]');

  const password = form.password.value;
  const confirm = form.confirmPassword.value;

  if (password.length < 8) { setFieldError(form.password.closest('.field'), 'Use at least 8 characters.'); return; }
  if (password !== confirm) { setFieldError(form.confirmPassword.closest('.field'), 'Passwords do not match.'); return; }

  setLoading(submitBtn, true, 'Updating…');
  const { error } = await supabaseClient.auth.updateUser({ password });
  setLoading(submitBtn, false);

  if (error) {
    showMessage(messageEl, error.message, 'error');
    return;
  }
  showMessage(messageEl, 'Password updated — you can log in now.', 'success');
  setTimeout(() => (window.location.href = 'login.html'), 1500);
}

/* ---------------------------- Clear field errors on input ---------------------------- */

document.addEventListener('DOMContentLoaded', () => {
  document.querySelectorAll('.field input').forEach((input) => {
    input.addEventListener('input', () => clearFieldError(input.closest('.field')));
  });
});
