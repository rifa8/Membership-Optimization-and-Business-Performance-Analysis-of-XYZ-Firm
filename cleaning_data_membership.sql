SELECT * FROM public.membership;

-- Menampilkan jumlah nilai yang hilang untuk setiap kolom
SELECT 
    COUNT(*) AS total_rows,
    COUNT(membership_id) AS missing_id,
    COUNT(membership_amount) AS missing_amount,
    COUNT(currency) AS missing_curr,
    COUNT(renewal_cycle) AS missing_renew,
    COUNT(membership_plan) AS missing_plan,
    COUNT(creation_date) AS missing_createdate,
    COUNT(email) AS missing_mail,
    COUNT(company) AS missing_company,
    COUNT(billing_address) AS missing_bill,
    COUNT(key_account_manager) AS missing_key_manage,
    COUNT(animation_team) AS missing_anime
FROM membership;

-- cek kolom membership untuk memastikan
select membership_id  from membership m where membership_id  isnull 

-- hapus null value
delete from membership where membership_id isnull 

-- Menampilkan duplikat berdasarkan semua kolom
select * from  membership m 
group by 
   membership_id, membership_amount, currency, renewal_cycle, membership_plan, creation_date, email, company, billing_address, key_account_manager, animation_team
  HAVING COUNT(*) > 1
-- aman tidak ada duplikasi data

-- Cek nilai unik di tabel membership_amount
 select distinct(membership_amount) from membership m  
 
-- Cek nilai unik di tabel currency
 select distinct(currency) from membership m  
 
-- Cek nilai unik di tabel renewal_cycle
 select distinct(renewal_cycle) from membership m  
 
 -- Cek nilai unik di tabel membership_plan
 select distinct(membership_plan) from membership m 
 
 -- Cek nilai unik di tabel creation_date
 select distinct(creation_date) from membership m;
--ubah tipe data creation_date
ALTER TABLE public.membership ALTER COLUMN creation_date TYPE date USING creation_date::date;

 -- Cek nilai unik di tabel email
 select distinct(email) from membership m;

 -- Cek nilai unik di tabel company
 select distinct(company) from membership m;

 -- Cek nilai unik di tabel billing_address
 select distinct(billing_address) from membership m;

 -- Cek nilai unik di tabel key_account_manager
 select distinct(key_account_manager) from membership m;

-- Cek nilai unik di tabel animation_team
 select distinct(animation_team) from membership m;

 --Ganti tipe data
 ALTER TABLE public.membership ALTER COLUMN membership_id TYPE int USING membership_id::int;

 -- Menetapkan kolom sebagai primary key
ALTER TABLE membership
ADD PRIMARY KEY (membership_id);

