select b.PRODUCT_CODE, (a.sales_amount * b.price) as SALES 
from (
    select product_id, sum(sales_amount) as sales_amount
    from offline_sale
    group by product_id
) as a 
inner join product as b
    on a.product_id = b.product_id
order by SALES desc, b.product_code;