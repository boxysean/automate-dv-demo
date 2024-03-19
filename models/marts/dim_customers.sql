with latest_order_customer_details as (
    select
        *
    from {{ ref('sat_order_customer_details') }}
    qualify rank() over (partition by customer_pk order by load_date desc) = 1
),

latest_customer_nation_details as (
    select
        *
    from {{ ref('sat_order_cust_nation_details') }}
    qualify rank() over (partition by customer_pk order by load_date desc) = 1
),

latest_customer_region_details as (
    select
        *
    from {{ ref('sat_order_cust_region_details') }}
    qualify rank() over (partition by customer_pk order by load_date desc) = 1
)

select 
    customerkey,
    customer_name,
    customer_address,
    customer_phone,
    customer_accbal,
    customer_mktsegment
from {{ ref('hub_customer') }} as hub
left join latest_order_customer_details
    on hub.customer_pk = latest_order_customer_details.customer_pk
left join latest_customer_nation_details
    on hub.customer_pk = latest_customer_nation_details.customer_pk
left join latest_customer_region_details
    on hub.customer_pk = latest_customer_region_details.customer_pk
