-- ============================================================
-- Kanisa Hub DEMO — linda akaunti 3 za demo
-- Password, email, nafasi (role) na status haziwezi kubadilishwa,
-- na akaunti haziwezi kufutwa. Run kwenye kanisa-hub-demo PEKEE.
-- demo-seed.sql inaruhusiwa kupita kwa: set kanisahub.allow_reset = 'on';
-- ============================================================

create or replace function public.protect_demo_auth_users()
returns trigger language plpgsql security definer set search_path = public as $$
begin
  if coalesce(current_setting('kanisahub.allow_reset', true), '') = 'on' then
    return coalesce(new, old);
  end if;
  if old.email in ('superadmin@kanisahub.demo','admin@kanisahub.demo','member@kanisahub.demo') then
    if tg_op = 'DELETE' then
      raise exception 'Akaunti za demo haziwezi kufutwa';
    end if;
    if new.encrypted_password is distinct from old.encrypted_password
       or new.email is distinct from old.email then
      raise exception 'Password za akaunti za demo haziwezi kubadilishwa';
    end if;
  end if;
  return coalesce(new, old);
end $$;

drop trigger if exists protect_demo_auth_users on auth.users;
create trigger protect_demo_auth_users
  before update or delete on auth.users
  for each row execute function public.protect_demo_auth_users();

create or replace function public.protect_demo_profiles()
returns trigger language plpgsql security definer set search_path = public as $$
begin
  if coalesce(current_setting('kanisahub.allow_reset', true), '') = 'on' then
    return coalesce(new, old);
  end if;
  if old.email in ('superadmin@kanisahub.demo','admin@kanisahub.demo','member@kanisahub.demo') then
    if tg_op = 'DELETE' then
      raise exception 'Akaunti za demo haziwezi kufutwa';
    end if;
    if new.role is distinct from old.role
       or new.status is distinct from old.status
       or new.email is distinct from old.email then
      raise exception 'Nafasi ya akaunti ya demo haiwezi kubadilishwa';
    end if;
  end if;
  return coalesce(new, old);
end $$;

drop trigger if exists protect_demo_profiles on public.profiles;
create trigger protect_demo_profiles
  before update or delete on public.profiles
  for each row execute function public.protect_demo_profiles();
