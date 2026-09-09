-- ============================================================================
-- LoveLink — Phase 4: Realtime Chat
-- Run after schema-phase3.sql. (public.notifications is created there.)
-- ============================================================================

create table if not exists public.messages (
  id            uuid primary key default gen_random_uuid(),
  sender_id     uuid not null references public.profiles (id) on delete cascade,
  recipient_id  uuid not null references public.profiles (id) on delete cascade,
  content       text not null,
  is_read       boolean not null default false,
  created_at    timestamptz not null default now()
);

create index if not exists idx_messages_thread on public.messages (least(sender_id, recipient_id), greatest(sender_id, recipient_id), created_at);
create index if not exists idx_messages_recipient_unread on public.messages (recipient_id, is_read);

alter table public.messages enable row level security;

create policy "Users can read their own conversations"
  on public.messages for select to authenticated
  using (auth.uid() = sender_id or auth.uid() = recipient_id);

create policy "Users can send messages as themselves"
  on public.messages for insert to authenticated
  with check (auth.uid() = sender_id);

create policy "Recipients can mark messages read"
  on public.messages for update to authenticated
  using (auth.uid() = recipient_id)
  with check (auth.uid() = recipient_id);

-- Required for Realtime postgres_changes subscriptions on this table
alter publication supabase_realtime add table public.messages;

-- Notify the recipient whenever a new message arrives
create or replace function public.handle_new_message()
returns trigger language plpgsql security definer set search_path = public as $$
begin
  insert into public.notifications (user_id, type, message)
  values (new.recipient_id, 'message', 'You have a new message');
  return new;
end;
$$;

drop trigger if exists trg_on_new_message on public.messages;
create trigger trg_on_new_message
  after insert on public.messages
  for each row execute function public.handle_new_message();
