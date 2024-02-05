select * from membership_transactions

-- Menampilkan jumlah nilai yang hilang untuk setiap kolom
SELECT 
    COUNT(*) AS total_rows,
    COUNT(charge_amount) AS missing_charge_amount,
    COUNT(currency) AS missing_currency,
    COUNT(membership_id) AS missing_id,
    COUNT(description_event) AS missing_desc,
    COUNT(discount) AS missing_disc,
    COUNT(status) AS missing_status,
    COUNT(message) AS missing_msg,
    COUNT(transaction_date) AS missing_date,
    COUNT(triggered_by) AS missing_trg,
    COUNT(payment_method) AS missing_pay
FROM membership_transactions;

-- Menampilkan duplikat berdasarkan semua kolom
SELECT *
FROM membership_transactions 
WHERE (membership_id, charge_amount, currency, description_event, discount, status, message, transaction_date, triggered_by, payment_method) IN (
    SELECT membership_id, charge_amount, currency, description_event, discount, status, message, transaction_date, triggered_by, payment_method
    FROM membership_transactions 
    GROUP BY membership_id, charge_amount, currency, description_event, discount, status, message, transaction_date, triggered_by, payment_method
    HAVING COUNT(*) > 1);
   
-- Membuat tabel cadangan
CREATE TABLE membership_transaction_backup AS
SELECT * FROM membership_transactions;
--UPDATE membership_transactions mt
--SET message = mb.message
--FROM membership_transaction_backup mb
--WHERE mt.transaction_date = mb.transaction_date;

-- Menghapus duplikat berdasarkan semua kolom kecuali satu (dibiarkan satu baris)
DELETE FROM membership_transactions a
USING membership_transactions b
WHERE a.ctid < b.ctid
  AND a.membership_id = b.membership_id
  AND a.charge_amount = b.charge_amount
  AND a.currency = b.currency
  AND a.description_event = b.description_event
  AND a.discount = b.discount
  AND a.status = b.status
  AND a.message = b.message
  AND a.transaction_date = b.transaction_date
  AND a.triggered_by = b.triggered_by
  AND a.payment_method = b.payment_method;
 
 -- Cek nilai unik di tabel charge amount
 select distinct(charge_amount) from membership_transactions 
 
 -- Hapus koma
UPDATE membership_transactions
SET charge_amount = REPLACE(TRIM(BOTH ' ' FROM charge_amount), ',', '')
-- Setelah itu lakukan perubahan tipe data ke float, karena ada yg bernilai koma disana

-- Cek nilai unik di tabel currency
select distinct(currency) from membership_transactions 

-- Mengisi Empty Value dengan USD
UPDATE membership_transactions
SET currency  = 'USD'
WHERE currency  = '';

-- Cek nilai unik di tabel desc_event
SELECT DISTINCT (description_event)
FROM membership_transactions mt ;

-- Cek nilai unik di tabel discount
SELECT DISTINCT (discount)
FROM membership_transactions mt ;

-- Cek nilai unik di tabel status
SELECT DISTINCT (status)
FROM membership_transactions mt ;

-- Ubah ke huruf kecil semua
UPDATE membership_transactions
SET status = LOWER(status); 

-- Cek nilai unik di tabel message
SELECT DISTINCT (message)
FROM membership_transactions mt ;

-- Ubah ke huruf kecil dan isi empty value
UPDATE membership_transactions
SET message  = LOWER(message);
--
UPDATE membership_transactions
SET message  = 'no information'
WHERE message  = '';

-- Cek nilai unik di tabel transaction_date
SELECT DISTINCT (transaction_date)
FROM membership_transactions mt ;
--ubah menjadi tipe data date
ALTER TABLE public.membership_transactions ALTER COLUMN transaction_date TYPE date USING transaction_date::date;

-- Cek nilai unik di tabel triggered
SELECT DISTINCT (triggered_by)
FROM membership_transactions mt ;

-- Cek nilai unik di tabel payment
SELECT DISTINCT (payment_method)
FROM membership_transactions mt ;

-- tambahkan transaction_id
ALTER TABLE membership_transactions
ADD COLUMN transaction_id SERIAL;

-- Menetapkan foreign key yang merujuk ke primary key di tabel referensi
ALTER TABLE membership_transactions
ADD CONSTRAINT membership_id
FOREIGN KEY (membership_id)
REFERENCES membership(membership_id);









