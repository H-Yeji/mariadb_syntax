# update 및 설치
sudo apt-get update
sudo apt-get install redis-server
redis-server --version

# 레디스 접속
# cli : commandline interface 
redis-cli 

# redis는 0~15번까지의 database 구성
# 데이터베이스 선택
select 번호(0번대 default)

# 모든 키 조회
keys *

# 일반 String 자료구조
# key와 value로 값을 세팅
# key값은 중복되면 안됨 
SET key값 value값
set test_key1 test_value1
set user:email:1 hongildong@naver.com

# set할 때 key값이 이미 존재하면 덮어쓰기 되는 것이 기본 -> 유일성이 보장되어야하기 때문에
# nx : not exist 
# nx를 붙이면 들어가지 않고(키 값이 같아서), nx가 없으면 기존의 값을 덮어씀 
set user:email:1 hi@test.com nx

# ex(만료시간-초단위) - ttl (time to live) 
# 예시 ) 세션의 경우 만료시간이 있음 
# 20초 뒤에 없어짐 
set user:email:2 yess@test.com ex 20 

# get을 통해 value값 얻기
get test_key1 

# 특정 key 삭제
del user:email:1

# 현재 데이터베이스의 모든 key 삭제
flushdb

# 좋아요 기능 구현
# likes:posting:1 -> key값
set likes:posting:1 0 # posting likes인데 id =1이라고 가정 
incr likes:positng:1 # 특정 key값의 value를 1만큼 증가 (incr)
decr likes:posting:1 
get likes:posting:1

# 재고 기능 구현 
set product:1:stock 100 # 1번 상품 재고가 100개
decr product:1:stock # 재고의 경우는 1씩 감소시킴 (주문들어오기 때문에)
get product:1:stock

# incr, decr -> 동시성 이슈 없이 증가하고 감소시킬 수 있는 방법 -> 단 1씩만 가능함
# 문자기 때문에 하나씩만 가능 (get 출력하면 다 문자로 출력됨)

#bash쉘을 활용하여 재고 감소 프로그램 작성
