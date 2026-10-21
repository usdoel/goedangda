-- LANGKAH 2: Jalankan SETELAH akun dibuat di Authentication -> Users.
-- Memberi role dan nama pada akun. Baris untuk akun yang tidak Anda buat
-- boleh dibiarkan (tidak berpengaruh) atau dihapus.
-- Role yang dikenali aplikasi: Admin, Petugas, Petugas 1, Viewer

with daftar(email, role, nama) as (
  values
    ('arief@goedangda.app',         'Admin',     'H. Arief Purwawinangun, ST'),
    ('administrator@goedangda.app', 'Admin',     'Arief Purwawinangun'),
    ('admin@goedangda.app',         'Admin',     'Administrator'),
    ('bayu@goedangda.app',          'Petugas',   'Bayu Madya Chandra'),
    ('bayu.madya@goedangda.app',    'Petugas 1', 'Bayu Madya Chandra'),
    ('yana.meit@goedangda.app',     'Viewer',    'Yana Mas''ud Tasdiq, ME'),
    ('supiyadi@goedangda.app',      'Viewer',    'Yadi Supiyadi'),
    ('wadirsarpras@goedangda.app',  'Viewer',    'Yadi Supiyadi')
)
update auth.users u
set raw_app_meta_data  = coalesce(u.raw_app_meta_data,  '{}'::jsonb) || jsonb_build_object('role', d.role),
    raw_user_meta_data = coalesce(u.raw_user_meta_data, '{}'::jsonb) || jsonb_build_object('nama', d.nama)
from daftar d
where lower(u.email) = lower(d.email);

-- Pemeriksaan: semua akun harus punya role
select email, raw_app_meta_data->>'role' as role, raw_user_meta_data->>'nama' as nama
from auth.users
order by email;
