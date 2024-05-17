-- not null 조건 추가
alter table 테이블명 modify column 컬럼명 타입 not null;

-- auto_increment
-- post의 제약조건 조회 (author의 id가 post에 참조되어 있어서 마음대로 바꿀 수 없으므로 제약조건 지울거라 조회먼저)
select * from information_schema.key_column_usage where table_name='post';
-- 제약조건 삭제
alter table post drop foreign key post_ibfk_1;
-- 그 다음 아래 코드 사용 가능 (id 변경 가능 -> 참조 제약조건 지워서)
-- 위 작업 진행하고 나면 아래 코드 잘 진행됨 
alter table author modify column id bigint auto_increment;
alter table post modify column id bigint auto_increment;
alter table post modify column author_id bigint; -- author_id를 int > bigint

-- 삭제된 제약조건 다시 추가
alter table post add constraint post_ibfk_1 foreign key(author_id) references author(id);
-- 다시 조회 
select * from information_schema.key_column_usage where table_name='post';
-- 삭제한 제약조건 추가된 것 확인 가능
-- 다시 추가됐는지 확인할 수 있는 다른 방법 2) author에서 글 쓴 사람을 지워보기 (지워지지 않음)

-- auto_increment 테스트 (id를 알아서 +1해줌)
-- 위에서 author 테이블의 id 컬럼에 auto_increment를 걸어줌 -> 아래 코드 실행하면 id=19로 자동 지정
insert into author(email) values("auto");

-- uuid
alter table post add colum user_id char(36) default (UUID());

-- unique 제약조건
alter table author modify column email varchar(255) unique;

-- on delete cascade 테스트 -> 부모 테이블의 id를 수정하면 수정 안됨 
-- 제약조건 조회 후 삭제 (post_ibfk_1 이 조건)
select * from information_schema.key_column_usage where table_name='post';
alter table post drop foreign key post_ibfk_1;
-- 제약 조건 다시 추가 (on delete cascade 추가)
alter table post add constraint post_ibfk_1 
foreign key(author_id) references author(id) on delete cascade;

-- 그 다음 이걸로 지우고 확인해보면 post도 연쇄돼서 삭제 성공 (cascade때문에)
update author set id=44 where id=4; -- 안바뀜 

-- on update cascade 테스트
-- 제약조선 다시 조회 후 삭제 
select * from information_schema.key_column_usage where table_name='post';
alter table post drop foreign key post_ibfk_1;
-- 제약 조건 다시 추가 (on delete cascade 추가 + on update cascade 추가)
alter table post add constraint post_ibfk_1 foreign key(author_id) references author(id) on delete cascade on update cascade;
-- 아래 코드 실행하고 확인하면 cascade 때문에 post의 author_id까지 44로 바뀜 
update author set id=44 where id=4; 

-- (실습) delete는 set null, update cascade
select * from information_schema.key_column_usage where table_name='post';
alter table post drop foreign key post_ibfk_1;
alter table post add constraint post_ibfk_1 foreign key(author_id) references author(id) on delete set null on update cascade;

