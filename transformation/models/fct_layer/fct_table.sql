SELECT
    m.membership_id,
    m.membership_amount,
    m.currency,
    m.renewal_cycle,
    m.membership_plan,
    m.creation_date,
    m.email,
    m.company,
    m.street_address,
    m.postcode,
    m.city,
    m.state,
    m.country,
    m.key_account_manager,
    m.animation_team,
    l.event_name,
    l.upsell_date,
    l.new_renewal_cycle,
    l.membership_amount as membership_amount_log,
    l.currency as log_currency,
    l.renews_at,
    l.new_plan,
    l.churn_date,
    l.cancellation_date,
    l.log_creation_time,
    t.charge_amount,
    t.currency as transaction_currency,
    t.description_event,
    t.status,
    t.message,
    t.transaction_date,
    t.triggered_by,
    t.payment_method
FROM {{ ref ('dim_membership')}} AS m
JOIN {{ ref ('dim_log')}} AS l
    ON m.membership_id = l.membership_id 
JOIN {{ ref ('dim_transaction')}} AS t
    ON m.membership_id = t.membership_id