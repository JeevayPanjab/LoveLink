// Floating Indicator to exit Impersonation Mode
(function injectImpersonationBanner() {
  const impersonatedId = localStorage.getItem('impersonated_user_id');
  
  if (!impersonatedId) return;

  window.addEventListener('DOMContentLoaded', () => {
    const banner = document.createElement('div');
    banner.id = 'demo-testing-banner';
    banner.style.cssText = `
      position: fixed;
      bottom: 15px;
      right: 15px;
      background-color: #111827;
      color: #ffffff;
      padding: 10px 16px;
      border-radius: 8px;
      box-shadow: 0 4px 12px rgba(0,0,0,0.15);
      z-index: 999999;
      font-size: 13px;
      font-family: sans-serif;
      display: flex;
      align-items: center;
      gap: 10px;
      border: 1px solid #374151;
    `;

    banner.innerHTML = `
      <span>⚠️ Testing Mode: <strong>Active Demo User</strong></span>
      <button id="exitDemoModeBtn" style="
        background: #ef4444;
        color: white;
        border: none;
        padding: 4px 10px;
        border-radius: 4px;
        cursor: pointer;
        font-weight: bold;
      ">Exit Session</button>
    `;

    document.body.appendChild(banner);

    document.getElementById('exitDemoModeBtn').onclick = () => {
      localStorage.removeItem('impersonated_user_id');
      window.location.href = '/pages/admin/index.html';
    };
  });
})();