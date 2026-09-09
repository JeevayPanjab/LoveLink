// Standalone module for Admin Impersonation
async function setupAdminImpersonation() {
  const { data: demoUsers, error } = await supabase
    .from('profiles')
    .select('id, full_name, email, is_demo')
    .eq('is_demo', true);

  if (error) {
    console.error('Error fetching demo users:', error);
    return;
  }

  return demoUsers;
}

async function actAsDemoUser(demoUserId) {
  // 1. Double check if profile is actually a demo account
  const { data: profile } = await supabase
    .from('profiles')
    .select('id, is_demo')
    .eq('id', demoUserId)
    .single();

  if (!profile || !profile.is_demo) {
    alert('Security Alert: You can only impersonate demo/seed accounts.');
    return;
  }

  // 2. Store impersonation session in localStorage
  localStorage.setItem('impersonated_user_id', demoUserId);

  // 3. Redirect to messages view
  window.location.href = '/pages/messages.html';
}