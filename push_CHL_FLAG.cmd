@echo off

title Push RGB SST

for /f "tokens=1-3 delims=- " %%A in ('echo %DATE%') do (set YY=%%A&SET MM=%%B&SET DD=%%C)
for /f "tokens=1-3 delims=: " %%A in ('echo %TIME%') do (set kHH=%%A&SET MIN=%%B&SET SS=%%C)




rem 디렉토리 주소
Set DIR=/genViewData/result
Set wDIR=\genViewData\result
Set logDIR=\genViewData\log

rem webKOSC FTP 정보
Set IP=222.236.46.41
Set ID=webkosc2016
Set PW=webkosc@1234

rem 로그 파일
Set LOG=push_CHL_FLAG.log

rem push 하기 전에, 생성 시 사용된 입력 파일을 temp 폴더로 이동
rem 입력 파일(절대경로 포함)(data_h 디렉토리)
Set inputFile=\genViewData\data\COMS_GOCI_L2A_GA_*.he5

rem 처리한 입력파일은 temp 폴더로 이동
move %inputFile% \genViewData\data\temp

Set i=1

rem txt 파일 업로드
ncftpput.exe -u %ID% -p %PW% %IP% /home/webkosc2016/www/html/view/img/ %DIR%/*.txt

:_LOOP

rem JPG와 png 파일 업로드
ncftpput.exe -u %ID% -p %PW% %IP% /home/webkosc2016/www/html/view/img/ %DIR%/CHL_Local_Day%i%*.JPG
ncftpput.exe -u %ID% -p %PW% %IP% /home/webkosc2016/www/html/view/img/ %DIR%/month_graph_day%i%*.png

rem 한번에 너무 많은 파일을 업로드하지 못하도록, 1초 딜레이 생성
timeout /t 1 /nobreak > NUL

rem i가 1씩 증가함에 따라 Day1부터 Day7 업로드
Set /a i+=1

rem Day7까지 업로드가 완료한 경우에 루프를 탈출
if "%i%"=="8" (
	goto _NEXT
) else (
	goto _LOOP
)

:_NEXT

echo [Success] %YY%%MM%%DD% push CHL FLAG view data           %date% %time% >> %logDIR%\%LOG%
