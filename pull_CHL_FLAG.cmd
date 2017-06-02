@echo off

title Pull CHL FLAG

for /f "tokens=1-3 delims=- " %%A in ('echo %DATE%') do (set YY=%%A&SET MM=%%B&SET DD=%%C)
for /f "tokens=1-3 delims=: " %%A in ('echo %TIME%') do (set NHH=%%A&SET MIN=%%B&SET SS=%%C)

rem ���丮 �ּ�
set inDIR=S:\GOCI\data\dbdata
set outDIR=A:\genViewData\data
Set wDIR=\genViewData\data
Set logDIR=\genViewData\log

rem ������ �Է� ����
Set CHL02=COMS_GOCI_L2A_GA_%YY%%MM%%DD%02????.CHL.he5
Set CHL03=COMS_GOCI_L2A_GA_%YY%%MM%%DD%03????.CHL.he5
Set CHL04=COMS_GOCI_L2A_GA_%YY%%MM%%DD%04????.CHL.he5
Set FLAG02=COMS_GOCI_L2A_GA_%YY%%MM%%DD%02????.FLAG.he5
Set FLAG03=COMS_GOCI_L2A_GA_%YY%%MM%%DD%03????.FLAG.he5
Set FLAG04=COMS_GOCI_L2A_GA_%YY%%MM%%DD%04????.FLAG.he5

rem �α� ����
Set LOG=pull_CHL_FLAG.log

rem copy�� �Է� ������ ������  
copy %inDIR%\%CHL02% %outDIR%\
copy %inDIR%\%CHL03% %outDIR%\
copy %inDIR%\%CHL04% %outDIR%\
copy %inDIR%\%FLAG02% %outDIR%\
copy %inDIR%\%FLAG03% %outDIR%\
copy %inDIR%\%FLAG04% %outDIR%\

rem �Է� ������ ������ ������ �˻��ϰ� ó���� �Ŀ� �α� ����
if exist %wDIR%\%CHL02% (
	echo [Success] %CHL02%                       %date% %time% >> %logDIR%\%LOG%
) 
if not exist %wDIR%\%CHL02% (
	echo [  Fail ] %CHL02%                       %date% %time% >> %logDIR%\%LOG%
)

if exist %wDIR%\%CHL03% (
	echo [Success] %CHL03%                       %date% %time% >> %logDIR%\%LOG%
) 
if not exist %wDIR%\%CHL03% (
	echo [  Fail ] %CHL03%                       %date% %time% >> %logDIR%\%LOG%
)

if exist %wDIR%\%CHL04% (
	echo [Success] %CHL04%                       %date% %time% >> %logDIR%\%LOG%
) 
if not exist %wDIR%\%CHL04% (
	echo [  Fail ] %CHL04%                       %date% %time% >> %logDIR%\%LOG%
)

if exist %wDIR%\%FLAG02% (
	echo [Success] %FLAG02%                      %date% %time% >> %logDIR%\%LOG%
) 
if not exist %wDIR%\%FLAG02% (
	echo [  Fail ] %FLAG02%                      %date% %time% >> %logDIR%\%LOG%
)

if exist %wDIR%\%FLAG03% (
	echo [Success] %FLAG03%                      %date% %time% >> %logDIR%\%LOG%
) 
if not exist %wDIR%\%FLAG03% (
	echo [  Fail ] %FLAG03%                      %date% %time% >> %logDIR%\%LOG%
)

if exist %wDIR%\%FLAG04% (
	echo [Success] %FLAG04%                      %date% %time% >> %logDIR%\%LOG%
) 
if not exist %wDIR%\%FLAG04% (
	echo [  Fail ] %FLAG04%                      %date% %time% >> %logDIR%\%LOG%
)
