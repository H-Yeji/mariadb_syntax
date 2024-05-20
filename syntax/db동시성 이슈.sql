-- db 동시성 이슈 
-- (1) dirty read 실습 [워크벤치 작성 -> 터미널 실행] 
-- 워크벤치에서 auto_commit해제 후 update 실행 -> commit이 안된 생태
-- 터미널 열어서 select 했을 때 위 변경사항이  변경 됐는지 확인해보기 [확인] -> 변경이 '안되면' dirty read 이슈가 발생하지 않은 것 !

-- (2) phantom read 동시성 이슈 실습
-- 워크벤치에서 시간을 두고 2번의 select 쿼리가 실행됨 [테이블 확인용]
-- 중간에 터미널에서 해당 테이블에 insert into 쿼리를 날림
-- 워크벤치의 결과로 테이블 결과값이 두 개가 동일한지 확인하는 것 
-- 동일해야 repeatable read 격리 수준인 것 !
start transaction
select count(*) from author;
do sleep(15);
select count(*) from author;
commit;
-- 아래는 터미널에 복붙 
insert into author(name, email) values ('phantom read2', 'pppppp@ttt.com');

-- (3) lost update 해결하기 위한 shared lock (공유락)
-- (3) - 1 update만 막는 경우
-- workbench에서 아래 코드 실행
start transaction;
select post_count from author where id=33 lock in share mode; -- 현재 시점에서 post_count 3개임
do sleep(15);
select post_count from author where id=33 lock in share mode;
commit;
-- terminal에서 아래 코드 실행
select post_count from author where id=33;
update author set post_cont = 0 where id=33;
-- 위 코드 실행하면 select 는 실행되는데 update는 안되어야 함 

-- (3) - 2 select부터 막는 경우 (select for update)
start transaction;
select post_count from author where id=33 lock for update; -- 현재 시점에서 post_count 3개임
do sleep(15);
select post_count from author where id=33 lock for update;
commit;
-- terminal에서 아래 코드 실행
select post_count from author where id=33 for update;
update author set post_cont = 0 where id=33;
-- select 부터  막기 때문에 조회도 안돼야 함 