-- author table에 post_count 컬럼 추가(int)
alter table author add column post_count int;
alter table author modify column post_count int default 0;

-- post에 글 쓴 후에, author 테이블에 post_count값에 +1 => 트랜잭션
start transaction; -- 여기부터 한 묶음으로 보겠다
update author set post_count=post_count+1 where id=1; -- post_count 1 증가
insert into post(title, author_id) values('hello world', 19); -- 존재하는 19번 회원 (정상실행)
insert into post(title, author_id) values('bye world', 35); -- 존재하지 않은 35번 회원 (에러발생)
commit;
-- 또는
rollback;

-- 이 전까지 ctrl+shif+enter로 전체 실행하고 조회 -> 다시 rollback하고 -> 조회 -> 1이었던 애들이 0으로 바뀜
select * from author;

-- stored 프로시저를 활용한 트랜잭션 테스트 
-- update나 insert에서 에러 -> 트랜잭션 전체 rollback 
DELIMITER //
CREATE PROCEDURE InsertPostAndUpdateAuthor()
BEGIN
    DECLARE exit handler for SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;
    -- 트랜잭션 시작
    START TRANSACTION;
    -- INSERT 구문
    insert into post(id, title, author_id) values(112, 'eee', 35);
    -- UPDATE 구문
    update author set post_count = post_count + 1 WHERE id = 33;
    -- 모든 작업이 성공했을 때 커밋
    COMMIT;
END //
DELIMITER ; 

call InsertPostAndUpdateAuthor();
-- 위 코드 에러가 발생해야 함 (112번 게시글의 작성자인 author_id = 35이 없음)
