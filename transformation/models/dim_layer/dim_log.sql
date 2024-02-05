SELECT
    membership_id,
    event_name,
    upsell_date,
    new_renewal_cycle,
    CASE
        WHEN currency ='EUR' THEN membership_amount*1.1
        WHEN currency ='GBP' THEN membership_amount*1.25
        WHEN currency ='DKK' THEN membership_amount*0.14
        ELSE membership_amount
    END AS membership_amount,
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