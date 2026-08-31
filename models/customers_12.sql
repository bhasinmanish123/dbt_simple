-- ============================================================
-- customers_view: a VIEW built on top of the customers seed
-- Simple columns first, calculated columns last (SQLFluff ST06)
-- ============================================================

select
    customer_id
from {{ ref('customers') }}
