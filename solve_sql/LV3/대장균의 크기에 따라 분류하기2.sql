select id as ID, 
    case
        when percent_rank() over (order by size_of_colony) * 100 >= 75 then "CRITICAL"
        when percent_rank() over (order by size_of_colony) * 100 >= 50 then "HIGH"
        when percent_rank() over (order by size_of_colony) * 100 >= 25 then "MEDIUM"
        else "LOW"
    END as COLONY_NAME
from ecoli_data
order by id;

/*
    문제 ) size_of_colony를 기준으로 퍼센티지로 나눠 카테고리 출력하기

    1. case - when - end 문 활용
    2. 퍼센티지 구하기 => percent_rank() over (order by 기준이 되는 컬럼) * 100 
*/
