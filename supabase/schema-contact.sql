-- ============================================================================
-- LoveLink — Contact form table (used by pages/contact.html)
-- Can be run any time after schema.sql.
-- ============================================================================

create table if not exists public.contact_messages (
  id          uuid primary key default gen_random_uuid(),
  name        text not null,
  email       text not null,
  topic       text,
  message     text not null,
  created_at  timestamptz not null default now()
);

alter table public.contact_messages enable row level security;

-- Anyone (including logged-out visitors) can submit the contact form
create policy "Anyone can submit a contact message"
  on public.contact_messages for insert to anon, authenticated with check (true);

-- Only admins can read submitted messages
create policy "Admins can read contact messages"
  on public.contact_messages for select to authenticated using (public.is_admin());
