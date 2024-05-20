-- insert into : 데이터 삽입
INSERT INTO 테이블명(컬럼명1, 컬럼명2, .. ) VALUES(데이터1, 데이터2, ..);
INSERT INTO 테이블명 VALUE(데이터1,데이터2, ..);

insert into author(id, name, email) values(1, 'hong', 'abc@naver.com');
insert into posts(id, title, content, author_id) values(101, 'title임', 'content임', 1);


-- select : 데이터 조회 
select * from author;

-- 테이블 제약조건 조회 (다른 스키마 조회하려면 information_schema.가  필요함)
-- 여기서 information_schema가 다른 스키마 (show databases;하면 기본으로 나타나는 데이터베이스)
select * from information_schema.key_column_usage where table_name='posts';
select * from key_column_usage where table_name='posts'; -- use information_scehma 위치에 있으면 이렇게 작성

-- update 테이블명 set 컬럼명=데이터 where id=1;
-- 하기 전 데이터 추가
insert into author(id, name, email) values(2, "kim", "dde@naver.com");
insert into author(id, name, email) values(3, "hello", "vccc@naver.com");
insert into author(id, email) values(4, "bye@naver.com"); -- name을 null로
insert into author(id, email) values(5, "aaa@naver.com");

insert into post value(102, "title2", "content2", 2);
insert into post value(103, "title3", "content3", 3);
insert into post value(104, "title4", "content4", 4);
insert into post value(105, "title5", "content5", 4); -- 위랑 같은 사람이 작성ㅎ 

-- 데이터 변경 (where문 안쓰면 모든 데이터값이 변경되므로 조심)
update author set email="abc@test.com" where name="hong";
update author set name='abc', email='abc@ttest.com' where id=1;
update author set name='update' where id=2;
update author set email='updateEmail@ttt.com' where id=3;
update author set name="notnull" where id=4;

-- delete from 테이블명 where 조건 (where 빠지면 다 사라짐)
delete from author where id=5;

-- select의 다양한 조회 방법
select * from author;
select * from author where id=1;
select * from author where id>2;
select * from author where id>2 and name='hello';

-- 특정 컬럼만을 조회할 때
select name, email from author where id=3;

-- 중복 제거하고 조회하기 (distinct)
insert into author(id, name, email) values(5, 'hello', "this@naver.com");
select distinct name from author; -- 중복없이 모든 name컬럼이 출력됨

insert into post(id, title, contents, author_id) values(106, "title5", "content6", 4);
select distinct title from post; -- 중복없이 모든 title 컬럼이 출력됨

-- 정렬 : order by, 데이터의 출력 결과를 특정 기준으로 정렬
-- 정렬조건 없으면 pk 기준으로 오름차순 정렬
select * from author order by name ASC;
select * from author order by name DESC;

-- 멀티컬럼 order by : 여러 컬럼으로 정렬
select * from post order by title; -- 생략하면 오름차순
select * from post order by title, id desc; -- title 오름차순, id로 내림차순(같을 때)

-- limit number : 특정 숫자로 결과값 개수 제한
select * from author order by id desc limit 1; -- desc해서 한개만 조회

-- alias(별칭)을 이용한 select (as)
select name as 이름, email as 이메일 from author; -- 이름, 이메일로 속성명이 변경됨(일시적)
select a.name, a.email from author as a; -- table명을 a로 바꾸면 a.을 붙여줌(한개일 땐 상관x, 조인할 때 필요)

-- null을 조회 조건으로
select * from post where author_id is null;
select * from post where author_id is not null;

-- post는 지워짐 
delete from post where author_id=1;
delete from post where id=106;
-- id=4 회원이 게시글을 작성했기 때문에 작성자는 지워지지 않음 (에러)
delete from author where id=4;

-- 프로그래머스 실습 [여러 기준으로 정렬하기]
select ANIMAL_ID, NAME, DATETIME
from ANIMAL_INS
order by Name, DATETIME desc;
