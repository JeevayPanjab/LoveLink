-- ============================================================================
-- LoveLink — Phase 5: Premium, Payments, Reports, Admin
-- Run after schema-phase4.sql.
-- ============================================================================

-- Extra columns on profiles used by moderation/admin
alter table public.profiles add column if not exists account_status text not null default 'active' check (account_status in ('active', 'suspended', 'banned'));
alter table public.profiles add column if not exists is_admin boolean not null default false;

-- ----------------------------------------------------------------------------
-- subscriptions — one active row per user
-- ----------------------------------------------------------------------------
create table if not exists public.subscriptions (
  user_id             uuid primary key references public.profiles (id) on delete cascade,
  plan                text not null check (plan in ('gold', 'platinum')),
  cycle               text not null check (cycle in ('monthly', 'yearly')),
  status              text not null default 'active' check (status in ('active', 'cancelled', 'expired')),
  current_period_end  timestamptz not null,
  created_at          timestamptz not null default now()
);

alter table public.subscriptions enable row level security;

create policy "Users can view their own subscription"
  on public.subscriptions for select to authenticated using (auth.uid() = user_id);

-- Subscriptions are written by the verify-razorpay-payment edge function
-- using the service role key, so no client-side insert/update policy is needed.

-- ----------------------------------------------------------------------------
-- payments — full transaction history
-- ----------------------------------------------------------------------------
create table if not exists public.payments (
  id                    uuid primary key default gen_random_uuid(),
  user_id               uuid not null references public.profiles (id) on delete cascade,
  razorpay_order_id     text,
  razorpay_payment_id   text,
  plan                  text not null,
  cycle                 text not null,
  status                text not null default 'pending' check (status in ('pending', 'success', 'failed', 'refunded')),
  created_at            timestamptz not null default now()
);

create index if not exists idx_payments_user on public.payments (user_id, created_at desc);

alter table public.payments enable row level security;

create policy "Users can view their own payments"
  on public.payments for select to authenticated using (auth.uid() = user_id);

-- ----------------------------------------------------------------------------
-- reports — fake profile / abuse / spam reports
-- ----------------------------------------------------------------------------
create table if not exists public.reports (
  id            uuid primary key default gen_random_uuid(),
  reporter_id   uuid not null references public.profiles (id) on delete cascade,
  reported_id   uuid not null references public.profiles (id) on delete cascade,
  report_type   text not null check (report_type in ('fake_profile', 'abuse', 'spam', 'other')),
  reason        text,
  status        text not null default 'open' check (status in ('open', 'resolved', 'dismissed')),
  created_at    timestamptz not null default now()
);

alter table public.reports enable row level security;

create policy "Users can file reports"
  on public.reports for insert to authenticated with check (auth.uid() = reporter_id);

create policy "Users can see reports they filed"
  on public.reports for select to authenticated using (auth.uid() = reporter_id);

-- ----------------------------------------------------------------------------
-- Admin access — a small helper + policies granting admins full visibility
-- ----------------------------------------------------------------------------
create or replace function public.is_admin()
returns boolean language sql stable security definer set search_path = public as $$
  select coalesce((select is_admin from public.profiles where id = auth.uid()), false);
$$;

-- Note: profiles are already selectable by all authenticated users (Phase 2
-- policy), so admins can already read them — only an update policy is added.
create policy "Admins can update any profile"
  on public.profiles for update to authenticated using (public.is_admin()) with check (public.is_admin());

create policy "Admins can view all reports"
  on public.reports for select to authenticated using (public.is_admin());

create policy "Admins can resolve reports"
  on public.reports for update to authenticated using (public.is_admin()) with check (public.is_admin());

create policy "Admins can view all payments"
  on public.payments for select to authenticated using (public.is_admin());

create policy "Admins can view all subscriptions"
  on public.subscriptions for select to authenticated using (public.is_admin());

-- To make your own account an admin, run once (replace with your user id):
-- update public.profiles set is_admin = true where id = 'YOUR-AUTH-USER-UUID';
