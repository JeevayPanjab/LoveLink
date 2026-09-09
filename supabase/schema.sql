-- ============================================================================
-- LoveLink — Phase 2: Auth & Profiles schema
-- Run in Supabase SQL editor. Later phases add matches/likes/messages/etc.
-- ============================================================================

-- Enable extension used for gen_random_uuid()
create extension if not exists "pgcrypto";

-- ----------------------------------------------------------------------------
-- profiles
-- One row per auth.users row. Created automatically via trigger on signup.
-- ----------------------------------------------------------------------------
create table if not exists public.profiles (
  id                uuid primary key references auth.users (id) on delete cascade,
  full_name         text,
  username          text unique,
  age               smallint check (age >= 18 and age <= 100),
  gender            text check (gender in ('male', 'female', 'non_binary', 'other')),
  interested_in     text[] default '{}',
  location_city     text,
  location_lat      double precision,
  location_lng      double precision,
  occupation        text,
  education         text,
  bio               text,
  height_cm         smallint,
  languages         text[] default '{}',
  hobbies           text[] default '{}',
  relationship_goal text check (relationship_goal in ('long_term', 'casual', 'friendship', 'not_sure')),
  photo_urls        text[] default '{}',
  is_verified       boolean not null default false,
  is_premium        boolean not null default false,
  is_online         boolean not null default false,
  last_seen_at      timestamptz default now(),
  onboarding_done   boolean not null default false,
  created_at        timestamptz not null default now(),
  updated_at        timestamptz not null default now()
);

create index if not exists idx_profiles_gender on public.profiles (gender);
create index if not exists idx_profiles_location on public.profiles (location_lat, location_lng);
create index if not exists idx_profiles_username on public.profiles (username);

-- Keep updated_at fresh
create or replace function public.set_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists trg_profiles_updated_at on public.profiles;
create trigger trg_profiles_updated_at
  before update on public.profiles
  for each row execute function public.set_updated_at();

-- ----------------------------------------------------------------------------
-- Auto-create a profile row whenever a new auth.users row appears
-- (covers email, phone OTP, and Google OAuth signups alike)
-- ----------------------------------------------------------------------------
create or replace function public.handle_new_user()
returns trigger language plpgsql security definer set search_path = public as $$
begin
  insert into public.profiles (id, full_name)
  values (new.id, coalesce(new.raw_user_meta_data ->> 'full_name', new.raw_user_meta_data ->> 'name', ''))
  on conflict (id) do nothing;
  return new;
end;
$$;

drop trigger if exists trg_on_auth_user_created on auth.users;
create trigger trg_on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- ----------------------------------------------------------------------------
-- Row Level Security
-- ----------------------------------------------------------------------------
alter table public.profiles enable row level security;

-- Anyone signed in can browse other members' discoverable profile fields
-- (full row is returned to the client; keep sensitive columns out of any
-- future "public view" if you add one — for now this matches Phase 3's
-- discover-feed needs).
create policy "Profiles are viewable by authenticated users"
  on public.profiles for select
  to authenticated
  using (true);

-- Users can only insert their own profile row
create policy "Users can insert their own profile"
  on public.profiles for insert
  to authenticated
  with check (auth.uid() = id);

-- Users can only update their own profile row
create policy "Users can update their own profile"
  on public.profiles for update
  to authenticated
  using (auth.uid() = id)
  with check (auth.uid() = id);

-- Users can delete only their own account's profile row
create policy "Users can delete their own profile"
  on public.profiles for delete
  to authenticated
  using (auth.uid() = id);

-- ----------------------------------------------------------------------------
-- Storage bucket for profile photos (run once)
-- ----------------------------------------------------------------------------
insert into storage.buckets (id, name, public)
values ('profile-photos', 'profile-photos', true)
on conflict (id) do nothing;

create policy "Profile photos are publicly readable"
  on storage.objects for select
  using (bucket_id = 'profile-photos');

create policy "Users can upload to their own photo folder"
  on storage.objects for insert
  to authenticated
  with check (bucket_id = 'profile-photos' and (storage.foldername(name))[1] = auth.uid()::text);

create policy "Users can replace/delete their own photos"
  on storage.objects for update
  to authenticated
  using (bucket_id = 'profile-photos' and (storage.foldername(name))[1] = auth.uid()::text);

create policy "Users can delete their own photos"
  on storage.objects for delete
  to authenticated
  using (bucket_id = 'profile-photos' and (storage.foldername(name))[1] = auth.uid()::text);

-- ============================================================================
-- End of Phase 2 schema. Phase 3 adds: likes, matches.
-- Phase 4 adds: messages, notifications.
-- Phase 5 adds: subscriptions, payments, reports.
-- ============================================================================
