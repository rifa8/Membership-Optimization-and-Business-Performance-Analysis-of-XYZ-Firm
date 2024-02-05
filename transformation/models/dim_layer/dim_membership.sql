SELECT
    membership_id,
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
    renewal_cycle,
    membership_plan,
    creation_date,
    email,
    company,
    billing_address,
    key_account_manager,
    animation_team
FROM membership