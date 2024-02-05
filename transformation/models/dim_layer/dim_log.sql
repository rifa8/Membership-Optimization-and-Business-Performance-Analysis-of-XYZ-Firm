SELECT
    membership_id,
    event_name,
    upsell_date,
    new_renewal_cycle,
    membership_amount,
    CASE
        WHEN currency = 'EUR' THEN 'USD'
        WHEN currency = 'GBP' THEN 'USD'
        WHEN currency = 'DKK' THEN 'USD'
        ELSE currency
    END AS currency,
    renews_at,
    new_plan,
    churn_date,
    cancellation_date,
    log_creation_time
FROM membership_log