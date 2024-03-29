select
    extract(year from creation_date) as year,
    count(distinct membership_id) as member
from 
    {{ref ('fct_table')}}
group by 1