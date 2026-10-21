-- LANGKAH 5: Jalankan HANYA SETELAH login dengan akun baru sudah berhasil di aplikasi.
-- Mengunci tiga tabel: hanya akun yang login dan punya role yang bisa mengakses.
--   Viewer                    : hanya membaca
--   Admin / Petugas / Petugas 1: membaca, menambah, mengubah
--   Admin                     : juga boleh menghapus

-- Hak akses dasar (sekaligus memenuhi aturan grant Supabase 30 Oktober)
grant select, insert, update, delete on public.master_barang, public.barang_masuk, public.barang_keluar to authenticated;
grant usage, select on all sequences in schema public to authenticated;

alter table public.master_barang enable row level security;
alter table public.barang_masuk  enable row level security;
alter table public.barang_keluar enable row level security;

-- master_barang
create policy "master_baca"  on public.master_barang for select to authenticated
  using ((auth.jwt()->'app_metadata'->>'role') in ('Admin','Petugas','Petugas 1','Viewer'));
create policy "master_tambah" on public.master_barang for insert to authenticated
  with check ((auth.jwt()->'app_metadata'->>'role') in ('Admin','Petugas','Petugas 1'));
create policy "master_ubah"  on public.master_barang for update to authenticated
  using      ((auth.jwt()->'app_metadata'->>'role') in ('Admin','Petugas','Petugas 1'))
  with check ((auth.jwt()->'app_metadata'->>'role') in ('Admin','Petugas','Petugas 1'));
create policy "master_hapus" on public.master_barang for delete to authenticated
  using ((auth.jwt()->'app_metadata'->>'role') = 'Admin');

-- barang_masuk
create policy "masuk_baca"   on public.barang_masuk for select to authenticated
  using ((auth.jwt()->'app_metadata'->>'role') in ('Admin','Petugas','Petugas 1','Viewer'));
create policy "masuk_tambah" on public.barang_masuk for insert to authenticated
  with check ((auth.jwt()->'app_metadata'->>'role') in ('Admin','Petugas','Petugas 1'));
create policy "masuk_ubah"   on public.barang_masuk for update to authenticated
  using      ((auth.jwt()->'app_metadata'->>'role') in ('Admin','Petugas','Petugas 1'))
  with check ((auth.jwt()->'app_metadata'->>'role') in ('Admin','Petugas','Petugas 1'));
create policy "masuk_hapus"  on public.barang_masuk for delete to authenticated
  using ((auth.jwt()->'app_metadata'->>'role') = 'Admin');

-- barang_keluar
create policy "keluar_baca"   on public.barang_keluar for select to authenticated
  using ((auth.jwt()->'app_metadata'->>'role') in ('Admin','Petugas','Petugas 1','Viewer'));
create policy "keluar_tambah" on public.barang_keluar for insert to authenticated
  with check ((auth.jwt()->'app_metadata'->>'role') in ('Admin','Petugas','Petugas 1'));
create policy "keluar_ubah"   on public.barang_keluar for update to authenticated
  using      ((auth.jwt()->'app_metadata'->>'role') in ('Admin','Petugas','Petugas 1'))
  with check ((auth.jwt()->'app_metadata'->>'role') in ('Admin','Petugas','Petugas 1'));
create policy "keluar_hapus"  on public.barang_keluar for delete to authenticated
  using ((auth.jwt()->'app_metadata'->>'role') = 'Admin');

-- Cabut akses pengunjung tanpa login
revoke all on public.master_barang, public.barang_masuk, public.barang_keluar from anon;

-- Pemeriksaan: ketiga tabel harus rowsecurity = true
select tablename, rowsecurity from pg_tables
where schemaname = 'public' and tablename in ('master_barang','barang_masuk','barang_keluar');

/* ===== JALUR DARURAT (hanya jika aplikasi macet setelah RLS) =====
alter table public.master_barang disable row level security;
alter table public.barang_masuk  disable row level security;
alter table public.barang_keluar disable row level security;
grant select, insert, update, delete on public.master_barang, public.barang_masuk, public.barang_keluar to anon;
=================================================================== */
