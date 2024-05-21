select date_format(DATETIME, '%H') as HOUR, count(*) as COUNT
from ANIMAL_OUTS
-- where date_format(DATETIME, '%H:%m')>='09:00' and date_format(DATETIME, '%H:%m')<='19:59'
where date_format(DATETIME, '%H:%i') between '09:00' and '19:59'
group by HOUR
order by HOUR asc;

-- 시간:분:초 => H:i:s (format) 
-- cast(date_format(DATETIME, '%H') as unsigned) as HOUR => 이렇게 작성하면 09가 아니라 9로 나옴

