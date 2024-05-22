# 1. local에서 sql 덤프파일 생성
mysqldump -u root -p --defualt-character-set=utf8mb4 board > dumpfile.sql
mysqldump -uroot -p board -r dumpfile.sql # 이거 사용 

# 2. dump 파일을 github에 업로드
# 3. 리눅스에서 mariadb 서버 설치
sudo apt-get install mariadb-server

# 4. mariadb 서버 시작
sudo systemctl start mariadb
# sudo systemctl status mariadb
# 5. mariadb 접속 테스트
sudo mariadb -u root -p

# 6. git 설치 및 clone
sudo apt install git
git clone 레파지토리 주소

# 7. < 반대로 해주면 됨 
mysql -u root -p board < dumpfile.sql 
