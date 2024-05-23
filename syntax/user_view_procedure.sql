-- 사용자 권한 관리 
-- 사용자 목록 조회
select * from mysql.user;

-- 사용자 생성
-- % 사용 시 -> 원격 포함한 anywhere 접속 (나는 @사용)
create user 'test1'@'localhost' identified by '1234';

-- 사용자에게 권한 부여 
-- test1 로컬호스트 유져한테 board의 author 테이블 조회하는 권한을 줌 
grant select on board.author to 'test1'@'localhost'; -- 이건 board스키마(root권한)에 가서 실행해야 함 

-- 사용자 권한 회수
revoke select on board.author from 'test1'@'localhost'; -- 권한 뺏고 select문 조회하면 안됨 

-- 환경설정을 변경 후 확정 (필수)
flush privileges; 

-- test1으로 로그인 후에
select * from board.athor; -- use board하고 select해도 됨 

-- 권한 조회
show grants for 'test1'@'localhost';

-- 사용자 삭제
drop user 'test1'@'localhost';

-- view
-- view 생성
create view author_for_marketing_team as 
select name, age, role from author; 
-- name, age, role을 볼 수 있는 뷰 테이블을 따로 만들어줌 
-- 실제 데이터가 들어있진 않고, 오직 read only임 

-- view 조회 
select * from author_for_marketing_team; 
-- view에 권한 부여 
grant select on board.author_for_marketing_team to '...';
grant select on board.author_for_marketing_team to 'test1'@'localhost';

-- view 수정/변경 [원본 대체 email 추가]
create or replace view author_for_marketing_team as 
select name, email, age, role from author;

-- view 삭제 
drop view author_for_marketing_team;


-- procedure
-- 프로시저 생성
DELIMITER //
CREATE procedure test_procedure()
BEGIN
    select 'hello world';
END // 
DELIMITER ;

-- 프로시저 호출
call test_procedure();
-- 프로시저 삭제 
drop procedure test_procedure;

-- 게시글 목록 조회 프로시저 생성
DELIMITER //
CREATE procedure 게시글목록조회()
BEGIN
    select * from post;
END // 
DELIMITER ;
call 게시글목록조회();

-- 게시글 단 건 조회 프로시저 생성
DELIMITER //
CREATE procedure 게시글단건조회(in postID int) --  in + 변수명과 타입 적어줘야함 
BEGIN
    select * 
    from post
    where id=postID; -- 변수 추가 
END // 
DELIMITER ;
call 게시글단건조회(1);


DELIMITER //
CREATE procedure 게시글조회(in 저자id int, in 제목 varchar(255)) 
BEGIN
    select * 
    from post
    where author_id=저자id and title=제목; 
END // 
DELIMITER ;
call 게시글조회();

-- 글쓰기 
DELIMITER //
CREATE procedure 글쓰기(in 제목 varchar(255), in 내용 varchar(3000), in 아이디 int) 
BEGIN
    insert into post(title, contents, author_id) values(제목, 내용, 아이디);
    select * from post;
END // 
DELIMITER ;
call 글쓰기("test title", "tttt", 1);

-- 글쓰기 : title, contents, email [변수 이용]
DELIMITER //
CREATE procedure 글쓰기2(in titleInput varchar(255), in contentInput varchar(3000), in emailInput varchar(255)) 
BEGIN
    DECLARE authorId int; -- 변수 선언 
    select id into authorId from author where email=emailInput; -- 선언한 변수에 값 넣어주기
    insert into post(title, contents, author_id) values(titleInput, contentInput, authorId);
    select * from post;
END //  
DELIMITER ;

-- sql에서 문자열 합치는 concat('hello', 'world');
-- 글 상세 조회 : input값이 postId 
-- title, contents, '홍길동' + '님'
DELIMITER //
CREATE procedure 글쓰기2(in postId int) 
BEGIN
    -- 변수 선언
    DECLARE author_name varchar(255);

    -- new name 컬럼 생성
    alter table post add column new_name varchar(255);
    -- postId가 들어오면 이름 찾기 -> author_id로
    select author_id from post where id=postId;
    -- author_id로 author테이블에서 이름 찾기
    select name from author where id=author_id;
    --  변수 설정 
    SET author_name = CONCAT(name,'님');
    insert into post (new_name) values(author_name);

    -- 조회 
    select title, contents, new_name
    from post
END //  
DELIMITER ;

-- concat 
DELIMITER //
CREATE procedure concat활용해글쓰기(in postId int) 
BEGIN
    DECLARE authorName varchar(255);
    select name into authorName from author 
    where id=(select author_id from post where id=postId);

    set authorName = concat(authorName, '님');
    select title, contents, authorName from post where id=postId;

END //  
DELIMITER ;

-- 등급 조회
-- 글을 100개 이상 쓴 사용자는 고수입니다. 출력
-- 10개 이상 100개 미만이면 중수
-- 그 외에는 초보 
-- input : email (email 넣으면 본인이 고수인지 중수인지 초수인지 출력)
DELIMITER //
CREATE procedure 등급조회(in emailInput varchar(255)) 
BEGIN
    DECLARE authorID int;
    DECLARE result int;
    select id into authorID from author where email=emailInput;
    select count(*) into result from post where author_id = authorID;
    if result >= 100 then
        select '고수입니다';
    elseif result >= 10 then
        select '중수입니다.';
    else 
        select '초보입니다.';
    end if; 
END //
DELIMITER ;

-- 반복을 통해 post 대량 생성
-- 사용자가 입력한 반복 횟수에 따라 글이 도배되는데, title은 '안녕하세요' 
DELIMITER //
CREATE procedure 글도배(in cnt int) 
BEGIN
    DECLARE i int default 0;
    while i != cnt do
        -- post에 title='안녕하세요' 대량 생성
        insert into post(title) values('안녕하세요');
        set i = i + 1;
    end while;
END //
DELIMITER ;

-- 프로시저 생성문 조회
show create procedure 프로시저명; 
-- 프로시저 권한부여 
grant execute on board.글도배 to 'test1'@'localhost';