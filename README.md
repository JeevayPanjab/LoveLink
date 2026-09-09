# LoveLink — Full Project (Phases 1–5)

A complete dating platform: landing + public pages, full auth, profile setup, swipe/match engine, realtime chat, Razorpay premium checkout, and an admin dashboard.

## Folder structure

```
lovelink/
  index.html                        ← Landing page
  README.md
  styles/
    main.css                        ← Design tokens + landing/auth styles
    app.css                         ← Dashboard/discover/chat/admin app-shell styles
  scripts/
    main.js                         ← Landing page interactions
    supabase-client.js              ← Supabase client init (put your URL/key here)
    auth.js                         ← Signup/login/OTP/Google/reset logic
    app-shell.js                    ← Shared auth guard + sidebar for all app pages
    dashboard.js
    profile.js                      ← Profile form + photo upload/crop
    discover.js                     ← Swipe deck logic
    chat.js                         ← Realtime messaging
    payments.js                     ← Razorpay checkout flow
    admin.js
  pages/
    signup.html / login.html / signup-phone.html / login-phone.html
    forgot-password.html / reset-password.html
    about.html / contact.html / privacy.html / terms.html
    dashboard.html / discover.html / matches.html / messages.html
    notifications.html / profile-setup.html / settings.html / premium.html
    admin/index.html
  supabase/
    schema.sql            ← Phase 2: profiles, auth trigger, RLS, storage bucket
    schema-phase3.sql     ← Phase 3: swipes, matches, notifications, record_swipe()
    schema-phase4.sql     ← Phase 4: messages, realtime, message notifications
    schema-phase5.sql     ← Phase 5: subscriptions, payments, reports, admin
    schema-contact.sql    ← Public contact form table
    functions/
      create-razorpay-order/index.ts
      verify-razorpay-payment/index.ts
```

## Setup (in order)

1. **Create a Supabase project.**
2. **Run the SQL files in order**, in the Supabase SQL editor: `schema.sql` → `schema-phase3.sql` → `schema-phase4.sql` → `schema-phase5.sql` → `schema-contact.sql`.
3. **Enable auth providers**: Authentication → Providers → turn on Email, Phone (needs an SMS provider like Twilio/MSG91), and Google (OAuth Client ID/Secret).
4. **Storage bucket** — already handled by `schema.sql` (creates `profile-photos`, public read, per-user write policies).
5. **Plug in your Supabase keys** in `scripts/supabase-client.js` (`SUPABASE_URL`, `SUPABASE_ANON_KEY`).
6. **Set yourself as admin** — after signing up once, run in the SQL editor:
   ```sql
   update public.profiles set is_admin = true where id = 'YOUR-AUTH-USER-UUID';
   ```
   Find your UUID under Authentication → Users. Then visit `pages/admin/index.html`.
7. **Deploy the two Razorpay edge functions** (needs the Supabase CLI):
   ```bash
   supabase functions deploy create-razorpay-order
   supabase functions deploy verify-razorpay-payment
   supabase secrets set RAZORPAY_KEY_ID=your_key_id RAZORPAY_KEY_SECRET=your_key_secret
   ```
   Then put your public `RAZORPAY_KEY_ID` in `scripts/payments.js`.
8. **Open `index.html`** locally, or deploy the whole `lovelink/` folder to Netlify.

## What's real vs. what needs your keys

Everything is wired end-to-end against Supabase (auth, storage, database, realtime) and Razorpay — there's no mock data layer. The only things you must supply before it fully works: your Supabase URL/anon key, auth provider credentials (Google Client ID, SMS provider for phone OTP), and your Razorpay key ID/secret.

## Notes & known gaps

- **Distance-based matching** (`location_lat`/`location_lng` columns exist) isn't wired into the Discover query yet — it currently filters by gender/interest only. Add a distance filter or a PostGIS extension for real radius search.
- **Boost profile** (Platinum perk) has no dedicated logic yet — `is_premium`/`plan` are tracked, but boosting a profile's placement in others' decks isn't implemented.
- **Invisible mode** toggle in Settings is UI-only; wire it to a `profiles.is_invisible` column and exclude such users from `discover.js`'s query if you want it enforced.
- **Analytics charts** on the admin dashboard are numbers only — swap in Chart.js or Recharts against the same Supabase count queries for visual charts.
- Admin "Delete" on a user removes their `profiles` row only, not their `auth.users` account — full account deletion needs a service-role edge function (Supabase doesn't allow deleting `auth.users` from the client for security reasons).
