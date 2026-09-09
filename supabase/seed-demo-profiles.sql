-- ============================================================================
-- LoveLink — Demo/Seed profiles (50 fake accounts for discover feed)
-- Safe to run multiple times is NOT guaranteed — run once.
-- Adds is_demo flag so these can be identified/removed later.
-- ============================================================================

alter table public.profiles add column if not exists is_demo boolean not null default false;

-- Amanpreet Singh (male, 24, Ahmedabad)
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at)
values ('ccedf16c-7bf7-4a89-b536-fb34e933f6a5', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'demo.amanpreet_singh78@lovelink.internal', crypt('disabled-demo-account', gen_salt('bf')), now(), '{"provider":"email","providers":["email"]}', '{"full_name":"Amanpreet Singh"}', now(), now())
on conflict (id) do nothing;
update public.profiles set
  username = 'amanpreet_singh78',
  age = 24,
  gender = 'male',
  interested_in = '{"female"}',
  location_city = 'Ahmedabad',
  occupation = 'Dentist',
  bio = 'Down to earth, loves badminton, currently exploring travel too.',
  height_cm = 174,
  hobbies = '{"foodie","travel","singing"}',
  relationship_goal = 'not_sure',
  photo_urls = '{"https://api.dicebear.com/7.x/avataaars/svg?seed=AmanpreetSingh&gender=male"}',
  onboarding_done = true,
  is_demo = true
where id = 'ccedf16c-7bf7-4a89-b536-fb34e933f6a5';

-- Preet Kaur (female, 32, Pune)
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at)
values ('926b20d3-7d17-4694-b044-b76933c21a2d', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'demo.preet_kaur76@lovelink.internal', crypt('disabled-demo-account', gen_salt('bf')), now(), '{"provider":"email","providers":["email"]}', '{"full_name":"Preet Kaur"}', now(), now())
on conflict (id) do nothing;
update public.profiles set
  username = 'preet_kaur76',
  age = 32,
  gender = 'female',
  interested_in = '{"female"}',
  location_city = 'Pune',
  occupation = 'Doctor',
  bio = 'Down to earth, loves cricket, currently exploring fashion too.',
  height_cm = 174,
  hobbies = '{"yoga","photography","music"}',
  relationship_goal = 'long_term',
  photo_urls = '{"https://api.dicebear.com/7.x/avataaars/svg?seed=PreetKaur&gender=female"}',
  onboarding_done = true,
  is_demo = true
where id = '926b20d3-7d17-4694-b044-b76933c21a2d';

-- Sanya Bhatia (female, 33, Mohali)
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at)
values ('8f2c59bd-ae9e-48c8-8f78-704b1be56905', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'demo.sanya_bhatia86@lovelink.internal', crypt('disabled-demo-account', gen_salt('bf')), now(), '{"provider":"email","providers":["email"]}', '{"full_name":"Sanya Bhatia"}', now(), now())
on conflict (id) do nothing;
update public.profiles set
  username = 'sanya_bhatia86',
  age = 33,
  gender = 'female',
  interested_in = '{"everyone"}',
  location_city = 'Mohali',
  occupation = 'Entrepreneur',
  bio = 'Family-oriented, love fashion. Looking for a meaningful connection.',
  height_cm = 169,
  hobbies = '{"reading","singing","gym"}',
  relationship_goal = 'long_term',
  photo_urls = '{"https://api.dicebear.com/7.x/avataaars/svg?seed=SanyaBhatia&gender=female"}',
  onboarding_done = true,
  is_demo = true
where id = '8f2c59bd-ae9e-48c8-8f78-704b1be56905';

-- Anjali Sharma (female, 22, Delhi)
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at)
values ('d5eab38e-3415-46ed-bc2b-c6868e22f2d1', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'demo.anjali_sharma10@lovelink.internal', crypt('disabled-demo-account', gen_salt('bf')), now(), '{"provider":"email","providers":["email"]}', '{"full_name":"Anjali Sharma"}', now(), now())
on conflict (id) do nothing;
update public.profiles set
  username = 'anjali_sharma10',
  age = 22,
  gender = 'female',
  interested_in = '{"female"}',
  location_city = 'Delhi',
  occupation = 'Fitness Trainer',
  bio = 'Simple soul who loves movies and fashion. Looking for someone genuine.',
  height_cm = 159,
  hobbies = '{"shopping","yoga","cricket"}',
  relationship_goal = 'friendship',
  photo_urls = '{"https://api.dicebear.com/7.x/avataaars/svg?seed=AnjaliSharma&gender=female"}',
  onboarding_done = true,
  is_demo = true
where id = 'd5eab38e-3415-46ed-bc2b-c6868e22f2d1';

-- Rupinder Kaur (female, 21, Bangalore)
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at)
values ('983680cc-4dac-4ad6-ad46-d02da2244faa', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'demo.rupinder_kaur36@lovelink.internal', crypt('disabled-demo-account', gen_salt('bf')), now(), '{"provider":"email","providers":["email"]}', '{"full_name":"Rupinder Kaur"}', now(), now())
on conflict (id) do nothing;
update public.profiles set
  username = 'rupinder_kaur36',
  age = 21,
  gender = 'female',
  interested_in = '{"male"}',
  location_city = 'Bangalore',
  occupation = 'Pharmacist',
  bio = 'Believe in good vibes and honest conversations. Into shopping and reading.',
  height_cm = 177,
  hobbies = '{"music","trekking","singing"}',
  relationship_goal = 'friendship',
  photo_urls = '{"https://api.dicebear.com/7.x/avataaars/svg?seed=RupinderKaur&gender=female"}',
  onboarding_done = true,
  is_demo = true
where id = '983680cc-4dac-4ad6-ad46-d02da2244faa';

-- Gurleen Sandhu (female, 26, Lucknow)
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at)
values ('a0e50383-e64f-43f6-b5fe-2dcfc6976e45', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'demo.gurleen_sandhu72@lovelink.internal', crypt('disabled-demo-account', gen_salt('bf')), now(), '{"provider":"email","providers":["email"]}', '{"full_name":"Gurleen Sandhu"}', now(), now())
on conflict (id) do nothing;
update public.profiles set
  username = 'gurleen_sandhu72',
  age = 26,
  gender = 'female',
  interested_in = '{"male"}',
  location_city = 'Lucknow',
  occupation = 'HR Manager',
  bio = 'Foodie, cooking enthusiast, and forever curious. Swipe if you vibe with positivity.',
  height_cm = 170,
  hobbies = '{"movies","music","shopping"}',
  relationship_goal = 'long_term',
  photo_urls = '{"https://api.dicebear.com/7.x/avataaars/svg?seed=GurleenSandhu&gender=female"}',
  onboarding_done = true,
  is_demo = true
where id = 'a0e50383-e64f-43f6-b5fe-2dcfc6976e45';

-- Rohan Kapoor (male, 33, Ahmedabad)
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at)
values ('7cd00a55-a68a-4aee-8c87-f00544563e81', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'demo.rohan_kapoor95@lovelink.internal', crypt('disabled-demo-account', gen_salt('bf')), now(), '{"provider":"email","providers":["email"]}', '{"full_name":"Rohan Kapoor"}', now(), now())
on conflict (id) do nothing;
update public.profiles set
  username = 'rohan_kapoor95',
  age = 33,
  gender = 'male',
  interested_in = '{"male"}',
  location_city = 'Ahmedabad',
  occupation = 'Air Hostess',
  bio = 'Big dreamer, small joys — movies, gym, and long drives.',
  height_cm = 179,
  hobbies = '{"music","movies","cooking"}',
  relationship_goal = 'not_sure',
  photo_urls = '{"https://api.dicebear.com/7.x/avataaars/svg?seed=RohanKapoor&gender=male"}',
  onboarding_done = true,
  is_demo = true
where id = '7cd00a55-a68a-4aee-8c87-f00544563e81';

-- Bhavna Chawla (female, 23, Pune)
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at)
values ('2dec4fbf-a412-4a9f-9176-d12e44a8fd81', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'demo.bhavna_chawla68@lovelink.internal', crypt('disabled-demo-account', gen_salt('bf')), now(), '{"provider":"email","providers":["email"]}', '{"full_name":"Bhavna Chawla"}', now(), now())
on conflict (id) do nothing;
update public.profiles set
  username = 'bhavna_chawla68',
  age = 23,
  gender = 'female',
  interested_in = '{"male"}',
  location_city = 'Pune',
  occupation = 'Nurse',
  bio = 'Believe in good vibes and honest conversations. Into cricket and movies.',
  height_cm = 167,
  hobbies = '{"cooking","badminton","music"}',
  relationship_goal = 'casual',
  photo_urls = '{"https://api.dicebear.com/7.x/avataaars/svg?seed=BhavnaChawla&gender=female"}',
  onboarding_done = true,
  is_demo = true
where id = '2dec4fbf-a412-4a9f-9176-d12e44a8fd81';

-- Simrandeep Kaur (female, 25, Delhi)
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at)
values ('21d4ba0d-28be-42ec-860c-738f2ef43904', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'demo.simrandeep_kaur94@lovelink.internal', crypt('disabled-demo-account', gen_salt('bf')), now(), '{"provider":"email","providers":["email"]}', '{"full_name":"Simrandeep Kaur"}', now(), now())
on conflict (id) do nothing;
update public.profiles set
  username = 'simrandeep_kaur94',
  age = 25,
  gender = 'female',
  interested_in = '{"everyone"}',
  location_city = 'Delhi',
  occupation = 'Data Analyst',
  bio = 'Big dreamer, small joys — cricket, painting, and long drives.',
  height_cm = 177,
  hobbies = '{"gaming","yoga","foodie"}',
  relationship_goal = 'casual',
  photo_urls = '{"https://api.dicebear.com/7.x/avataaars/svg?seed=SimrandeepKaur&gender=female"}',
  onboarding_done = true,
  is_demo = true
where id = '21d4ba0d-28be-42ec-860c-738f2ef43904';

-- Deepika Nanda (female, 22, Mumbai)
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at)
values ('c128c9fd-d33b-4dff-8006-cd0c1565044c', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'demo.deepika_nanda41@lovelink.internal', crypt('disabled-demo-account', gen_salt('bf')), now(), '{"provider":"email","providers":["email"]}', '{"full_name":"Deepika Nanda"}', now(), now())
on conflict (id) do nothing;
update public.profiles set
  username = 'deepika_nanda41',
  age = 22,
  gender = 'female',
  interested_in = '{"male"}',
  location_city = 'Mumbai',
  occupation = 'Marketing Executive',
  bio = 'Family-oriented, love fashion. Looking for a meaningful connection.',
  height_cm = 156,
  hobbies = '{"trekking","movies","yoga"}',
  relationship_goal = 'long_term',
  photo_urls = '{"https://api.dicebear.com/7.x/avataaars/svg?seed=DeepikaNanda&gender=female"}',
  onboarding_done = true,
  is_demo = true
where id = 'c128c9fd-d33b-4dff-8006-cd0c1565044c';

-- Jaspreet Singh (male, 34, Jaipur)
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at)
values ('b3024c06-db61-4da3-91a6-c7edfba3b354', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'demo.jaspreet_singh43@lovelink.internal', crypt('disabled-demo-account', gen_salt('bf')), now(), '{"provider":"email","providers":["email"]}', '{"full_name":"Jaspreet Singh"}', now(), now())
on conflict (id) do nothing;
update public.profiles set
  username = 'jaspreet_singh43',
  age = 34,
  gender = 'male',
  interested_in = '{"male"}',
  location_city = 'Jaipur',
  occupation = 'Architect',
  bio = 'Simple soul who loves reading and travel. Looking for someone genuine.',
  height_cm = 179,
  hobbies = '{"dancing","cricket","reading"}',
  relationship_goal = 'long_term',
  photo_urls = '{"https://api.dicebear.com/7.x/avataaars/svg?seed=JaspreetSingh&gender=male"}',
  onboarding_done = true,
  is_demo = true
where id = 'b3024c06-db61-4da3-91a6-c7edfba3b354';

-- Gurpreet Singh (male, 29, Pune)
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at)
values ('18e27c1c-3603-4127-a0a3-4833bde3f695', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'demo.gurpreet_singh76@lovelink.internal', crypt('disabled-demo-account', gen_salt('bf')), now(), '{"provider":"email","providers":["email"]}', '{"full_name":"Gurpreet Singh"}', now(), now())
on conflict (id) do nothing;
update public.profiles set
  username = 'gurpreet_singh76',
  age = 29,
  gender = 'male',
  interested_in = '{"male"}',
  location_city = 'Pune',
  occupation = 'Pharmacist',
  bio = 'Big dreamer, small joys — gaming, fashion, and long drives.',
  height_cm = 173,
  hobbies = '{"gym","foodie","gaming"}',
  relationship_goal = 'friendship',
  photo_urls = '{"https://api.dicebear.com/7.x/avataaars/svg?seed=GurpreetSingh&gender=male"}',
  onboarding_done = true,
  is_demo = true
where id = '18e27c1c-3603-4127-a0a3-4833bde3f695';

-- Neha Kapoor (female, 34, Bangalore)
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at)
values ('fa077a7b-bc4c-4fc7-901f-d5fabb418bd5', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'demo.neha_kapoor83@lovelink.internal', crypt('disabled-demo-account', gen_salt('bf')), now(), '{"provider":"email","providers":["email"]}', '{"full_name":"Neha Kapoor"}', now(), now())
on conflict (id) do nothing;
update public.profiles set
  username = 'neha_kapoor83',
  age = 34,
  gender = 'female',
  interested_in = '{"everyone"}',
  location_city = 'Bangalore',
  occupation = 'Data Analyst',
  bio = 'Data Analyst by profession, photography lover by passion. Let''s grab a coffee sometime.',
  height_cm = 178,
  hobbies = '{"badminton","dancing","trekking"}',
  relationship_goal = 'friendship',
  photo_urls = '{"https://api.dicebear.com/7.x/avataaars/svg?seed=NehaKapoor&gender=female"}',
  onboarding_done = true,
  is_demo = true
where id = 'fa077a7b-bc4c-4fc7-901f-d5fabb418bd5';

-- Palak Arora (female, 30, Jalandhar)
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at)
values ('ce9ac189-e93e-4e82-a915-9ea916d0ba50', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'demo.palak_arora30@lovelink.internal', crypt('disabled-demo-account', gen_salt('bf')), now(), '{"provider":"email","providers":["email"]}', '{"full_name":"Palak Arora"}', now(), now())
on conflict (id) do nothing;
update public.profiles set
  username = 'palak_arora30',
  age = 30,
  gender = 'female',
  interested_in = '{"female"}',
  location_city = 'Jalandhar',
  occupation = 'Air Hostess',
  bio = 'Foodie, yoga enthusiast, and forever curious. Swipe if you vibe with positivity.',
  height_cm = 159,
  hobbies = '{"reading","singing","dancing"}',
  relationship_goal = 'friendship',
  photo_urls = '{"https://api.dicebear.com/7.x/avataaars/svg?seed=PalakArora&gender=female"}',
  onboarding_done = true,
  is_demo = true
where id = 'ce9ac189-e93e-4e82-a915-9ea916d0ba50';

-- Harshdeep Singh (male, 23, Lucknow)
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at)
values ('78b0aff7-59f5-4926-bc50-a3776079644b', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'demo.harshdeep_singh23@lovelink.internal', crypt('disabled-demo-account', gen_salt('bf')), now(), '{"provider":"email","providers":["email"]}', '{"full_name":"Harshdeep Singh"}', now(), now())
on conflict (id) do nothing;
update public.profiles set
  username = 'harshdeep_singh23',
  age = 23,
  gender = 'male',
  interested_in = '{"male"}',
  location_city = 'Lucknow',
  occupation = 'Data Analyst',
  bio = 'Foodie, yoga enthusiast, and forever curious. Swipe if you vibe with positivity.',
  height_cm = 189,
  hobbies = '{"singing","gym","cooking"}',
  relationship_goal = 'friendship',
  photo_urls = '{"https://api.dicebear.com/7.x/avataaars/svg?seed=HarshdeepSingh&gender=male"}',
  onboarding_done = true,
  is_demo = true
where id = '78b0aff7-59f5-4926-bc50-a3776079644b';

-- Jasleen Kaur (female, 28, Mumbai)
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at)
values ('ad702f3f-ddc2-4a80-bf04-f5efab61f0ac', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'demo.jasleen_kaur44@lovelink.internal', crypt('disabled-demo-account', gen_salt('bf')), now(), '{"provider":"email","providers":["email"]}', '{"full_name":"Jasleen Kaur"}', now(), now())
on conflict (id) do nothing;
update public.profiles set
  username = 'jasleen_kaur44',
  age = 28,
  gender = 'female',
  interested_in = '{"male"}',
  location_city = 'Mumbai',
  occupation = 'Lawyer',
  bio = 'Foodie, travel enthusiast, and forever curious. Swipe if you vibe with positivity.',
  height_cm = 155,
  hobbies = '{"cooking","reading","photography"}',
  relationship_goal = 'casual',
  photo_urls = '{"https://api.dicebear.com/7.x/avataaars/svg?seed=JasleenKaur&gender=female"}',
  onboarding_done = true,
  is_demo = true
where id = 'ad702f3f-ddc2-4a80-bf04-f5efab61f0ac';

-- Nikhil Bansal (male, 30, Ludhiana)
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at)
values ('725850e6-2917-4f54-858b-b948e517ce2b', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'demo.nikhil_bansal82@lovelink.internal', crypt('disabled-demo-account', gen_salt('bf')), now(), '{"provider":"email","providers":["email"]}', '{"full_name":"Nikhil Bansal"}', now(), now())
on conflict (id) do nothing;
update public.profiles set
  username = 'nikhil_bansal82',
  age = 30,
  gender = 'male',
  interested_in = '{"female"}',
  location_city = 'Ludhiana',
  occupation = 'Architect',
  bio = 'Family-oriented, love trekking. Looking for a meaningful connection.',
  height_cm = 187,
  hobbies = '{"dancing","movies","cooking"}',
  relationship_goal = 'long_term',
  photo_urls = '{"https://api.dicebear.com/7.x/avataaars/svg?seed=NikhilBansal&gender=male"}',
  onboarding_done = true,
  is_demo = true
where id = '725850e6-2917-4f54-858b-b948e517ce2b';

-- Ritika Chopra (female, 31, Lucknow)
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at)
values ('2a038742-de6e-48ca-a893-18b041e4408c', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'demo.ritika_chopra84@lovelink.internal', crypt('disabled-demo-account', gen_salt('bf')), now(), '{"provider":"email","providers":["email"]}', '{"full_name":"Ritika Chopra"}', now(), now())
on conflict (id) do nothing;
update public.profiles set
  username = 'ritika_chopra84',
  age = 31,
  gender = 'female',
  interested_in = '{"everyone"}',
  location_city = 'Lucknow',
  occupation = 'Teacher',
  bio = 'Foodie, gaming enthusiast, and forever curious. Swipe if you vibe with positivity.',
  height_cm = 175,
  hobbies = '{"reading","movies","photography"}',
  relationship_goal = 'not_sure',
  photo_urls = '{"https://api.dicebear.com/7.x/avataaars/svg?seed=RitikaChopra&gender=female"}',
  onboarding_done = true,
  is_demo = true
where id = '2a038742-de6e-48ca-a893-18b041e4408c';

-- Divya Reddy (female, 29, Noida)
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at)
values ('9c793d69-cfcc-4472-ab5a-d975e4936afb', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'demo.divya_reddy74@lovelink.internal', crypt('disabled-demo-account', gen_salt('bf')), now(), '{"provider":"email","providers":["email"]}', '{"full_name":"Divya Reddy"}', now(), now())
on conflict (id) do nothing;
update public.profiles set
  username = 'divya_reddy74',
  age = 29,
  gender = 'female',
  interested_in = '{"everyone"}',
  location_city = 'Noida',
  occupation = 'Entrepreneur',
  bio = 'Down to earth, loves painting, currently exploring cooking too.',
  height_cm = 175,
  hobbies = '{"gym","gaming","travel"}',
  relationship_goal = 'friendship',
  photo_urls = '{"https://api.dicebear.com/7.x/avataaars/svg?seed=DivyaReddy&gender=female"}',
  onboarding_done = true,
  is_demo = true
where id = '9c793d69-cfcc-4472-ab5a-d975e4936afb';

-- Arjun Mehra (male, 28, Chandigarh)
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at)
values ('5990da93-d378-47c2-80be-834aeb050b11', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'demo.arjun_mehra23@lovelink.internal', crypt('disabled-demo-account', gen_salt('bf')), now(), '{"provider":"email","providers":["email"]}', '{"full_name":"Arjun Mehra"}', now(), now())
on conflict (id) do nothing;
update public.profiles set
  username = 'arjun_mehra23',
  age = 28,
  gender = 'male',
  interested_in = '{"male"}',
  location_city = 'Chandigarh',
  occupation = 'Dentist',
  bio = 'Family-oriented, love gaming. Looking for a meaningful connection.',
  height_cm = 172,
  hobbies = '{"badminton","foodie","shopping"}',
  relationship_goal = 'long_term',
  photo_urls = '{"https://api.dicebear.com/7.x/avataaars/svg?seed=ArjunMehra&gender=male"}',
  onboarding_done = true,
  is_demo = true
where id = '5990da93-d378-47c2-80be-834aeb050b11';

-- Riya Mehta (female, 24, Delhi)
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at)
values ('2f138ce3-ced6-4059-ab33-5381036cf84b', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'demo.riya_mehta80@lovelink.internal', crypt('disabled-demo-account', gen_salt('bf')), now(), '{"provider":"email","providers":["email"]}', '{"full_name":"Riya Mehta"}', now(), now())
on conflict (id) do nothing;
update public.profiles set
  username = 'riya_mehta80',
  age = 24,
  gender = 'female',
  interested_in = '{"male"}',
  location_city = 'Delhi',
  occupation = 'Teacher',
  bio = 'Down to earth, loves shopping, currently exploring gaming too.',
  height_cm = 159,
  hobbies = '{"gym","photography","gaming"}',
  relationship_goal = 'not_sure',
  photo_urls = '{"https://api.dicebear.com/7.x/avataaars/svg?seed=RiyaMehta&gender=female"}',
  onboarding_done = true,
  is_demo = true
where id = '2f138ce3-ced6-4059-ab33-5381036cf84b';

-- Aditi Rao (female, 34, Chandigarh)
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at)
values ('ffdc8a22-72d6-4222-b1e9-cd0a224b6775', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'demo.aditi_rao37@lovelink.internal', crypt('disabled-demo-account', gen_salt('bf')), now(), '{"provider":"email","providers":["email"]}', '{"full_name":"Aditi Rao"}', now(), now())
on conflict (id) do nothing;
update public.profiles set
  username = 'aditi_rao37',
  age = 34,
  gender = 'female',
  interested_in = '{"everyone"}',
  location_city = 'Chandigarh',
  occupation = 'Teacher',
  bio = 'Big dreamer, small joys — shopping, reading, and long drives.',
  height_cm = 168,
  hobbies = '{"shopping","gym","photography"}',
  relationship_goal = 'not_sure',
  photo_urls = '{"https://api.dicebear.com/7.x/avataaars/svg?seed=AditiRao&gender=female"}',
  onboarding_done = true,
  is_demo = true
where id = 'ffdc8a22-72d6-4222-b1e9-cd0a224b6775';

-- Meera Nair (female, 29, Delhi)
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at)
values ('edc45a41-bed6-4413-9d9a-be8db9982054', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'demo.meera_nair53@lovelink.internal', crypt('disabled-demo-account', gen_salt('bf')), now(), '{"provider":"email","providers":["email"]}', '{"full_name":"Meera Nair"}', now(), now())
on conflict (id) do nothing;
update public.profiles set
  username = 'meera_nair53',
  age = 29,
  gender = 'female',
  interested_in = '{"male"}',
  location_city = 'Delhi',
  occupation = 'HR Manager',
  bio = 'Big dreamer, small joys — trekking, badminton, and long drives.',
  height_cm = 159,
  hobbies = '{"fashion","gaming","cooking"}',
  relationship_goal = 'long_term',
  photo_urls = '{"https://api.dicebear.com/7.x/avataaars/svg?seed=MeeraNair&gender=female"}',
  onboarding_done = true,
  is_demo = true
where id = 'edc45a41-bed6-4413-9d9a-be8db9982054';

-- Tanvi Saxena (female, 21, Gurugram)
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at)
values ('83ec0b10-1110-4b84-abb9-864aa376b9ab', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'demo.tanvi_saxena45@lovelink.internal', crypt('disabled-demo-account', gen_salt('bf')), now(), '{"provider":"email","providers":["email"]}', '{"full_name":"Tanvi Saxena"}', now(), now())
on conflict (id) do nothing;
update public.profiles set
  username = 'tanvi_saxena45',
  age = 21,
  gender = 'female',
  interested_in = '{"male"}',
  location_city = 'Gurugram',
  occupation = 'Marketing Executive',
  bio = 'Simple soul who loves movies and travel. Looking for someone genuine.',
  height_cm = 162,
  hobbies = '{"movies","dancing","music"}',
  relationship_goal = 'casual',
  photo_urls = '{"https://api.dicebear.com/7.x/avataaars/svg?seed=TanviSaxena&gender=female"}',
  onboarding_done = true,
  is_demo = true
where id = '83ec0b10-1110-4b84-abb9-864aa376b9ab';

-- Ayesha Khan (female, 27, Bangalore)
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at)
values ('a09e7ddd-a5b6-47d0-adba-6e1e7df9272f', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'demo.ayesha_khan41@lovelink.internal', crypt('disabled-demo-account', gen_salt('bf')), now(), '{"provider":"email","providers":["email"]}', '{"full_name":"Ayesha Khan"}', now(), now())
on conflict (id) do nothing;
update public.profiles set
  username = 'ayesha_khan41',
  age = 27,
  gender = 'female',
  interested_in = '{"female"}',
  location_city = 'Bangalore',
  occupation = 'Data Analyst',
  bio = 'Simple soul who loves cricket and shopping. Looking for someone genuine.',
  height_cm = 175,
  hobbies = '{"cooking","music","badminton"}',
  relationship_goal = 'long_term',
  photo_urls = '{"https://api.dicebear.com/7.x/avataaars/svg?seed=AyeshaKhan&gender=female"}',
  onboarding_done = true,
  is_demo = true
where id = 'a09e7ddd-a5b6-47d0-adba-6e1e7df9272f';

-- Simrat Brar (female, 22, Amritsar)
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at)
values ('a935b726-fcc3-43b2-9f20-367168e47298', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'demo.simrat_brar17@lovelink.internal', crypt('disabled-demo-account', gen_salt('bf')), now(), '{"provider":"email","providers":["email"]}', '{"full_name":"Simrat Brar"}', now(), now())
on conflict (id) do nothing;
update public.profiles set
  username = 'simrat_brar17',
  age = 22,
  gender = 'female',
  interested_in = '{"male"}',
  location_city = 'Amritsar',
  occupation = 'Marketing Executive',
  bio = 'Family-oriented, love shopping. Looking for a meaningful connection.',
  height_cm = 167,
  hobbies = '{"gym","cricket","foodie"}',
  relationship_goal = 'not_sure',
  photo_urls = '{"https://api.dicebear.com/7.x/avataaars/svg?seed=SimratBrar&gender=female"}',
  onboarding_done = true,
  is_demo = true
where id = 'a935b726-fcc3-43b2-9f20-367168e47298';

-- Manpreet Kaur (female, 27, Bangalore)
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at)
values ('c698ec90-6515-4b92-b9ef-3eb2127ee736', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'demo.manpreet_kaur97@lovelink.internal', crypt('disabled-demo-account', gen_salt('bf')), now(), '{"provider":"email","providers":["email"]}', '{"full_name":"Manpreet Kaur"}', now(), now())
on conflict (id) do nothing;
update public.profiles set
  username = 'manpreet_kaur97',
  age = 27,
  gender = 'female',
  interested_in = '{"everyone"}',
  location_city = 'Bangalore',
  occupation = 'Air Hostess',
  bio = 'Big dreamer, small joys — movies, reading, and long drives.',
  height_cm = 156,
  hobbies = '{"dancing","music","cooking"}',
  relationship_goal = 'casual',
  photo_urls = '{"https://api.dicebear.com/7.x/avataaars/svg?seed=ManpreetKaur&gender=female"}',
  onboarding_done = true,
  is_demo = true
where id = 'c698ec90-6515-4b92-b9ef-3eb2127ee736';

-- Komal Thakur (female, 23, Hyderabad)
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at)
values ('7e78ddb6-1687-4579-aeda-79b643077590', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'demo.komal_thakur37@lovelink.internal', crypt('disabled-demo-account', gen_salt('bf')), now(), '{"provider":"email","providers":["email"]}', '{"full_name":"Komal Thakur"}', now(), now())
on conflict (id) do nothing;
update public.profiles set
  username = 'komal_thakur37',
  age = 23,
  gender = 'female',
  interested_in = '{"male"}',
  location_city = 'Hyderabad',
  occupation = 'Nurse',
  bio = 'Big dreamer, small joys — travel, badminton, and long drives.',
  height_cm = 156,
  hobbies = '{"trekking","cricket","foodie"}',
  relationship_goal = 'friendship',
  photo_urls = '{"https://api.dicebear.com/7.x/avataaars/svg?seed=KomalThakur&gender=female"}',
  onboarding_done = true,
  is_demo = true
where id = '7e78ddb6-1687-4579-aeda-79b643077590';

-- Navjot Kaur (female, 31, Lucknow)
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at)
values ('23e8ac70-39b1-478e-b7f5-f0fe992274b2', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'demo.navjot_kaur94@lovelink.internal', crypt('disabled-demo-account', gen_salt('bf')), now(), '{"provider":"email","providers":["email"]}', '{"full_name":"Navjot Kaur"}', now(), now())
on conflict (id) do nothing;
update public.profiles set
  username = 'navjot_kaur94',
  age = 31,
  gender = 'female',
  interested_in = '{"male"}',
  location_city = 'Lucknow',
  occupation = 'Dentist',
  bio = 'Big dreamer, small joys — yoga, reading, and long drives.',
  height_cm = 158,
  hobbies = '{"movies","foodie","cricket"}',
  relationship_goal = 'long_term',
  photo_urls = '{"https://api.dicebear.com/7.x/avataaars/svg?seed=NavjotKaur&gender=female"}',
  onboarding_done = true,
  is_demo = true
where id = '23e8ac70-39b1-478e-b7f5-f0fe992274b2';

-- Manvir Singh (male, 32, Amritsar)
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at)
values ('f7fed14a-cad4-4e42-a912-2fc2dcd13aef', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'demo.manvir_singh40@lovelink.internal', crypt('disabled-demo-account', gen_salt('bf')), now(), '{"provider":"email","providers":["email"]}', '{"full_name":"Manvir Singh"}', now(), now())
on conflict (id) do nothing;
update public.profiles set
  username = 'manvir_singh40',
  age = 32,
  gender = 'male',
  interested_in = '{"everyone"}',
  location_city = 'Amritsar',
  occupation = 'Marketing Executive',
  bio = 'Simple soul who loves singing and movies. Looking for someone genuine.',
  height_cm = 165,
  hobbies = '{"travel","movies","yoga"}',
  relationship_goal = 'casual',
  photo_urls = '{"https://api.dicebear.com/7.x/avataaars/svg?seed=ManvirSingh&gender=male"}',
  onboarding_done = true,
  is_demo = true
where id = 'f7fed14a-cad4-4e42-a912-2fc2dcd13aef';

-- Harleen Sidhu (female, 26, Bangalore)
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at)
values ('d90e9a8d-bc8c-44c8-a25e-508fda8d0b3e', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'demo.harleen_sidhu91@lovelink.internal', crypt('disabled-demo-account', gen_salt('bf')), now(), '{"provider":"email","providers":["email"]}', '{"full_name":"Harleen Sidhu"}', now(), now())
on conflict (id) do nothing;
update public.profiles set
  username = 'harleen_sidhu91',
  age = 26,
  gender = 'female',
  interested_in = '{"female"}',
  location_city = 'Bangalore',
  occupation = 'Marketing Executive',
  bio = 'Believe in good vibes and honest conversations. Into yoga and photography.',
  height_cm = 166,
  hobbies = '{"shopping","movies","gym"}',
  relationship_goal = 'friendship',
  photo_urls = '{"https://api.dicebear.com/7.x/avataaars/svg?seed=HarleenSidhu&gender=female"}',
  onboarding_done = true,
  is_demo = true
where id = 'd90e9a8d-bc8c-44c8-a25e-508fda8d0b3e';

-- Kavya Pillai (female, 27, Mumbai)
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at)
values ('90659047-1b10-42c8-ad0a-f4990a00d7c5', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'demo.kavya_pillai48@lovelink.internal', crypt('disabled-demo-account', gen_salt('bf')), now(), '{"provider":"email","providers":["email"]}', '{"full_name":"Kavya Pillai"}', now(), now())
on conflict (id) do nothing;
update public.profiles set
  username = 'kavya_pillai48',
  age = 27,
  gender = 'female',
  interested_in = '{"everyone"}',
  location_city = 'Mumbai',
  occupation = 'Fashion Designer',
  bio = 'Down to earth, loves shopping, currently exploring reading too.',
  height_cm = 164,
  hobbies = '{"badminton","gym","trekking"}',
  relationship_goal = 'long_term',
  photo_urls = '{"https://api.dicebear.com/7.x/avataaars/svg?seed=KavyaPillai&gender=female"}',
  onboarding_done = true,
  is_demo = true
where id = '90659047-1b10-42c8-ad0a-f4990a00d7c5';

-- Ishika Jain (female, 27, Chandigarh)
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at)
values ('1538f882-1707-4e74-8257-ed059e0ae550', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'demo.ishika_jain97@lovelink.internal', crypt('disabled-demo-account', gen_salt('bf')), now(), '{"provider":"email","providers":["email"]}', '{"full_name":"Ishika Jain"}', now(), now())
on conflict (id) do nothing;
update public.profiles set
  username = 'ishika_jain97',
  age = 27,
  gender = 'female',
  interested_in = '{"everyone"}',
  location_city = 'Chandigarh',
  occupation = 'Fitness Trainer',
  bio = 'Big dreamer, small joys — badminton, shopping, and long drives.',
  height_cm = 173,
  hobbies = '{"fashion","photography","travel"}',
  relationship_goal = 'long_term',
  photo_urls = '{"https://api.dicebear.com/7.x/avataaars/svg?seed=IshikaJain&gender=female"}',
  onboarding_done = true,
  is_demo = true
where id = '1538f882-1707-4e74-8257-ed059e0ae550';

-- Swati Joshi (female, 31, Gurugram)
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at)
values ('da778c67-46c4-4e0b-8372-80bab5b428ad', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'demo.swati_joshi13@lovelink.internal', crypt('disabled-demo-account', gen_salt('bf')), now(), '{"provider":"email","providers":["email"]}', '{"full_name":"Swati Joshi"}', now(), now())
on conflict (id) do nothing;
update public.profiles set
  username = 'swati_joshi13',
  age = 31,
  gender = 'female',
  interested_in = '{"male"}',
  location_city = 'Gurugram',
  occupation = 'Lawyer',
  bio = 'Down to earth, loves cooking, currently exploring singing too.',
  height_cm = 177,
  hobbies = '{"reading","movies","gym"}',
  relationship_goal = 'not_sure',
  photo_urls = '{"https://api.dicebear.com/7.x/avataaars/svg?seed=SwatiJoshi&gender=female"}',
  onboarding_done = true,
  is_demo = true
where id = 'da778c67-46c4-4e0b-8372-80bab5b428ad';

-- Sahil Verma (male, 32, Gurugram)
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at)
values ('eb8b17a9-01da-4c0f-8608-f70f94d9a790', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'demo.sahil_verma31@lovelink.internal', crypt('disabled-demo-account', gen_salt('bf')), now(), '{"provider":"email","providers":["email"]}', '{"full_name":"Sahil Verma"}', now(), now())
on conflict (id) do nothing;
update public.profiles set
  username = 'sahil_verma31',
  age = 32,
  gender = 'male',
  interested_in = '{"everyone"}',
  location_city = 'Gurugram',
  occupation = 'Nurse',
  bio = 'Down to earth, loves foodie, currently exploring movies too.',
  height_cm = 175,
  hobbies = '{"foodie","travel","badminton"}',
  relationship_goal = 'not_sure',
  photo_urls = '{"https://api.dicebear.com/7.x/avataaars/svg?seed=SahilVerma&gender=male"}',
  onboarding_done = true,
  is_demo = true
where id = 'eb8b17a9-01da-4c0f-8608-f70f94d9a790';

-- Aditya Sharma (male, 27, Pune)
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at)
values ('0a47e5b8-65c9-4052-aab2-89dc12b6469c', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'demo.aditya_sharma12@lovelink.internal', crypt('disabled-demo-account', gen_salt('bf')), now(), '{"provider":"email","providers":["email"]}', '{"full_name":"Aditya Sharma"}', now(), now())
on conflict (id) do nothing;
update public.profiles set
  username = 'aditya_sharma12',
  age = 27,
  gender = 'male',
  interested_in = '{"male"}',
  location_city = 'Pune',
  occupation = 'Content Writer',
  bio = 'Working as Content Writer. Weekends are for yoga and good food.',
  height_cm = 173,
  hobbies = '{"badminton","photography","cricket"}',
  relationship_goal = 'not_sure',
  photo_urls = '{"https://api.dicebear.com/7.x/avataaars/svg?seed=AdityaSharma&gender=male"}',
  onboarding_done = true,
  is_demo = true
where id = '0a47e5b8-65c9-4052-aab2-89dc12b6469c';

-- Pooja Malhotra (female, 32, Gurugram)
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at)
values ('76e59318-8c6a-4aa8-935b-75baafe962cf', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'demo.pooja_malhotra37@lovelink.internal', crypt('disabled-demo-account', gen_salt('bf')), now(), '{"provider":"email","providers":["email"]}', '{"full_name":"Pooja Malhotra"}', now(), now())
on conflict (id) do nothing;
update public.profiles set
  username = 'pooja_malhotra37',
  age = 32,
  gender = 'female',
  interested_in = '{"male"}',
  location_city = 'Gurugram',
  occupation = 'Civil Engineer',
  bio = 'Simple soul who loves painting and music. Looking for someone genuine.',
  height_cm = 154,
  hobbies = '{"painting","badminton","photography"}',
  relationship_goal = 'friendship',
  photo_urls = '{"https://api.dicebear.com/7.x/avataaars/svg?seed=PoojaMalhotra&gender=female"}',
  onboarding_done = true,
  is_demo = true
where id = '76e59318-8c6a-4aa8-935b-75baafe962cf';

-- Sukhmani Kaur (female, 26, Mumbai)
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at)
values ('36d7c147-7429-49f3-92b7-08a15a7d6ab6', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'demo.sukhmani_kaur92@lovelink.internal', crypt('disabled-demo-account', gen_salt('bf')), now(), '{"provider":"email","providers":["email"]}', '{"full_name":"Sukhmani Kaur"}', now(), now())
on conflict (id) do nothing;
update public.profiles set
  username = 'sukhmani_kaur92',
  age = 26,
  gender = 'female',
  interested_in = '{"female"}',
  location_city = 'Mumbai',
  occupation = 'Software Engineer',
  bio = 'Family-oriented, love movies. Looking for a meaningful connection.',
  height_cm = 154,
  hobbies = '{"badminton","painting","photography"}',
  relationship_goal = 'friendship',
  photo_urls = '{"https://api.dicebear.com/7.x/avataaars/svg?seed=SukhmaniKaur&gender=female"}',
  onboarding_done = true,
  is_demo = true
where id = '36d7c147-7429-49f3-92b7-08a15a7d6ab6';

-- Vidya Menon (female, 25, Delhi)
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at)
values ('ce08a293-54a9-431d-b014-e415fef816a8', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'demo.vidya_menon15@lovelink.internal', crypt('disabled-demo-account', gen_salt('bf')), now(), '{"provider":"email","providers":["email"]}', '{"full_name":"Vidya Menon"}', now(), now())
on conflict (id) do nothing;
update public.profiles set
  username = 'vidya_menon15',
  age = 25,
  gender = 'female',
  interested_in = '{"female"}',
  location_city = 'Delhi',
  occupation = 'Nurse',
  bio = 'Big dreamer, small joys — painting, yoga, and long drives.',
  height_cm = 172,
  hobbies = '{"photography","music","dancing"}',
  relationship_goal = 'friendship',
  photo_urls = '{"https://api.dicebear.com/7.x/avataaars/svg?seed=VidyaMenon&gender=female"}',
  onboarding_done = true,
  is_demo = true
where id = 'ce08a293-54a9-431d-b014-e415fef816a8';

-- Simran Kaur (female, 31, Jalandhar)
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at)
values ('b8cb5e59-529d-4074-a76d-14f6a1325650', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'demo.simran_kaur13@lovelink.internal', crypt('disabled-demo-account', gen_salt('bf')), now(), '{"provider":"email","providers":["email"]}', '{"full_name":"Simran Kaur"}', now(), now())
on conflict (id) do nothing;
update public.profiles set
  username = 'simran_kaur13',
  age = 31,
  gender = 'female',
  interested_in = '{"female"}',
  location_city = 'Jalandhar',
  occupation = 'Civil Engineer',
  bio = 'Family-oriented, love travel. Looking for a meaningful connection.',
  height_cm = 170,
  hobbies = '{"reading","cooking","dancing"}',
  relationship_goal = 'long_term',
  photo_urls = '{"https://api.dicebear.com/7.x/avataaars/svg?seed=SimranKaur&gender=female"}',
  onboarding_done = true,
  is_demo = true
where id = 'b8cb5e59-529d-4074-a76d-14f6a1325650';

-- Shreya Iyer (female, 21, Amritsar)
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at)
values ('fc820802-46ec-4766-873b-f557b95dc0e3', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'demo.shreya_iyer33@lovelink.internal', crypt('disabled-demo-account', gen_salt('bf')), now(), '{"provider":"email","providers":["email"]}', '{"full_name":"Shreya Iyer"}', now(), now())
on conflict (id) do nothing;
update public.profiles set
  username = 'shreya_iyer33',
  age = 21,
  gender = 'female',
  interested_in = '{"everyone"}',
  location_city = 'Amritsar',
  occupation = 'Graphic Designer',
  bio = 'Big dreamer, small joys — painting, music, and long drives.',
  height_cm = 153,
  hobbies = '{"fashion","shopping","gym"}',
  relationship_goal = 'long_term',
  photo_urls = '{"https://api.dicebear.com/7.x/avataaars/svg?seed=ShreyaIyer&gender=female"}',
  onboarding_done = true,
  is_demo = true
where id = 'fc820802-46ec-4766-873b-f557b95dc0e3';

-- Karan Malhotra (male, 28, Gurugram)
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at)
values ('6c2ae36b-ea06-4baa-8cbd-12f2c4d496cd', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'demo.karan_malhotra27@lovelink.internal', crypt('disabled-demo-account', gen_salt('bf')), now(), '{"provider":"email","providers":["email"]}', '{"full_name":"Karan Malhotra"}', now(), now())
on conflict (id) do nothing;
update public.profiles set
  username = 'karan_malhotra27',
  age = 28,
  gender = 'male',
  interested_in = '{"everyone"}',
  location_city = 'Gurugram',
  occupation = 'Marketing Executive',
  bio = 'Foodie, gaming enthusiast, and forever curious. Swipe if you vibe with positivity.',
  height_cm = 175,
  hobbies = '{"movies","photography","painting"}',
  relationship_goal = 'long_term',
  photo_urls = '{"https://api.dicebear.com/7.x/avataaars/svg?seed=KaranMalhotra&gender=male"}',
  onboarding_done = true,
  is_demo = true
where id = '6c2ae36b-ea06-4baa-8cbd-12f2c4d496cd';

-- Anushka Pillai (female, 29, Hyderabad)
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at)
values ('211ab8a7-3851-491a-b170-edbd0479882c', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'demo.anushka_pillai54@lovelink.internal', crypt('disabled-demo-account', gen_salt('bf')), now(), '{"provider":"email","providers":["email"]}', '{"full_name":"Anushka Pillai"}', now(), now())
on conflict (id) do nothing;
update public.profiles set
  username = 'anushka_pillai54',
  age = 29,
  gender = 'female',
  interested_in = '{"male"}',
  location_city = 'Hyderabad',
  occupation = 'Software Engineer',
  bio = 'Software Engineer by profession, shopping lover by passion. Let''s grab a coffee sometime.',
  height_cm = 153,
  hobbies = '{"photography","gym","shopping"}',
  relationship_goal = 'not_sure',
  photo_urls = '{"https://api.dicebear.com/7.x/avataaars/svg?seed=AnushkaPillai&gender=female"}',
  onboarding_done = true,
  is_demo = true
where id = '211ab8a7-3851-491a-b170-edbd0479882c';

-- Kirat Gill (female, 24, Chandigarh)
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at)
values ('53da2e6f-b43c-407f-aae1-63229886cd96', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'demo.kirat_gill30@lovelink.internal', crypt('disabled-demo-account', gen_salt('bf')), now(), '{"provider":"email","providers":["email"]}', '{"full_name":"Kirat Gill"}', now(), now())
on conflict (id) do nothing;
update public.profiles set
  username = 'kirat_gill30',
  age = 24,
  gender = 'female',
  interested_in = '{"female"}',
  location_city = 'Chandigarh',
  occupation = 'Entrepreneur',
  bio = 'Entrepreneur by profession, music lover by passion. Let''s grab a coffee sometime.',
  height_cm = 160,
  hobbies = '{"movies","cooking","badminton"}',
  relationship_goal = 'friendship',
  photo_urls = '{"https://api.dicebear.com/7.x/avataaars/svg?seed=KiratGill&gender=female"}',
  onboarding_done = true,
  is_demo = true
where id = '53da2e6f-b43c-407f-aae1-63229886cd96';

-- Kritika Bansal (female, 24, Pune)
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at)
values ('b96dc03c-804d-4f72-a526-3ace2634910c', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'demo.kritika_bansal68@lovelink.internal', crypt('disabled-demo-account', gen_salt('bf')), now(), '{"provider":"email","providers":["email"]}', '{"full_name":"Kritika Bansal"}', now(), now())
on conflict (id) do nothing;
update public.profiles set
  username = 'kritika_bansal68',
  age = 24,
  gender = 'female',
  interested_in = '{"male"}',
  location_city = 'Pune',
  occupation = 'Architect',
  bio = 'Believe in good vibes and honest conversations. Into movies and photography.',
  height_cm = 176,
  hobbies = '{"trekking","gaming","painting"}',
  relationship_goal = 'long_term',
  photo_urls = '{"https://api.dicebear.com/7.x/avataaars/svg?seed=KritikaBansal&gender=female"}',
  onboarding_done = true,
  is_demo = true
where id = 'b96dc03c-804d-4f72-a526-3ace2634910c';

-- Vikram Rathore (male, 23, Gurugram)
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at)
values ('192c3fb7-7ee7-4956-95c8-b36e0fede9a2', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'demo.vikram_rathore17@lovelink.internal', crypt('disabled-demo-account', gen_salt('bf')), now(), '{"provider":"email","providers":["email"]}', '{"full_name":"Vikram Rathore"}', now(), now())
on conflict (id) do nothing;
update public.profiles set
  username = 'vikram_rathore17',
  age = 23,
  gender = 'male',
  interested_in = '{"female"}',
  location_city = 'Gurugram',
  occupation = 'Fashion Designer',
  bio = 'Fashion Designer by profession, badminton lover by passion. Let''s grab a coffee sometime.',
  height_cm = 182,
  hobbies = '{"cricket","shopping","painting"}',
  relationship_goal = 'not_sure',
  photo_urls = '{"https://api.dicebear.com/7.x/avataaars/svg?seed=VikramRathore&gender=male"}',
  onboarding_done = true,
  is_demo = true
where id = '192c3fb7-7ee7-4956-95c8-b36e0fede9a2';

-- Nisha Rathore (female, 21, Pune)
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at)
values ('57ff15fd-2b18-4f28-8637-7d1969c9fa67', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'demo.nisha_rathore79@lovelink.internal', crypt('disabled-demo-account', gen_salt('bf')), now(), '{"provider":"email","providers":["email"]}', '{"full_name":"Nisha Rathore"}', now(), now())
on conflict (id) do nothing;
update public.profiles set
  username = 'nisha_rathore79',
  age = 21,
  gender = 'female',
  interested_in = '{"male"}',
  location_city = 'Pune',
  occupation = 'Chartered Accountant',
  bio = 'Big dreamer, small joys — reading, photography, and long drives.',
  height_cm = 155,
  hobbies = '{"shopping","cricket","travel"}',
  relationship_goal = 'casual',
  photo_urls = '{"https://api.dicebear.com/7.x/avataaars/svg?seed=NishaRathore&gender=female"}',
  onboarding_done = true,
  is_demo = true
where id = '57ff15fd-2b18-4f28-8637-7d1969c9fa67';

-- Ramandeep Kaur (female, 33, Delhi)
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at)
values ('6fb6e626-1c3f-4f3c-8d6d-ac2ff06973e2', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'demo.ramandeep_kaur51@lovelink.internal', crypt('disabled-demo-account', gen_salt('bf')), now(), '{"provider":"email","providers":["email"]}', '{"full_name":"Ramandeep Kaur"}', now(), now())
on conflict (id) do nothing;
update public.profiles set
  username = 'ramandeep_kaur51',
  age = 33,
  gender = 'female',
  interested_in = '{"female"}',
  location_city = 'Delhi',
  occupation = 'Marketing Executive',
  bio = 'Working as Marketing Executive. Weekends are for singing and good food.',
  height_cm = 168,
  hobbies = '{"painting","cooking","trekking"}',
  relationship_goal = 'not_sure',
  photo_urls = '{"https://api.dicebear.com/7.x/avataaars/svg?seed=RamandeepKaur&gender=female"}',
  onboarding_done = true,
  is_demo = true
where id = '6fb6e626-1c3f-4f3c-8d6d-ac2ff06973e2';

-- Amandeep Kaur (female, 22, Chandigarh)
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at)
values ('55769802-5e2a-4fa2-a8fb-d23ac91efe8b', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'demo.amandeep_kaur43@lovelink.internal', crypt('disabled-demo-account', gen_salt('bf')), now(), '{"provider":"email","providers":["email"]}', '{"full_name":"Amandeep Kaur"}', now(), now())
on conflict (id) do nothing;
update public.profiles set
  username = 'amandeep_kaur43',
  age = 22,
  gender = 'female',
  interested_in = '{"everyone"}',
  location_city = 'Chandigarh',
  occupation = 'Doctor',
  bio = 'Family-oriented, love movies. Looking for a meaningful connection.',
  height_cm = 173,
  hobbies = '{"music","dancing","cricket"}',
  relationship_goal = 'friendship',
  photo_urls = '{"https://api.dicebear.com/7.x/avataaars/svg?seed=AmandeepKaur&gender=female"}',
  onboarding_done = true,
  is_demo = true
where id = '55769802-5e2a-4fa2-a8fb-d23ac91efe8b';

-- Priya Verma (female, 33, Mohali)
insert into auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at)
values ('386846d5-6299-4e28-bfa0-12a73a70bd15', '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated', 'demo.priya_verma55@lovelink.internal', crypt('disabled-demo-account', gen_salt('bf')), now(), '{"provider":"email","providers":["email"]}', '{"full_name":"Priya Verma"}', now(), now())
on conflict (id) do nothing;
update public.profiles set
  username = 'priya_verma55',
  age = 33,
  gender = 'female',
  interested_in = '{"female"}',
  location_city = 'Mohali',
  occupation = 'Nurse',
  bio = 'Believe in good vibes and honest conversations. Into cricket and painting.',
  height_cm = 154,
  hobbies = '{"yoga","painting","cooking"}',
  relationship_goal = 'long_term',
  photo_urls = '{"https://api.dicebear.com/7.x/avataaars/svg?seed=PriyaVerma&gender=female"}',
  onboarding_done = true,
  is_demo = true
where id = '386846d5-6299-4e28-bfa0-12a73a70bd15';
