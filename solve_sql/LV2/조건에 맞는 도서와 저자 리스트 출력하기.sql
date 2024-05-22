select b.BOOK_ID, a.AUTHOR_NAME, 
date_format(b.PUBLISHED_DATE, '%Y-%m-%d') as PUBLISHED_DATE
from BOOK b
inner join AUTHOR a
    on b.AUTHOR_ID=a.AUTHOR_ID
where b.CATEGORY='경제'
order by PUBLISHED_DATE asc;

-- 문제에 author_id가 not null(nullable=false) 이므로 
-- book테이블 기준으로 left join 해도 같은 결과 
