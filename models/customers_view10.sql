-- ============================================================
-- customers_view: a VIEW built on top of the customers seed
-- Combines first + last name and keeps key columns
-- ============================================================

select
    customer_id,
    first_name || ' ' || last_name as full_name,
    city,
    signup_date
from {{ ref('customers') }}