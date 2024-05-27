
while true; do
    # 사용자가 product를 입력할 때마다, 현재 시간을 score로 해서 zadd
    echo "원하는 상품 입력 또는 나가기(exit)"
    read product 
    if [ "$product" == "exit" ]; then
        echo "나간다 바바"
        break
    fi
    timestamp=$(date +%s) # date하면 리눅스에서 오늘 날짜 뽑아낼 수 있는데 %s하면 초로 뽑앙줌
    redis-cli zadd recent $timestamp $product # score를 timestamp로 줌

done

echo "사용자의 최근 본 상품 목록 5개: "
redis-cli zrevrange recent:product 0 4


# redis 접속해서 아래 대입하고 위 sh 실행 
zadd recent 1 apple
zadd recent 2 apple
zadd recent 3 banana
zadd recent 4 orange
zadd recent 5 berry
zadd recent 6 apple
# apple berry orange banana 순서 (apple이 우선순위 제일 낮음)
zrevrange recent:product -1 -1
