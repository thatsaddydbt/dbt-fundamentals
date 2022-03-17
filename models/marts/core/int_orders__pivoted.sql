{% set payment_methods = ['bank_transfer', 'credit_card', 'coupon', 'gift_card'] -%}

with payments as (
    select * from {{ ref('stg_payments') }}
)

final as (
    select
        order_id,
        {% for payment in payment_methods -%}
        sum(case when payment = '{{ payment }}' then amount else 0 end) as {{ payment_method }}_amount
        {%- if not loop.last -%}
          ,
        {% endif -%}
        {%- endfor -%}
    from {{ ref('stg_payments') }}
    group by 1
)

select * from final