select
    extract(year from cast(churn_date as date)) as year,
    count(distinct membership_id) as member
from 
    {{ref ('fct_table')}}
where churn_date <> ''
group by 1