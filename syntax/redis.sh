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

# 캐싱 기능 구현
# 1번 author 회원 정보 조회
# select name, email,age from author where id=1; (sql)
# 위 데이터의 결과값을 redis로 캐싱 : json 데이터 형식으로 저장
# redis에서 {}사용할 때 -> 양쪽을 ""처리 
set user:1:detail "{\"name\":\"hong\", \"email\":\"hong@test.com\", \"age\":30}"

# ================================list================================
# redis의 list는 자바의 deque와 같은 구조임 (double-ended queue 양방향 가넝)

# 데이터 왼쪽 삽입
LPUSH key value 
# 데이터 오른쪽 삽입
RPUSH key value
# 데이터 왼쪽부터 꺼내기
LPOP key
# 데이터 오른쪽부터 꺼내기
RPOP key 

# 어떤 목적으로 활용가넝 ?
# 최근 방문한 페이지 조회 / 최근 본 상품 목록 
# 반대로 오래된 방문 페이지 조회 / 오래된 상품 목록 조회 
lpush hongildongs hong1 # hongildongs가 list명
lpush hongildongs hong2
lpush hongildongs hong3
# hong3 hong2 hong1 (위 순서)
lpop hongildongs # hong3출력
rpop hongildongs # hong1 출력 

# 꺼내서 없애는게 아니라, 꺼내서 보기만
lrange key -1 -1

# 데이터 개수 조회 (list)
llen key
# list의 요소 조회시, 범위 지정
lrange key start end # start, end 모두 포함 
lrange hongildongs 0 -1 # 처음부터 끝까지 

# list에 ttl 주기 (제한시간)
expire key time 
expire hongildongs 30
# ttl 조회
ttl key 
ttl hongildongs

# pop과 push를 동시
rpoplpush a_list b_list # a_list에서 rpop을 하고 b_list에 lpush
# 페이지 뒤로 갔다 앞으로 갔다 

# 최근 방문한 페이지 
# 5개 데이터 push -> 최근 방문한 페이지 3개정도 보여주기 
rpush page www.naver1.com
rpush page www.naver2.com
rpush page www.naver3.com
rpush page www.naver4.com
rpush page www.naver5.com

rpop page
rpop page
rpop page 
# lrange 활용
lrange page 2 -1 # 가능하긴 한데 갯수를 아는 경우에만 가능함 (적절하진 않음)

# rpoplpush 활용 실습
# 위 방문 페이지 (page) 리스트에서 뒤로가기 앞으로가기 구현
# 뒤로가기 페이지를 누르면 뒤로가기 페이지가 뭔지 출력
# 다시 앞으로가기 누르면 앞으로간 페이지가 뭔지 출력
# 실패한 실습 [lpoprpush가 없어서] 
lrange page -1 -1 # 마지막 페이지 조회 
rpoplpush page page2  
lrange page2  0 0
lrange page2 -1 -1 # 마지막 페이지 조회 
lpoprpush page2 page # rpoplpush만 존재 ㅜㅜ lpoprpush는 없음 


# ================================set================================
# 가장 큰 특징 => set은 중복을 허용하지 않음 
# set 자료구조에 멤버 추가
sadd members member1
sadd members member2
sadd members member1 # 중복으로 넣고 조회해보기

# set 조회
smembers members # smembers는 명령어 
# set 삭제
del members
# set에서 member 삭제(set remove)
srem members mebmer2 
# set 멤버 개수 반환
scard members 
# 특정 멤버가 set안에 있는지 존재 여부 확인 (결과 0, 1 반환)
sismember members member3 
# 매일 방문자수 계산
# 아래 코드를 여러번 숫자 추가하면서 중복을 넣으며 add해보기
# 그다음 조회하면 중복 없이 4번 넣어도 2번만 출력됨 
# 활용 -> 매일 방문자 수를 계산할 때 활용 (같은 방문자가 방문해도 중복을 허용하지 않기 때문에)
sadd visit:2024-05-27 test@test.com 

# zset (sorted set)
# 정렬의 기준(socre)을 가지고있는 set => zset
zadd zmembers 4 members1 
zadd zmembers 3 members2
zadd zmembers 2 members3
zadd zmembers 1 members4

# 조회 (오름차순, 내림차순)
zrange zmembers 0 -1 # score 기준 오름차순
zrevrange zmembers 0 -1 # score 기준 내림차순 

zadd zmembers 0 members2 # member2가 0번째 우선순위가 돼서 제일 첫번째로 감 ?

# zset 삭제
zrem zmembers members2
# zrank는 해당 멤버가 index 몇번째인지 출력 
zrank zmembers members2

# 최근 본 상품 목록 => sorted set (zset)을 활용하는 것이 적절
zadd recent:products 192411 apple
zadd recent:products 192413 apple
zadd recent:products 192415 banana
zadd recent:products 192420 orange
zadd recent:products 192425 apple
zadd recent:products 192430 apple
# 결과 : zrange로 하면 1이 banana (우선순위 제일 낮음), apple이 덮어써져서 마지막 출력
zrange recent:products 0 2
zrevrange recent:products 0 2
# 중복 -> 덮어써지는 것 확인 (apple이 가장 마지막 우선순위걸로 덮어써짐) -> 체크


# ================================hashes================================
# 해당 자료구조에서는 문자, 숫자가 구분  
hset product:1 name "apple" price 1000 stock 50

hget product:1 name # name을 얻고싶다
hget product:1 price # price를 얻고싶다
hget product:1 stock # stock을 얻고싶다

# 전부 꺼내오고 싶다
hgetall product:1

# 특정 요소값 수정
hset product:1 stock 40 # stock에 가서 알아서 덮어쓰기

# 특정 요소의 값을 증가
hincrby product:1 stock 5 # 재고를 5만큼 증가 시키기
hincrby product:1 stock -5 # 감소 

