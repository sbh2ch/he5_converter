@echo off

title Push RGB SST

for /f "tokens=1-3 delims=- " %%A in ('echo %DATE%') do (set YY=%%A&SET MM=%%B&SET DD=%%C)
for /f "tokens=1-3 delims=: " %%A in ('echo %TIME%') do (set kHH=%%A&SET MIN=%%B&SET SS=%%C)




rem ���丮 �ּ�
Set DIR=/genViewData/result
Set wDIR=\genViewData\result
Set logDIR=\genViewData\log

rem webKOSC FTP ����
Set IP=222.236.46.41
Set ID=webkosc2016
Set PW=webkosc@1234

rem �α� ����
Set LOG=push_CHL_FLAG.log

rem push �ϱ� ����, ���� �� ���� �Է� ������ temp ������ �̵�
rem �Է� ����(������ ����)(data_h ���丮)
Set inputFile=\genViewData\data\COMS_GOCI_L2A_GA_*.he5

rem ó���� �Է������� temp ������ �̵�
move %inputFile% \genViewData\data\temp

Set i=1

rem txt ���� ���ε�
ncftpput.exe -u %ID% -p %PW% %IP% /home/webkosc2016/www/html/view/img/ %DIR%/*.txt

:_LOOP

rem JPG�� png ���� ���ε�
ncftpput.exe -u %ID% -p %PW% %IP% /home/webkosc2016/www/html/view/img/ %DIR%/CHL_Local_Day%i%*.JPG
ncftpput.exe -u %ID% -p %PW% %IP% /home/webkosc2016/www/html/view/img/ %DIR%/month_graph_day%i%*.png

rem �ѹ��� �ʹ� ���� ������ ���ε����� ���ϵ���, 1�� ������ ����
timeout /t 1 /nobreak > NUL

rem i�� 1�� �����Կ� ���� Day1���� Day7 ���ε�
Set /a i+=1

rem Day7���� ���ε尡 �Ϸ��� ��쿡 ������ Ż��
if "%i%"=="8" (
	goto _NEXT
) else (
	goto _LOOP
)

:_NEXT

echo [Success] %YY%%MM%%DD% push CHL FLAG view data           %date% %time% >> %logDIR%\%LOG%
