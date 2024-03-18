select 
    customerkey
    customer_name,
    customer_address,
    customer_phone,
    customer_accbal,
    customer_mktsegment
from {{ ref('customer_pit') }} as pit
left join {{ ref('hub_customer') }} as hub on pit.customer_pk = hub.customer_pk
left join {{ ref('sat_order_customer_details') }} as customer_details
    on pit.customer_pk = customer_details.customer_pk and pit.SAT_ORDER_CUSTOMER_DETAILS_LDTS = customer_details.load_date
left join {{ ref('sat_order_cust_nation_details') }} as customer_nation_details
    on pit.customer_pk = customer_nation_details.customer_pk and pit.SAT_ORDER_CUST_NATION_DETAILS_LDTS = customer_nation_details.load_date
left join {{ ref('sat_order_cust_region_details') }} as customer_region_details
    on pit.customer_pk = customer_region_details.customer_pk and pit.SAT_ORDER_CUST_REGION_DETAILS_LDTS = customer_region_details.load_date

where pit.AS_OF_DATE = (select max(AS_OF_DATE) from {{ ref('customer_pit') }})