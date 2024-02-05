SELECT
    transaction_id,
    membership_id,
    CASE
        WHEN currency ='EUR' THEN charge_amount*1.1
        WHEN currency ='GBP' THEN charge_amount*1.25
        WHEN currency ='DKK' THEN charge_amount*0.14
        ELSE charge_amount
    END AS charge_amount,
    CASE
        WHEN currency = 'EUR' THEN 'USD'
        WHEN currency = 'GBP' THEN 'USD'
        WHEN currency = 'DKK' THEN 'USD'
        ELSE currency
    END AS currency,
    description_event,
    discount,
    status,
    message,
    transaction_date,
    triggered_by,
    payment_method
FROM 
   {{ ref ('membership_transactions')}}