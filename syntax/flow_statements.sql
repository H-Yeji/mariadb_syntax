-- 흐름제어 : case문
select 컬럼1, 컬럼2, 컬럼3,
case 컬럼4 
    when [비교값1] then 결과값1
    when [비교값2] then 결과값2
    else 결과값3
end
from 테이블명;

-- 실습) post 테이블에서 1번 user눈 first author, 2번 user는 second author
select id, title, contents,
case author_id
    when 1 then 'first author' -- 내 테이블에선 when 33으로 해야 first author 출력됨
    when 2 then 'second author'
    else 'others'
end as 'author_id2'
from post;

-- 실습) author_id가 있으면 그대로 출력 (else author_id), 없으면 '익명 사용자'
select id, title, contents,
case
    when is null then '익명 사용자'
    else author_id
end
from post;


-- if문 [if (조건문, a, b) : 조건문이면 a, 아니면 b]
select id, title, contents, if(author_id is null, '익명 사용자', author_id) as author_name
from post;

-- ifnull [ifnull(컬럼, a) : 컬럼이 null이 아니면 그대로, null이면 a 반환]
select id, ifnull(author_id, '익명 사용자') as author_name
from post;
