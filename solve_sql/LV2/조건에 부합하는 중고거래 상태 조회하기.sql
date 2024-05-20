select BOARD_ID, WRITER_ID, TITLE, PRICE,
case STATUS
    when 'SALE' then '판매중'
    when 'RESERVED' then '예약중'
    else '거래완료'
end as STATUS
from USED_GOODS_BOARD
where date_format(CREATED_DATE, "%Y-%m-%d") = '2022-10-05' 
order by BOARD_ID desc;

-- 이 문제 데이터 타입 확인하면 created_date 타입이 date로 되어있음
-- 굳이 date_format 사용하지 않고 그냥 where created_date = '2022-10-05'로 해도 됨
