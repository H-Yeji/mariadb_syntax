select USER_ID, PRODUCT_ID
from ONLINE_SALE
group by USER_ID, PRODUCT_ID
having count(*) >= 2 -- 재구매한 횟수 
order by USER_ID asc, PRODUCT_ID desc;
