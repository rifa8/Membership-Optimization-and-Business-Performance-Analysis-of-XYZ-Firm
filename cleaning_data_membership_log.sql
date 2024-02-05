select * from membership_log;

-- Menampilkan jumlah nilai yang hilang untuk setiap kolom

SELECT 
    COUNT(*) AS total_rows,
    COUNT(event_name) AS missing_event_name,
    COUNT(upsell_date) AS missing_upsell_date,
    COUNT(new_renewal_cycle) AS missing_new_renewal_cycle,
    COUNT(membership_id) AS missing_membership_id,
    COUNT(membership_amount) AS missing_membership_amount,
    COUNT(currency) AS missing_currency,
    COUNT(renews_at) AS missing_renews_at,
    COUNT(new_plan) AS missing_new_plan,
    COUNT(churn_date) AS missing_churn_date,
    COUNT(cancellation_date) AS missing_cancellation_date,
    COUNT(log_creation_time) AS missing_log_creation_time
FROM membership_log;

-- Menampilkan duplikat berdasarkan semua kolom
SELECT *
FROM membership_log
WHERE (event_name, upsell_date, new_renewal_cycle, membership_id, membership_amount, currency, renews_at, new_plan, churn_date, cancellation_date, log_creation_time) IN (
    SELECT event_name, upsell_date, new_renewal_cycle, membership_id, membership_amount, currency, renews_at, new_plan, churn_date, cancellation_date, log_creation_time
    FROM membership_log
    GROUP BY event_name, upsell_date, new_renewal_cycle, membership_id, membership_amount, currency, renews_at, new_plan, churn_date, cancellation_date, log_creation_time
    HAVING COUNT(*) > 1);

-- Membuat tabel cadangan
CREATE TABLE membership_log_backup AS
SELECT * FROM membership_log;

-- Menghapus duplikat berdasarkan semua kolom kecuali satu (dibiarkan satu baris)
DELETE FROM membership_log a
USING membership_log b
WHERE a.ctid < b.ctid
  AND a.event_name = b.event_name
  AND a.upsell_date = b.upsell_date
  AND a.new_renewal_cycle = b.new_renewal_cycle
  AND a.membership_id = b.membership_id
  AND a.membership_amount = b.membership_amount
  AND a.currency = b.currency
  AND a.renews_at = b.renews_at
  AND a.new_plan = b.new_plan
  AND a.churn_date = b.churn_date
  AND a.cancellation_date = b.cancellation_date
  AND a.log_creation_time = b.log_creation_time;

-- cek nama-nama event
SELECT
  DISTINCT event_name
FROM membership_log ml;

-- ubah data menjadi format snake_case
UPDATE membership_log
SET event_name = CASE
  WHEN event_name = 'MembershipRenewed' THEN 'membership_renewed'
  WHEN event_name = 'MembershipChurnUpdated' THEN 'membership_churn_updated'
  WHEN event_name = 'MembershipActivated' THEN 'membership_activated'
  WHEN event_name = 'MembershipCaptured' THEN 'membership_captured'
  WHEN event_name = 'MembershipUpsellUpdated' THEN 'membership_upsell_updated'
  WHEN event_name = 'MembershipUpdated' THEN 'membership_updated'
  WHEN event_name = 'MembershipEnded' THEN 'membership_ended'
  WHEN event_name = 'MembershipValueChanged' THEN 'membership_value_changed'
  WHEN event_name = 'MembershipCancelled' THEN 'membership_cancelled'
  END;

-- cek upsell_date untuk event apa
SELECT
  DISTINCT event_name
FROM membership_log
WHERE upsell_date NOT LIKE '';

-- cek upsell_date apakah ada null atu empty value
SELECT
  DISTINCT upsell_date
FROM membership_log;

-- ubah upsell_date ke format yyyy-mm-dd
UPDATE membership_log
SET upsell_date = SUBSTRING(upsell_date, 1, 10)
WHERE upsell_date <> '';

-- ubah tipe data
-- ALTER TABLE membership_log
-- ALTER COLUMN upsell_date TYPE date USING upsell_date::date;


-- cek new_renewal_cycle
SELECT
  DISTINCT new_renewal_cycle
FROM membership_log;

-- isi empty value pada new_renewal_cycle dengan 0
UPDATE membership_log
SET new_renewal_cycle = 0
WHERE new_renewal_cycle = '';

-- ubah new_renewal_cycle type ke integer
ALTER TABLE membership_log
ALTER COLUMN new_renewal_cycle TYPE integer USING new_renewal_cycle::integer;

-- Mengubah tipe data kolom membership_id menjadi integer dengan menggunakan klausa USING
ALTER TABLE membership_log
ALTER COLUMN membership_id TYPE integer USING membership_id::integer;

-- cek membership_id
SELECT
  DISTINCT membership_id
FROM membership
WHERE membership_id NOT IN (
  SELECT
    DISTINCT membership_id
  FROM membership_log
)
ORDER BY 1;

-- cek membership_amount 
SELECT
  DISTINCT membership_amount
FROM membership_log
ORDER BY 1;

-- isi empty value membership_amount dengan 0
UPDATE membership_log
SET membership_amount = 0
WHERE membership_amount = '';

-- ubah column type setelah empty value diisi 0
ALTER TABLE membership_log
ALTER COLUMN membership_amount TYPE float USING membership_amount::float;

-- cek currency
SELECT
  DISTINCT currency
FROM membership_log;

-- ubah data 'null' menjadi '' pada renews_at
UPDATE membership_log
SET renews_at = ''
WHERE renews_at = 'null';

-- ubah format renews_at menjadi yyyy-mm-dd
UPDATE membership_log
SET renews_at = SUBSTRING(renews_at, 1, 10)
WHERE renews_at <> '';

-- cek new_plan
SELECT
  DISTINCT new_plan
FROM membership_log;

-- ubah empty value menjadi 'No Plan' pada new_plan
UPDATE membership_log
SET new_plan = 'No Plan'
WHERE new_plan = '';

-- cek churn_date
SELECT
  DISTINCT churn_date
FROM membership_log;

-- ubah data 'null' menjadi '' pada churn_date
UPDATE membership_log
SET churn_date = ''
WHERE churn_date = 'null';

-- ubah format churn_date menjadi yyyy-mm-dd
UPDATE membership_log
SET churn_date = SUBSTRING(churn_date, 1, 10)
WHERE churn_date <> '';

-- cek cancellation_date
SELECT
  DISTINCT cancellation_date
FROM membership_log;

-- ubah format cancellation_date menjadi yyyy-mm-dd
UPDATE membership_log
SET cancellation_date = SUBSTRING(cancellation_date, 1, 10)
WHERE cancellation_date <> '';

-- cek log_creation_time
SELECT
  DISTINCT log_creation_time
FROM membership_log;

--ubah tipe kolom menjadi date
ALTER TABLE membership_log
ALTER COLUMN log_creation_time TYPE date USING log_creation_time::date;