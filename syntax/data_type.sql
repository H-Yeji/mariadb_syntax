-- tinyint는 -128~127까지 표현 
-- author table에 age컬럼 추가
alter table author add column age tinyint;
insert into author(id, name, email, age) values(6, "test2", "test2@ttt.com", 125); --들어감
insert into author(id, name, email, age) values(6, "test2", "test2@ttt.com", 128); --에러남 (age 범위 때문에)
-- unsigned시에 255까지 표현범위 확대 
alter table author modify column age tinyint unsigned; --unsigned로 변경
insert into author(id, name, email, age) values(7, "test3", "test33@ttt.com", 128); --들어감

-- id값은 일반적으로 bigint 사용 

-- decimal 실습
alter table post add column price decimal(10, 3); -- 총자리수 10자리, 소수 3자리
-- 출력은 3자리까지만 잘려서 나옴 
insert into post(id, title, price) values(106, "decimal테스트", 3.123123);
-- upate : price를 1234.1 -> 1234.100으로 3자리 맞춰서 나옴
update post set price=1234.1 where id=106;


-- blob 바이너리 데이터 실습
-- author 테이블에 profile_image 컬럼 blob 형식으로 추가
alter table author add column profile_image blob;
alter table author modify column profile_image longblob;
-- c드라이브 바로 아래 png/jpg사진 저장 
insert into author(id, email, profile_image) values(8, 'abc@naver.com', LOAD_FILE('C:\\abc.png'));

-- enum : 삽입될 수 있는 데이터의 종류를 한정하는 데이터 타입
-- role 컬럼
alter table author add column role varchar(10);
-- role에 user와 admin 도메인값으로 제한을 걸겠다 
-- not null로 주면 default 옵션 없이 제일 첫번째꺼가 기본으로 들어감 
alter table author add column role enum('user', 'admin') not null;
-- default 옵션 사용 
alter table author add column role enum('user', 'admin') not null default 'user';

-- eunm 실습
-- user1을 insert => 에러
insert into author(id, name, email, role) values(9, 'test33', 'test@tttt.com', 'user1');
-- user 또는 admin insert => 정상 
insert into author(id, name, email, role) values(9, 'test33', 'test@tttt.com', 'user');
insert into author(id, name, email, role) values(10, 'test43', 'test4@tttt.com', 'admin');

-- 실습
-- date 타입 -> author 테이블에 birth_date 컬럼을 date로 추가
-- 날짜 타입의 insert는 문자열 형식으로 insert
alter table author add column birth_date date;
insert into author(id, name, email, birth_date) values(13, "13", 'dd@dd.com','1998-06-03');
-- datetime
alter table author add column created_time datetime;
alter table post add column created_time datetime;

-- 값 넣기 
insert into author(id, email, created_time) values(14, 'dd', '1998-06-03 12:20:00');
insert into post(id, title, contents, created_time) values(107, 'dd', 'content2', '1998-06-03 12:20:00');
-- 자동으로 넣기
alter table author modify column datetime created_time default CURRENT_TIMESTAMP;
insert into author(id, email) values(15, 'cc');

-- 비교연산자 (and &&, or ||, not !, != <>)
select * from post where id >= 102 and id <= 104;
select * from post where id between 102 and 104;
select * from post where id = 102 or id > 104;
select * from post where not(id = 102 or id > 104);

-- null인지 아닌지
select * from post where contents is null;
select * from post where contents is not null;

-- in(리스트 형태, 자료형 들)과 not in()
select * from post where id in(101, 102);
select * from post where id not in(101, 102);

-- like
select * from post where title like 'title%';
select * from post where title not like '%o'; -- title이 o로 끝나지 않은 것들

-- ifnull(a, b) : a == null return a, a == null이면 return b
select id, contents, ifnull(author_id, 'no author') as 저자 from post;

-- REGEXP : 정규표현식을 통대로 패턴 연산 수헹
select * from author where name regexp '[a-z]';
select * from author where name regexp '[가-힣]';

-- 날짜 변환 : 숫자 -> 날짜, 문자 -> 날짜
-- cast와 convert
select cast(20200101 as date);
select cast('20200101' as date);
select convert(20200101, date);
select convert('20200101', date);

-- datetime 조회방법
-- (1) 
select * from author where created_time like '2024%'; --2024년으로 시작하는
-- (2)
select * from author where created_time <= '20241231' and created_time >= '19980101';
select * from author where created_time between '19980101' and '20241231';
-- (3) date_format [대소문자 형태 정해져있음]
select date_format(created_time, '%Y-%m') from author; -- 년도와 월 출력
select date_format(created_time, '%Y-%m-%d') from author; -- 년도 월 일
-- 실습
-- author를 조회할 때 date_format을 활용해서 2024년 데이터만 조회 (년만)
select * from author where date_format(created_time, '%Y') = '2024';

-- 오늘 날짜
select now();
