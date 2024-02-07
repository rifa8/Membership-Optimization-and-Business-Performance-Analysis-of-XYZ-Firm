SELECT 
    country,
    state,
    key_account_manager,
    membership_plan,
    COUNT(*) AS membership_count
FROM {{ref ('fct_table')}}
GROUP BY country, state, key_account_manager, membership_plan
ORDER BY country, state, key_account_manager, membership_plan