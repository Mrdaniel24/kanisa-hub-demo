-- ============================================================
-- Kanisa Hub by FocusTec — DEMO SEED DATA
-- Data zote hapa ni za mfano (Kanisa la Neema). Run AFTER schema.
-- Re-runnable: inafuta data ya demo kwanza kisha inaiweka upya.
-- ============================================================

create extension if not exists pgcrypto with schema extensions;
set kanisahub.allow_reset = 'on';

-- 0. Futa data ya zamani ya demo
alter table public.profiles disable trigger protect_profile_role_changes;
truncate public.pinned_messages, public.messages, public.chat_restrictions,
         public.media_gallery_event_images, public.media_gallery_events, public.media_items,
         public.contributions, public.announcements, public.events, public.sermons,
         public.admin_permissions, public.visitors, public.service_times,
         public.church_contacts, public.system_settings cascade;
delete from auth.identities where user_id in (select id from auth.users where email like '%@kanisahub.demo');
delete from auth.users where email like '%@kanisahub.demo';
delete from public.departments;

-- 1. Idara / huduma
insert into public.departments (id, name, description, leader_name, meeting_schedule, image_url) values
 ('d0000000-0000-0000-0000-000000000001','Kwaya Kuu','Kwaya inayoongoza ibada za Jumapili na matukio maalum.','Mwl. Grace Mushi','Jumamosi 2:00 – 5:00 jioni','https://images.unsplash.com/photo-1516280440614-37939bbacd81?w=800'),
 ('d0000000-0000-0000-0000-000000000002','Vijana','Huduma ya vijana: ibada, michezo, na mafunzo ya uongozi.','Bw. Joel Massawe','Ijumaa 4:00 – 6:00 jioni','https://images.unsplash.com/photo-1529156069898-49953e39b3ac?w=800'),
 ('d0000000-0000-0000-0000-000000000003','Wanawake','Ushirika wa akina mama, maombi na miradi ya kijamii.','Mama Esther Kimaro','Jumanne 10:00 asubuhi','https://images.unsplash.com/photo-1511632765486-a01980e01a18?w=800'),
 ('d0000000-0000-0000-0000-000000000004','Wanaume','Ushirika wa akina baba na huduma ya kufundisha familia.','Bw. Daudi Mollel','Jumamosi 7:00 asubuhi','https://images.unsplash.com/photo-1491438590914-bc09fcaaf77a?w=800'),
 ('d0000000-0000-0000-0000-000000000005','Shule ya Jumapili','Mafundisho ya Biblia kwa watoto.','Mwl. Neema Lyimo','Jumapili 9:00 asubuhi','https://images.unsplash.com/photo-1503454537195-1dcabb73ffb9?w=800'),
 ('d0000000-0000-0000-0000-000000000006','Maombi na Uinjilisti','Maombi ya kila wiki na kufikia jamii.','Mch. Peter Laizer','Jumatano 6:00 jioni','https://images.unsplash.com/photo-1438232992991-995b7058bbb3?w=800');

-- 2. Watumiaji (auth) — akaunti za demo zina password: Demo@2026
--    Watumiaji wengine wa mfano wana password ya nasibu (hawaingii).
create temp table _demo_users (id uuid, email text, full_name text, role text, dept uuid, phone text, gender text, marital text, address text, joined date, pw text);
insert into _demo_users values
 ('a0000000-0000-0000-0000-000000000001','superadmin@kanisahub.demo','Mchungaji John Mwakalinga','super_admin',null,'+255712000001','male','married','Arusha Mjini','2019-01-10','Demo@2026'),
 ('a0000000-0000-0000-0000-000000000002','admin@kanisahub.demo','Grace Mushi','admin','d0000000-0000-0000-0000-000000000001','+255712000002','female','married','Njiro','2020-03-15','Demo@2026'),
 ('a0000000-0000-0000-0000-000000000003','member@kanisahub.demo','Joseph Kileo','member','d0000000-0000-0000-0000-000000000002','+255712000003','male','single','Kijenge','2023-06-01','Demo@2026'),
 ('a0000000-0000-0000-0000-000000000004','esther.kimaro@kanisahub.demo','Esther Kimaro','member','d0000000-0000-0000-0000-000000000003','+255712000004','female','married','Sakina','2018-09-20',null),
 ('a0000000-0000-0000-0000-000000000005','joel.massawe@kanisahub.demo','Joel Massawe','member','d0000000-0000-0000-0000-000000000002','+255712000005','male','single','Ngarenaro','2021-02-11',null),
 ('a0000000-0000-0000-0000-000000000006','daudi.mollel@kanisahub.demo','Daudi Mollel','member','d0000000-0000-0000-0000-000000000004','+255712000006','male','married','Themi','2017-05-05',null),
 ('a0000000-0000-0000-0000-000000000007','neema.lyimo@kanisahub.demo','Neema Lyimo','member','d0000000-0000-0000-0000-000000000005','+255712000007','female','married','Olasiti','2020-11-30',null),
 ('a0000000-0000-0000-0000-000000000008','peter.laizer@kanisahub.demo','Peter Laizer','member','d0000000-0000-0000-0000-000000000006','+255712000008','male','married','Kaloleni','2016-04-18',null),
 ('a0000000-0000-0000-0000-000000000009','rehema.swai@kanisahub.demo','Rehema Swai','member','d0000000-0000-0000-0000-000000000001','+255712000009','female','single','Moshono','2022-08-08',null),
 ('a0000000-0000-0000-0000-000000000010','baraka.minja@kanisahub.demo','Baraka Minja','member','d0000000-0000-0000-0000-000000000002','+255712000010','male','single','Sombetini','2024-01-14',null),
 ('a0000000-0000-0000-0000-000000000011','anna.urio@kanisahub.demo','Anna Urio','member','d0000000-0000-0000-0000-000000000003','+255712000011','female','widowed','Ilboru','2015-07-22',null),
 ('a0000000-0000-0000-0000-000000000012','samweli.temba@kanisahub.demo','Samweli Temba','member','d0000000-0000-0000-0000-000000000004','+255712000012','male','married','Kimandolu','2019-10-03',null),
 ('a0000000-0000-0000-0000-000000000013','faraja.mbise@kanisahub.demo','Faraja Mbise','member','d0000000-0000-0000-0000-000000000001','+255712000013','female','married','Burka','2021-12-12',null),
 ('a0000000-0000-0000-0000-000000000014','emmanuel.saning@kanisahub.demo','Emmanuel Saning''o','member','d0000000-0000-0000-0000-000000000006','+255712000014','male','married','Engutoto','2023-03-19',null),
 ('a0000000-0000-0000-0000-000000000015','lightness.nnko@kanisahub.demo','Lightness Nnko','member','d0000000-0000-0000-0000-000000000005','+255712000015','female','single','Kwa Mrombo','2025-02-02',null);

insert into auth.users (instance_id, id, aud, role, email, encrypted_password, email_confirmed_at,
  raw_app_meta_data, raw_user_meta_data, created_at, updated_at,
  confirmation_token, recovery_token, email_change_token_new, email_change)
select '00000000-0000-0000-0000-000000000000', u.id, 'authenticated', 'authenticated', u.email,
  extensions.crypt(coalesce(u.pw, gen_random_uuid()::text), extensions.gen_salt('bf')), now(),
  '{"provider":"email","providers":["email"]}'::jsonb, jsonb_build_object('full_name', u.full_name),
  u.joined::timestamptz, now(), '', '', '', ''
from _demo_users u;

insert into auth.identities (id, user_id, provider_id, identity_data, provider, last_sign_in_at, created_at, updated_at)
select gen_random_uuid(), u.id, u.id::text,
  jsonb_build_object('sub', u.id::text, 'email', u.email, 'email_verified', true),
  'email', now(), now(), now()
from _demo_users u;

-- profiles zimeundwa na trigger handle_new_user; tunazijaza
insert into public.profiles (id, email, full_name)
select id, email, full_name from _demo_users on conflict (id) do nothing;

update public.profiles p set full_name = u.full_name, role = u.role, status = 'active',
  department_id = u.dept, phone = u.phone, whatsapp = u.phone, gender = u.gender,
  marital_status = u.marital, address = u.address, joined_at = u.joined::timestamptz
from _demo_users u where p.id = u.id;

update public.profiles set status = 'inactive' where email = 'anna.urio@kanisahub.demo';

insert into public.admin_permissions (admin_id, can_manage_members, can_manage_announcements, can_manage_events,
  can_manage_media, can_manage_contributions, can_manage_sermons, can_manage_departments, can_view_reports)
values ('a0000000-0000-0000-0000-000000000002', true, true, true, true, true, true, false, true);

-- 3. Mipangilio ya kanisa
insert into public.system_settings (church_name, church_address, church_phone, church_email, currency, timezone,
  hero_badge_text, hero_subtext, about_label, about_heading, about_quote, about_body,
  about_main_image_url, about_accent_image_url, ministries_label, ministries_heading,
  bento_feature_title, bento_feature_desc, bento_feature_image_url, church_lat, church_lng, updated_by)
values ('Kanisa la Neema', 'Mtaa wa Neema, Arusha, Tanzania', '+255 700 000 000', 'info@kanisahub.demo', 'TZS', 'Africa/Dar_es_Salaam',
  'Karibu Nyumbani', 'Jumuiya ya imani, upendo na huduma — sasa kidijitali.',
  'Kuhusu Sisi', 'Kanisa linalokua pamoja', 'Mkiwa na upendo ninyi kwa ninyi, watu wote watatambua ya kuwa ninyi ni wanafunzi wangu.',
  'Kanisa la Neema ni kanisa la mfano linaloonyesha jinsi Kanisa Hub inavyosaidia kusimamia waumini, idara, michango, matukio na mawasiliano mahali pamoja.',
  'https://images.unsplash.com/photo-1438032005730-c779502df39b?w=1200', 'https://images.unsplash.com/photo-1507692049790-de58290a4334?w=800',
  'Huduma Zetu', 'Kuna nafasi kwa kila mmoja',
  'Ibada ya Jumapili', 'Ungana nasi kila Jumapili kwa sifa, neno na ushirika.', 'https://images.unsplash.com/photo-1544427920-c49ccfb85579?w=1200',
  -3.36670000, 36.68330000, 'a0000000-0000-0000-0000-000000000001');

insert into public.service_times (display_order, icon, day_label, title, description, time_label) values
 (1, 'church', 'Jumapili', 'Ibada ya Kwanza', 'Ibada ya Kiswahili', '7:00 – 9:00 asubuhi'),
 (2, 'church', 'Jumapili', 'Ibada ya Pili', 'Ibada ya Kiingereza na vijana', '9:30 – 12:00 mchana'),
 (3, 'menu_book', 'Jumatano', 'Mafundisho ya Biblia', 'Kujifunza Neno kwa kina', '6:00 – 8:00 jioni'),
 (4, 'volunteer_activism', 'Ijumaa', 'Maombi ya Usiku', 'Mkesha wa maombi', '4:00 – 6:00 usiku');

insert into public.church_contacts (department_name, role_label, phone, email, sort_order) values
 ('Ofisi ya Kanisa', 'Katibu', '+255 700 000 001', 'ofisi@kanisahub.demo', 1),
 ('Uchungaji', 'Mchungaji Kiongozi', '+255 700 000 002', 'mchungaji@kanisahub.demo', 2),
 ('Vijana', 'Kiongozi wa Vijana', '+255 700 000 003', null, 3);

-- 4. Matangazo
insert into public.announcements (title, content, priority, target_type, department_id, created_by, created_at) values
 ('Karibu kwenye Kanisa Hub!', 'Huu ni mfumo wa demo. Jaribu kila sehemu: waumini, michango, matukio, mahubiri na zaidi.', 'new', 'public', null, 'a0000000-0000-0000-0000-000000000001', now() - interval '1 day'),
 ('Harambee ya Ujenzi', 'Harambee ya ujenzi wa ukumbi mpya itafanyika Jumapili ijayo baada ya ibada ya pili.', 'urgent', 'general', null, 'a0000000-0000-0000-0000-000000000001', now() - interval '2 days'),
 ('Mazoezi ya Kwaya', 'Mazoezi ya ziada Alhamisi saa 11 jioni kujiandaa na tamasha la Krismasi.', 'update', 'department', 'd0000000-0000-0000-0000-000000000001', 'a0000000-0000-0000-0000-000000000002', now() - interval '3 days'),
 ('Kongamano la Vijana', 'Usajili wa kongamano la vijana umefunguliwa. Ada ni TZS 20,000.', 'new', 'department', 'd0000000-0000-0000-0000-000000000002', 'a0000000-0000-0000-0000-000000000001', now() - interval '5 days'),
 ('Ratiba Mpya ya Ibada', 'Kuanzia mwezi ujao ibada ya kwanza itaanza saa 7:00 asubuhi.', 'general', 'public', null, 'a0000000-0000-0000-0000-000000000001', now() - interval '8 days');

-- 5. Matukio
insert into public.events (title, description, event_date, end_date, location, category, image_url, status, max_attendees, created_by) values
 ('Kongamano la Vijana 2026', 'Siku tatu za neno, sifa na michezo kwa vijana.', date_trunc('day', now()) + interval '12 days 9 hours', date_trunc('day', now()) + interval '14 days 17 hours', 'Ukumbi Mkuu', 'youth', 'https://images.unsplash.com/photo-1523580494863-6f3031224c94?w=1000', 'upcoming', 300, 'a0000000-0000-0000-0000-000000000001'),
 ('Tamasha la Krismasi', 'Nyimbo za Krismasi kutoka kwaya zote.', date_trunc('day', now()) + interval '30 days 15 hours', null, 'Uwanja wa Kanisa', 'worship', 'https://images.unsplash.com/photo-1512389142860-9c449e58a543?w=1000', 'upcoming', null, 'a0000000-0000-0000-0000-000000000002'),
 ('Semina ya Akina Mama', 'Mada: Familia imara katika Kristo.', date_trunc('day', now()) + interval '6 days 10 hours', null, 'Ukumbi Mdogo', 'women', 'https://images.unsplash.com/photo-1528605248644-14dd04022da1?w=1000', 'upcoming', 120, 'a0000000-0000-0000-0000-000000000001'),
 ('Uinjilisti wa Mtaa', 'Kufikia jamii ya Kijenge kwa huduma na neno.', date_trunc('day', now()) + interval '9 days 8 hours', null, 'Kijenge', 'outreach', 'https://images.unsplash.com/photo-1469571486292-0ba58a3f068b?w=1000', 'upcoming', null, 'a0000000-0000-0000-0000-000000000001'),
 ('Kifungua Kinywa cha Wanaume', 'Ushirika na mafundisho kwa akina baba.', date_trunc('day', now()) - interval '10 days' + interval '7 hours', null, 'Ukumbi Mdogo', 'men', 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=1000', 'past', 80, 'a0000000-0000-0000-0000-000000000001');

-- 6. Mahubiri
insert into public.sermons (title, speaker, description, series_name, video_url, scripture_reference, sermon_date, duration_minutes, created_by) values
 ('Imani Isiyotikisika', 'Mch. John Mwakalinga', 'Jinsi ya kusimama imara wakati wa majaribu.', 'Imani', 'https://www.youtube.com/watch?v=ScMzIvxBSi4', 'Waebrania 11:1-6', current_date - 2, 48, 'a0000000-0000-0000-0000-000000000001'),
 ('Neema ya Kutosha', 'Mch. John Mwakalinga', 'Neema ya Mungu katika udhaifu wetu.', 'Neema', 'https://www.youtube.com/watch?v=ScMzIvxBSi4', '2 Wakorintho 12:9', current_date - 9, 52, 'a0000000-0000-0000-0000-000000000001'),
 ('Familia Inayoomba', 'Mama Esther Kimaro', 'Nguvu ya maombi katika familia.', 'Familia', null, 'Matendo 2:42', current_date - 16, 40, 'a0000000-0000-0000-0000-000000000001'),
 ('Kijana na Kusudi', 'Bw. Joel Massawe', 'Kugundua kusudi la Mungu ukiwa kijana.', 'Vijana', 'https://www.youtube.com/watch?v=ScMzIvxBSi4', 'Yeremia 29:11', current_date - 23, 45, 'a0000000-0000-0000-0000-000000000001');

-- 7. Michango (miezi 6 iliyopita)
insert into public.contributions (member_id, amount, currency, category, payment_method, status, reference_number, notes, recorded_by, contribution_date)
select m.id,
  (array[10000,20000,25000,50000,75000,100000,150000])[1 + floor(random()*7)::int],
  'TZS',
  (array['tithe','tithe','offering','offering','building_fund','missions','special'])[1 + floor(random()*7)::int],
  (array['cash','mobile_money','mobile_money','bank_transfer'])[1 + floor(random()*4)::int],
  'completed', 'DEMO-' || upper(substr(md5(random()::text), 1, 8)), null,
  'a0000000-0000-0000-0000-000000000002',
  current_date - (floor(random()*180))::int
from public.profiles m, generate_series(1, 6) g
where m.email like '%@kanisahub.demo';

insert into public.contributions (member_id, amount, category, payment_method, status, reference_number, recorded_by, contribution_date) values
 ('a0000000-0000-0000-0000-000000000003', 30000, 'tithe', 'mobile_money', 'pending', 'DEMO-PENDING1', 'a0000000-0000-0000-0000-000000000002', current_date);

-- 8. Gallery
insert into public.media_gallery_events (id, title, description, event_date, cover_image_url, is_public, department_id, created_by) values
 ('e0000000-0000-0000-0000-000000000001', 'Ibada ya Pasaka', 'Picha za ibada ya Pasaka.', current_date - 120, 'https://images.unsplash.com/photo-1507692049790-de58290a4334?w=1000', true, null, 'a0000000-0000-0000-0000-000000000001'),
 ('e0000000-0000-0000-0000-000000000002', 'Kambi ya Vijana', 'Kambi ya vijana ya mwaka huu.', current_date - 60, 'https://images.unsplash.com/photo-1529156069898-49953e39b3ac?w=1000', true, 'd0000000-0000-0000-0000-000000000002', 'a0000000-0000-0000-0000-000000000001');

insert into public.media_gallery_event_images (event_id, image_url, sort_order) values
 ('e0000000-0000-0000-0000-000000000001', 'https://images.unsplash.com/photo-1438032005730-c779502df39b?w=1000', 1),
 ('e0000000-0000-0000-0000-000000000001', 'https://images.unsplash.com/photo-1544427920-c49ccfb85579?w=1000', 2),
 ('e0000000-0000-0000-0000-000000000002', 'https://images.unsplash.com/photo-1523580494863-6f3031224c94?w=1000', 1),
 ('e0000000-0000-0000-0000-000000000002', 'https://images.unsplash.com/photo-1511632765486-a01980e01a18?w=1000', 2);

insert into public.media_items (title, description, category, file_url, file_type, thumbnail_url, uploaded_by) values
 ('Kwaya Kuu — Jumapili', 'Kwaya ikiimba kwenye ibada.', 'worship', 'https://images.unsplash.com/photo-1516280440614-37939bbacd81?w=1200', 'image', 'https://images.unsplash.com/photo-1516280440614-37939bbacd81?w=400', 'a0000000-0000-0000-0000-000000000001'),
 ('Ibada ya Vijana', 'Usiku wa sifa.', 'youth', 'https://images.unsplash.com/photo-1470225620780-dba8ba36b745?w=1200', 'image', 'https://images.unsplash.com/photo-1470225620780-dba8ba36b745?w=400', 'a0000000-0000-0000-0000-000000000001'),
 ('Uinjilisti wa Mtaa', 'Huduma kwa jamii.', 'events', 'https://images.unsplash.com/photo-1469571486292-0ba58a3f068b?w=1200', 'image', 'https://images.unsplash.com/photo-1469571486292-0ba58a3f068b?w=400', 'a0000000-0000-0000-0000-000000000001');

-- 9. Chat ya idara
insert into public.messages (department_id, sender_id, content, created_at) values
 ('d0000000-0000-0000-0000-000000000002', 'a0000000-0000-0000-0000-000000000005', 'Shalom vijana! Kumbukeni mkutano Ijumaa saa 10 jioni.', now() - interval '5 hours'),
 ('d0000000-0000-0000-0000-000000000002', 'a0000000-0000-0000-0000-000000000003', 'Amina! Nitakuwepo 🙏', now() - interval '4 hours'),
 ('d0000000-0000-0000-0000-000000000002', 'a0000000-0000-0000-0000-000000000010', 'Tuandae pia nyimbo za kongamano.', now() - interval '3 hours'),
 ('d0000000-0000-0000-0000-000000000001', 'a0000000-0000-0000-0000-000000000002', 'Mazoezi Alhamisi saa 11 jioni. Msikose!', now() - interval '1 day');

-- 10. Wageni (QR karibu form)
insert into public.visitors (full_name, phone, area, first_time, wants_contact, created_at) values
 ('Mariam Juma', '+255754000101', 'Kijenge', true, true, now() - interval '2 days'),
 ('Godfrey Shirima', '+255754000102', 'Njiro', true, false, now() - interval '9 days'),
 ('Upendo Kweka', '+255754000103', 'Sakina', false, true, now() - interval '16 days');

alter table public.profiles enable trigger protect_profile_role_changes;

drop table if exists _demo_users;
reset kanisahub.allow_reset;
