-- inner join
-- 두 테이블 사이에 지정된 조건에 맞는 레코드만 반환 (on 조건을 통해 교집합 찾기)
select * 
from post -- post먼저 출력 
inner join author 
    on author.id=post.author_id;

select *
from author -- author먼저 출력
inner join post
	on author.id=post.author_id;

-- alias 활용
select * 
from post p -- post먼저 출력 
inner join author a 
    on a.id=p.author_id;

-- (글쓴이가 있는) 원하는 컬럼 조회 
select p.id, p.title, p.contents, a.email
from post p
inner join author a
    on p.author_id=a.id;

-- 모든 글 목록을 출력하고(post는 다 나오도록), 만약 글쓴이가 있다면 이메일 출력
select p.*, a.email
from post p
left join author a -- left outer join 이랑 같은데 outer 생략 가능 
    on p.author_id=a.id

-- join된 상황에서 where 조건 : on 뒤에 where 조건 나옴
-- 1) 글쓴이가 있는 글 중에 글의 title과 저자의 email을 출력. 근데 저자의 나이는 25세 이상
select p.title, a.email
from post p
left join author a
    on a.id = p.author_id
where a.AGE <= 25;

-- 2) 모든 글 목록 중에 글의 title과 저자가 있다면 email을 출력,
-- 2024-05-01 이후에 만들어진 글만 출력
select p.title, a.email
from post p
left join author a
    on a.id = p.author_id
where date_format(created_date, '%Y-%m-%d')>'2024-05-01'; -- 에러 (아직 해결x) 