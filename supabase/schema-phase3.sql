-- ============================================================================
-- LoveLink — Phase 3: Swipes & Matches
-- Run after schema.sql (Phase 2).
-- ============================================================================

create table if not exists public.swipes (
  id          uuid primary key default gen_random_uuid(),
  swiper_id   uuid not null references public.profiles (id) on delete cascade,
  target_id   uuid not null references public.profiles (id) on delete cascade,
  type        text not null check (type in ('like', 'super_like', 'pass')),
  created_at  timestamptz not null default now(),
  unique (swiper_id, target_id)
);

create index if not exists idx_swipes_swiper on public.swipes (swiper_id);
create index if not exists idx_swipes_target on public.swipes (target_id);

create table if not exists public.matches (
  id          uuid primary key default gen_random_uuid(),
  user_a      uuid not null references public.profiles (id) on delete cascade,
  user_b      uuid not null references public.profiles (id) on delete cascade,
  created_at  timestamptz not null default now(),
  unique (user_a, user_b)
);

create index if not exists idx_matches_user_a on public.matches (user_a);
create index if not exists idx_matches_user_b on public.matches (user_b);

-- notifications table lives here because record_swipe (below) writes to it;
-- Phase 4 adds the trigger that also writes here for new messages.
create table if not exists public.notifications (
  id          uuid primary key default gen_random_uuid(),
  user_id     uuid not null references public.profiles (id) on delete cascade,
  type        text not null check (type in ('like', 'super_like', 'match', 'message')),
  message     text not null,
  is_read     boolean not null default false,
  created_at  timestamptz not null default now()
);

create index if not exists idx_notifications_user on public.notifications (user_id, created_at desc);

alter table public.swipes enable row level security;
alter table public.matches enable row level security;
alter table public.notifications enable row level security;

create policy "Users can see their own notifications"
  on public.notifications for select to authenticated using (auth.uid() = user_id);

create policy "Users can mark their own notifications read"
  on public.notifications for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);

create policy "Users can see their own swipes"
  on public.swipes for select to authenticated using (auth.uid() = swiper_id);

create policy "Users can insert their own swipes"
  on public.swipes for insert to authenticated with check (auth.uid() = swiper_id);

create policy "Users can see matches they're part of"
  on public.matches for select to authenticated
  using (auth.uid() = user_a or auth.uid() = user_b);

-- ----------------------------------------------------------------------------
-- record_swipe: atomically logs a swipe and creates a match on mutual like.
-- Called from the client via supabaseClient.rpc('record_swipe', {...}).
-- security definer so it can insert a match row involving two different users.
-- ----------------------------------------------------------------------------
create or replace function public.record_swipe(p_target_id uuid, p_type text)
returns table (matched boolean)
language plpgsql
security definer
set search_path = public
as $$
declare
  v_swiper uuid := auth.uid();
  v_reverse_exists boolean;
  v_user_a uuid;
  v_user_b uuid;
begin
  insert into public.swipes (swiper_id, target_id, type)
  values (v_swiper, p_target_id, p_type)
  on conflict (swiper_id, target_id) do update set type = excluded.type;

  if p_type = 'pass' then
    return query select false;
    return;
  end if;

  select exists (
    select 1 from public.swipes
    where swiper_id = p_target_id and target_id = v_swiper and type in ('like', 'super_like')
  ) into v_reverse_exists;

  if v_reverse_exists then
    v_user_a := least(v_swiper, p_target_id);
    v_user_b := greatest(v_swiper, p_target_id);

    insert into public.matches (user_a, user_b)
    values (v_user_a, v_user_b)
    on conflict (user_a, user_b) do nothing;

    insert into public.notifications (user_id, type, message)
    values
      (v_swiper, 'match', 'You have a new match!'),
      (p_target_id, 'match', 'You have a new match!');

    return query select true;
  else
    if p_type in ('like', 'super_like') then
      insert into public.notifications (user_id, type, message)
      values (p_target_id, p_type, 'Someone ' || (case when p_type = 'super_like' then 'super liked' else 'liked' end) || ' your profile');
    end if;
    return query select false;
  end if;
end;
$$;

grant execute on function public.record_swipe(uuid, text) to authenticated;
