# Demo Profiles Seed — README

## Files
- `seed-demo-profiles.sql` — run this ONCE in your Supabase SQL editor. It creates 50 demo
  accounts (auth.users + profiles) and marks them with `is_demo = true` for easy identification/cleanup.
- `demo-profiles-reference.csv` — same 50 profiles in spreadsheet form, for review only (not for direct import).

## How to run
1. Open Supabase Dashboard → SQL Editor
2. Paste the contents of `seed-demo-profiles.sql`
3. Run it
4. Check `pages/discover.html` — the swipe deck should now show these profiles

## Notes
- These are fake demo accounts with disabled logins (dummy password), meant only to populate
  the discover feed for testing/demo purposes.
- To remove them later:
  ```sql
  delete from auth.users where id in (select id from public.profiles where is_demo = true);
  ```
  (this cascades and removes their profiles too, thanks to the FK `on delete cascade`)
- Gender split: ~76% female (38), ~24% male (12), matching your requested ratio.
- Photos are auto-generated cartoon avatars (DiceBear API) — no real people involved.
