select book_id as BOOK_ID, date_format(published_date, '%Y-%m-%d') as PUBLISHED_DATE
from book
where date_format(PUBLISHED_DATE, '%Y')='2021' and category='인문'
order by PUBLISHED_DATE;
