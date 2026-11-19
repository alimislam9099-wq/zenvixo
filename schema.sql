-- Zenvixo starter database schema for Supabase (PostgreSQL).
-- This creates secure user-owned records and admin-controlled settings tables.
-- Run in Supabase SQL Editor. Do not enable public write access.

create extension if not exists pgcrypto;

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  display_name text,
  phone text unique,
  referral_code text unique,
  referred_by text,
  avatar_url text,
  balance numeric(14,2) not null default 0 check (balance >= 0),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.transactions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  kind text not null check (kind in ('deposit','withdraw','adjustment')),
  amount numeric(14,2) not null check (amount > 0),
  status text not null default 'pending' check (status in ('pending','approved','rejected')),
  payment_method text,
  account_number text,
  reference text,
  admin_note text,
  created_at timestamptz not null default now(),
  reviewed_at timestamptz
);

create table if not exists public.site_settings (
  key text primary key,
  value jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

create table if not exists public.admin_users (
  user_id uuid primary key references auth.users(id) on delete cascade,
  created_at timestamptz not null default now()
);

alter table public.profiles enable row level security;
alter table public.transactions enable row level security;
alter table public.site_settings enable row level security;
alter table public.admin_users enable row level security;

-- Users can read/update their own profile (balance must be changed by a trusted backend).
drop policy if exists "profile read own" on public.profiles;
create policy "profile read own" on public.profiles for select to authenticated using (id = auth.uid());
drop policy if exists "profile update own basic" on public.profiles;
create policy "profile update own basic" on public.profiles for update to authenticated using (id = auth.uid()) with check (id = auth.uid());

-- Users can read their own transactions and create pending requests only.
drop policy if exists "transactions read own" on public.transactions;
create policy "transactions read own" on public.transactions for select to authenticated using (user_id = auth.uid());
drop policy if exists "transactions create own pending" on public.transactions;
create policy "transactions create own pending" on public.transactions for insert to authenticated with check (user_id = auth.uid() and status = 'pending');

-- Public can read public settings; only admins may change them.
drop policy if exists "settings public read" on public.site_settings;
create policy "settings public read" on public.site_settings for select to anon, authenticated using (true);
drop policy if exists "settings admin write" on public.site_settings;
create policy "settings admin write" on public.site_settings for all to authenticated using (exists(select 1 from public.admin_users a where a.user_id = auth.uid())) with check (exists(select 1 from public.admin_users a where a.user_id = auth.uid()));

-- Admin role table is private; users cannot self-assign admin status.
drop policy if exists "admin users read self" on public.admin_users;
create policy "admin users read self" on public.admin_users for select to authenticated using (user_id = auth.uid());

-- Note: Do NOT create a policy allowing users to update their own balance or transaction status.
