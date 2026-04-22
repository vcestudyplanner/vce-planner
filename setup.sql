-- Run this entire file in the Supabase SQL Editor (SQL → New Query)

create table if not exists public.profiles (
  id uuid references auth.users on delete cascade primary key,
  name text not null,
  created_at timestamptz default now()
);

create table if not exists public.subjects (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references auth.users on delete cascade not null,
  label text not null,
  color int not null default 1,
  display_order int not null default 0,
  created_at timestamptz default now()
);

create table if not exists public.suggestions (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references auth.users on delete set null,
  type text not null default 'feedback',
  content text not null,
  created_at timestamptz default now()
);

alter table public.profiles enable row level security;
alter table public.subjects enable row level security;
alter table public.suggestions enable row level security;

create policy "own_profile" on public.profiles
  for all using (auth.uid() = id) with check (auth.uid() = id);

create policy "own_subjects" on public.subjects
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

create policy "insert_suggestions" on public.suggestions
  for insert with check (true);
