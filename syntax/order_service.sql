-- user 테이블 생성 
create table user(
	id int not null auto_increment,
    name varchar(255),
    email varchar(255) not null unique,
    -- userType varchar(255), 
    delYN varchar(255),
    primary key(id)
);
-- alter table user modify column userType enum('S', 'B');
alter table user modify column delYN enum('Y', 'N') not null default 'N';
describe user;
-- user에 데이터 넣기
insert into user(name, email) values('aaa', 'aaa@test.com');
insert into user(name, email) values('bbb', 'bbb@test.com');
insert into user(name, email) values('ccc', 'ccc@test.com');
insert into user(name, email) values('ddd', 'ddd@test.com');
insert into user(name, email) values('eee', 'eee@test.com');
select * from user;


-- 주문 테이블 생성 
create table ordering(
	id int not null auto_increment,
    user_id int, -- 만약 user 테이블에서 delYN이 Y로 들어오면 null이될 수 있음 
	orderTime datetime default current_timestamp, -- 현재시각 
    primary key(id),
    foreign key(user_id) references user(id)
); 
-- ordering 테이블에 값 넣기 
describe ordering;
insert into ordering(user_id) values(1);
insert into ordering(user_id) values(1);
insert into ordering(user_id) values(3);
select * from ordering;


-- 싱픔 테이블 생성 
create table product(
	id int auto_increment,
    product_name varchar(255),
    stock int,
    seller_id int,
    primary key(id),
    foreign key(seller_id) references seller(id) 
);
alter table product modify column seller_id int not null;
-- product에 데이터 넣기 
describe product;
insert into product(product_name, stock, seller_id) values('apple', 10, 1);
insert into product(product_name, stock, seller_id) values('banana', 8, 1);
insert into product(product_name, stock, seller_id) values('box', 2, 2);
insert into product(product_name, stock, seller_id) values('water', 10, 2);
insert into product(product_name, stock, seller_id) values('cup', 5, 3);
select * from product;


-- 주문 디테일 테이블 생성 
create table order_product(
	id int not null auto_increment,
    count int, -- 주문개수 
    order_id int,
    product_id int not null, -- 주문한 상품은 삭제할 수 없음 
    primary key(id),
    foreign key(order_id) references ordering(id),
    foreign key(product_id) references product(id) 
);
-- 데이터 넣기 
describe order_product;
insert into order_product(order_id, product_id, count) values(1, 1, 3); -- 주문 1번은 1번상품을 3개 구매
insert into order_product(order_id, product_id, count) values(2, 3, 1); -- 주문 2번은 3번상품을 1개 구매
-- 주문 3번은 user_id=3인 회원이 두종류를 구매한 것 
insert into order_product(order_id, product_id, count) values(3, 2, 2); -- 주문 3번은 2번상품을 2개 구매
insert into order_product(order_id, product_id, count) values(3, 5, 3); -- 주문 1번은 5번상품을 3개 구매
insert into order_product(count, order_id, product_id) values(10, 1, 1);
select * from order_product;

-- 주소 테이블 생성 
create table user_address(
	id int not null auto_increment,
    city varchar(255),
    street varchar(255),
    user_id int,
    primary key(id),
    foreign key(user_id) references user(id)
);
-- 주소 값 넣기 
describe user_address;
insert into user_address(city, street, user_id) values('city1', 'street1', 1);
insert into user_address(city, street, user_id) values('city2', 'street2', 2);
insert into user_address(city, street, user_id) values('city4', 'street4', 4);
select * from user_address;

-- 판매자 테이블 생성 
create table seller(
	id int auto_increment,
    name varchar(255),
    email varchar(255),
    primary key(id)
);
describe seller;
insert into seller(name, email) values('seller1', 'seller1@test.com');
insert into seller(name, email) values('seller2', 'seller2@test.com');
insert into seller(name, email) values('seller3', 'seller3@test.com');
select * from seller; 

-- 프로시저로 트랜잭션 테스트
-- (1) 주문 프로시저 
-- 존재하는 회원으로 존재하는 상품 주문하기 + 해당 개수만큼 재고 빼기 
DELIMITER //
CREATE PROCEDURE 주문(in userName varchar(255), in item varchar(255), in cnt int)
BEGIN
	DECLARE userID int;
    DECLARE orderID int;
    DECLARE productID int;
    BEGIN
        ROLLBACK;
    END;
    -- 입력받은 이름과 같은 회원의 id 가져오기 -> userID
    select id into userID from user where name=userName;
    -- 찾아온 userID를 주문실행 테이블에 삽입 (주문을 했음을 알려줌) 
    insert into ordering(user_id) values(userID);
    -- 주문 실행한 기록의 id (주문id) 찾아오기 -> orderID
    select id into orderID from ordering where user_id=userID limit 1;
    -- 입력받은 상품의 이름과 같은 상품id를 가져오기 -> productID 
    select id into productID from product where product_name=item;
    
    -- 찾아온 orderID와 productID, 그리고 재고까지 order_product 테이블에 삽입 -> 주문이 완료됨 
    insert into order_product(count, order_id, product_id) values(cnt, orderID, productID);
    
    -- 주문이 들어간 cnt만큼 재고에서 빼기
    update product set stock = stock - cnt where id=productID;
    COMMIT;
END
// DELIMITER ;

select * from user;
select * from ordering;
select * from order_product;
select * from product;
-- 확인하면 주문을 넣은 개수만큼 해당 상품의 재고가 줄어듦 ! 주문 성공 

-- (2) 판매 프로시저 
DELIMITER //
CREATE PROCEDURE 판매(in sellerName varchar(255), in item varchar(255), in cnt int)
BEGIN
	DECLARE sellerID int;
    DECLARE productID int;
    
    select id into sellerID from seller where name=sellerName;
    -- if 상품이 존재하면 cnt를 stock에 증가
    -- else 없다면 insert해주기 
    select id into productID from product where product_name=item;
	IF productID IS NOT NULL THEN
		update product set stock = stock + cnt where id=productID;
	else
		insert into product(product_name, stock, seller_id) values(item, cnt, sellerID);
	end if;
END 
// DELIMITER ;

--  user테이블에서 회원탈퇴 (delYN =Y)이면 주소 테이블의 값을 null로 변경
DELIMITER //
CREATE PROCEDURE 회원탈퇴_주소조회()
BEGIN
	update user_address
	set user_id=null, city=null, street=null
    where user_id IN(
		select id
		from user
		where delYN='Y'
	);
END 
// DELIMITER ; 
