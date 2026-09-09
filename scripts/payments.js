// LoveLink — payments.js
// Requires the two Supabase Edge Functions in /supabase/functions/
// (create-razorpay-order, verify-razorpay-payment) to be deployed.

const RAZORPAY_KEY_ID = 'rzp_test_YOUR_KEY_ID'; // public key — safe on client

let billingCycle = 'monthly';

document.querySelectorAll('.plan-toggle button').forEach(btn => {
  btn.addEventListener('click', () => {
    document.querySelectorAll('.plan-toggle button').forEach(b => b.classList.remove('active'));
    btn.classList.add('active');
    billingCycle = btn.dataset.cycle;
    document.querySelectorAll('.price[data-monthly]').forEach(priceEl => {
      const amount = billingCycle === 'monthly' ? priceEl.dataset.monthly : priceEl.dataset.yearly;
      const suffix = billingCycle === 'monthly' ? '/mo' : '/yr';
      priceEl.innerHTML = `${amount}<span> ${suffix}</span>`;
    });
  });
});

document.querySelectorAll('button[data-plan]').forEach(btn => {
  btn.addEventListener('click', () => startCheckout(btn.dataset.plan, btn));
});

async function startCheckout(plan, buttonEl) {
  const amount = billingCycle === 'monthly' ? buttonEl.dataset.amountMonthly : buttonEl.dataset.amountYearly;
  buttonEl.disabled = true;
  const originalText = buttonEl.textContent;
  buttonEl.textContent = 'Preparing checkout…';

  // 1. Ask our edge function to create a Razorpay order (keeps the secret key server-side)
  const { data: order, error } = await supabaseClient.functions.invoke('create-razorpay-order', {
    body: { plan, cycle: billingCycle, amount: parseInt(amount) }
  });

  buttonEl.disabled = false;
  buttonEl.textContent = originalText;

  if (error || !order) {
    showToast('Could not start checkout — try again.');
    return;
  }

  const razorpay = new Razorpay({
    key: RAZORPAY_KEY_ID,
    amount: order.amount,
    currency: 'INR',
    name: 'LoveLink',
    description: `${plan[0].toUpperCase() + plan.slice(1)} membership — ${billingCycle}`,
    order_id: order.id,
    prefill: {
      name: currentProfile?.full_name || '',
      email: currentSession?.user?.email || ''
    },
    theme: { color: '#FF4D8D' },
    handler: async function (response) {
      // 2. Verify the signature server-side, then activate the subscription
      const { data: verified } = await supabaseClient.functions.invoke('verify-razorpay-payment', {
        body: {
          razorpay_order_id: response.razorpay_order_id,
          razorpay_payment_id: response.razorpay_payment_id,
          razorpay_signature: response.razorpay_signature,
          plan,
          cycle: billingCycle
        }
      });
      if (verified?.success) {
        showToast('Payment successful — welcome to ' + plan[0].toUpperCase() + plan.slice(1) + '!');
        setTimeout(() => (window.location.href = 'dashboard.html'), 1200);
      } else {
        showToast('Payment could not be verified. Contact support if you were charged.');
      }
    },
    modal: { ondismiss: () => showToast('Checkout closed.') }
  });

  razorpay.open();
}
