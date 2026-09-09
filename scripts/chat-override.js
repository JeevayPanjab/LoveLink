// Dynamic active sender resolution for safe testing
function getActiveSenderId(authUserId) {
  const impersonatedId = localStorage.getItem('impersonated_user_id');
  return impersonatedId ? impersonatedId : authUserId;
}

// Example usage when sending a message:
async function sendChatMessage(recipientId, messageText, currentAuthUserId) {
  const senderId = getActiveSenderId(currentAuthUserId);

  const { data, error } = await supabase
    .from('messages')
    .insert([
      {
        sender_id: senderId,
        receiver_id: recipientId,
        content: messageText,
        created_at: new Date().toISOString()
      }
    ]);

  return { data, error };
}