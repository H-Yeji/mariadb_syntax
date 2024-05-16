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

