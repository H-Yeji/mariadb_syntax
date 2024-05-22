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
    on p.author_id=a.id;

-- ///////////////////////////////////////////////////////////////////////////////

-- join된 상황에서 where 조건 : on 뒤에 where 조건 나옴
-- 1) 글쓴이가 있는 글 중에 글의 title과 저자의 email을 출력. 근데 저자의 나이는 25세 이상
select p.title, a.email
from post p
inner join author a -- '글쓴이가 있는' 
    on a.id = p.author_id
where a.AGE >= 25;

-- 2) 모든 글 목록 중에 글의 title과 저자가 있다면 email을 출력,
-- 2024-05-01 이후에 만들어진 글만 출력
select p.title, a.email
from post p
left join author a
    on a.id = p.author_id
where p.title is not null and  p.created_time > '2024-05-01';
-- where date_format(p.created_time, '%Y-%m-%d')>'2024-05-01';
-- 위의 where 코드 ) p.created_time은 datetime 타입으로 설정되어 있어서 date_format 사용 안해도 됨 

-- union : 중복제외한 두 테이블의 select을 결합
-- 컬럼의 개수와 타입이 같아야함의 유의 
-- union all : 중복 포함
select 컬럼1, 컬럼2
from table1
union
select 컬럼1, 컬럼2 
from tabl2; 

-- author 테이블의 name, email 그리고 post 테이블의 title, contents union해보기
select name, email
from author
union
select title, contents
from post;

-- 서브쿼리 : select문 안에 또다른 select문이 있는 쿼리를 서브쿼리라 함 
-- select절 안에 서브쿼리
-- author email과 해당 author가 쓴 글의 개수를 출력
select a.id, a.email, (select count(*) from post p where p.author_id=a.id) as count
from author a;

-- from절 안에 서브쿼리
select a.name from (select * from author) as a; -- 불필요함

-- where절 안에 서브쿼리 
select a.* 
from author a 
inner join post p 
    on a.id=p.author_id;
-- 위 쿼리를 where 서브쿼리로 변경
select * from author 
where id in (select author_id from post); -- 근데 이렇게 하면 중복이 제거됨 

-- group by 
-- 집계함수
select count(*) from author; -- count 하는데 중복 제외
select sum(price) from post;
select avg(price) from post;
select round(avg(price), 0) from post; -- 반올림 

-- group by와 집계함수 
select author_id from post group by author_id;
select author_id, count(*) as cnt, sum(price) as sum, round(avg(price), 0) as avg, min(price) as min, max(price) as max
from post group by author_id;

 -- 이렇게 작성하면 글 작성한 6, 12 제외하고 나머지가 0이어야 하는데 1로 나옴 
 -- 이렇게 나오는 이유 : count는 row의 수를 카운팅하기 때문에 1개로 출력됨 
select a.id, count(*) from author a
left join post p
	on a.id=p.author_id
group by a.id;

-- 위 문제 해결 
select a.id, if(p.id is null, 0, count(*)) as count 
from author a
left join post p
	on a.id=p.author_id
group by a.id;

-- group by와 where 조건 (where이 먼저 옴)
-- 연도 별 post 글 출력, 연도가 null인 데이터 제외 
select date_format(created_time, '%Y') as year, count(*) as cnt
from post
where created_time is not null
group by date_format(created_time, '%Y');

-- 위 쿼리 간결 버전
select date_format(created_time, '%Y') as year, count(*) as cnt
from post
where created_time is not null
group by year; -- select문에서 alias 처리한 별칭을 group by에도 사용할 수 있음

-- having : group by의 조건절
select author_id, count(*) as cnt
from post
group by author_id
having count >=2; -- group by 된 author_id에 대한 having(조건절)임

-- 실습) 포스팅 price가 2000원 이상인 글을 대상으로
-- +) 작성자 별로 몇건인지와 평균 price를 구하기
-- ++) 근데 평균 price가 3000원 이상인 데이터를 대상으로만 통계 출력
select author_id, count(*), round(avg(price), 1) as avg -- 소수점 첫째자리까지 출력
from post
where price >= 2000
group by author_id
having avg >= 3000; -- 별칭 사용 

-- 실습2) 2건 이상의 글을 쓴 사람의 id와 email을 구할건데
-- 나이는 25세 이상인 사람만 통계에 사용하고 결과 반환 
select  a.id, count(a.id) as cnt, a.email
from author a
inner join post p
    on a.id=p.author_id
where a.age>=25 
group by a.id
having cnt >= 2;

select  a.id, count(a.id) as cnt, a.email
from author a
inner join post p
    on a.id=p.author_id
where a.age>=25 
group by a.id
having cnt >= 2
order by max(a.age) desc limit 1; -- order by 추가한 버전

-- 다중열 group by
select author_id, title, count(*) as cnt -- 두번 grouping 한 것의 카운트 
from post
group by author_id, title;