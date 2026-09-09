// Supabase Edge Function — create-razorpay-order
// Deploy: supabase functions deploy create-razorpay-order
// Secrets needed (supabase secrets set):
//   RAZORPAY_KEY_ID, RAZORPAY_KEY_SECRET

import { serve } from 'https://deno.land/std@0.192.0/http/server.ts';

const RAZORPAY_KEY_ID = Deno.env.get('RAZORPAY_KEY_ID')!;
const RAZORPAY_KEY_SECRET = Deno.env.get('RAZORPAY_KEY_SECRET')!;

serve(async (req) => {
  try {
    const { plan, cycle, amount } = await req.json();

    if (!plan || !cycle || !amount) {
      return new Response(JSON.stringify({ error: 'Missing plan, cycle or amount' }), { status: 400 });
    }

    const auth = btoa(`${RAZORPAY_KEY_ID}:${RAZORPAY_KEY_SECRET}`);

    const res = await fetch('https://api.razorpay.com/v1/orders', {
      method: 'POST',
      headers: {
        'Authorization': `Basic ${auth}`,
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        amount,               // amount in paise, e.g. 49900 = ₹499.00
        currency: 'INR',
        receipt: `lovelink_${plan}_${Date.now()}`,
        notes: { plan, cycle }
      })
    });

    const order = await res.json();
    if (!res.ok) return new Response(JSON.stringify({ error: order }), { status: 500 });

    return new Response(JSON.stringify(order), {
      headers: { 'Content-Type': 'application/json' }
    });
  } catch (err) {
    return new Response(JSON.stringify({ error: err.message }), { status: 500 });
  }
});
