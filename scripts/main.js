// LoveLink — landing page interactions

document.addEventListener('DOMContentLoaded', () => {
  const nav = document.getElementById('nav');
  const themeToggle = document.getElementById('themeToggle');
  const navBurger = document.getElementById('navBurger');
  const navLinks = document.querySelector('.nav-links');

  // Nav background on scroll
  window.addEventListener('scroll', () => {
    if (window.scrollY > 12) {
      nav.classList.add('scrolled');
    } else {
      nav.classList.remove('scrolled');
    }
  });

  // Theme toggle (persisted for the session; swap to Supabase/localStorage-backed
  // preference once a logged-in profile exists)
  const applyTheme = (theme) => {
    document.documentElement.setAttribute('data-theme', theme);
    themeToggle.textContent = theme === 'dark' ? '🌙' : '☀️';
  };

  themeToggle?.addEventListener('click', () => {
    const current = document.documentElement.getAttribute('data-theme');
    applyTheme(current === 'dark' ? 'light' : 'dark');
  });

  // Mobile nav toggle
  navBurger?.addEventListener('click', () => {
    const isOpen = navLinks.style.display === 'flex';
    navLinks.style.display = isOpen ? 'none' : 'flex';
    navLinks.style.flexDirection = 'column';
    navLinks.style.position = 'absolute';
    navLinks.style.top = '64px';
    navLinks.style.left = '0';
    navLinks.style.right = '0';
    navLinks.style.padding = '20px 24px';
    navLinks.style.background = 'var(--surface)';
    navLinks.style.borderBottom = '1px solid var(--glass-border)';
  });
});
