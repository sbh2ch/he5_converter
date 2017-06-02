@echo off

title Gen CHL FLAG

for /f "tokens=1-3 delims=- " %%A in ('echo %DATE%') do (set YY=%%A&SET MM=%%B&SET DD=%%C)
for /f "tokens=1-3 delims=: " %%A in ('echo %TIME%') do (set NHH=%%A&SET MIN=%%B&SET SS=%%C)

rem 디렉토리 주소
Set DIR=/genViewData/data
Set wDIR=\genViewData\data
Set mDIR=\genViewData\matlab
Set logDIR=\genViewData\log

rem 입력 파일(절대경로 포함)
Set CHL02=%wDIR%\COMS_GOCI_L2A_GA_%YY%%MM%%DD%02????.CHL.he5
Set CHL03=%wDIR%\COMS_GOCI_L2A_GA_%YY%%MM%%DD%03????.CHL.he5
Set CHL04=%wDIR%\COMS_GOCI_L2A_GA_%YY%%MM%%DD%04????.CHL.he5
Set FLAG02=%wDIR%\COMS_GOCI_L2A_GA_%YY%%MM%%DD%02????.FLAG.he5
Set FLAG03=%wDIR%\COMS_GOCI_L2A_GA_%YY%%MM%%DD%03????.FLAG.he5
Set FLAG04=%wDIR%\COMS_GOCI_L2A_GA_%YY%%MM%%DD%04????.FLAG.he5
rem 로그 파일
Set LOG=gen_CHL_FLAG.log

rem 입력 파일이 존재할 조건을 검색하여 처리한 후에 로그 저장
if not exist %CHL02% (
	if not exist %CHL03% (
		if not exist %CHL04% (
			rem CHL02 x CHL03 x CHL04 x
			rem 로그 저장
			echo [  Fail ] 1 1 1 %YY%%MM%%DD% gen CHL FLAG view data processing         %date% %time% >> %logDIR%\%LOG%
		)
	)
)

if exist %CHL02% (
	if exist %CHL03% (
		if exist %CHL04% (
			rem CHL02 o CHL03 o CHL04 o
			matlab -automation -r run^('A:%mDIR%\\displayCHL.m'^)
			echo [Success] 0 0 0 %YY%%MM%%DD% gen CHL FLAG view data processing         %date% %time% >> %logDIR%\%LOG%
			goto _NEXT
		)
	)
)

if not exist %CHL02% (
	if exist %CHL03% (
		if exist %CHL04% (
			rem CHL02 x CHL03 o CHL04 o
			rem 입력 파일이 존재하지 않을 경우, 다른 시간대 자료를 복사
			copy %CHL03% %CHL02%
			copy %FLAG03% %FLAG02%
			matlab -automation -r run^('A:%mDIR%\\displayCHL.m'^)
			echo [Success] 1 0 0 %YY%%MM%%DD% gen CHL FLAG view data processing         %date% %time% >> %logDIR%\%LOG%
			rem 처리한 입력파일은 temp 폴더로 이동
			goto _NEXT
		)
	)
	if not exist %CHL03% (
		if exist %CHL04% (
			rem CHL02 x CHL03 x CHL04 o
			copy %CHL04% %CHL02%
			copy %CHL04% %CHL03%
			copy %FLAG04% %FLAG02%
			copy %FLAG04% %FLAG03%
			matlab -automation -r run^('A:%mDIR%\\displayCHL.m'^)
			echo [Success] 1 1 0 %YY%%MM%%DD% gen CHL FLAG view data processing         %date% %time% >> %logDIR%\%LOG%
			goto _NEXT
		)
	)
)

if not exist %CHL03% (
	if exist %CHL02% (
		if exist %CHL04% (
			rem CHL02 o CHL03 x CHL04 o
			copy %CHL04% %CHL03%
			copy %FLAG04% %FLAG03%
			matlab -automation -r run^('A:%mDIR%\\displayCHL.m'^)
			echo [Success] 0 1 0 %YY%%MM%%DD% gen CHL FLAG view data processing         %date% %time% >> %logDIR%\%LOG%
			goto _NEXT
		)
		if not exist %CHL04% (
			rem CHL02 o CHL03 x CHL04 x
			copy %CHL02% %CHL03%
			copy %CHL02% %CHL04%
			copy %FLAG02% %FLAG03%
			copy %FLAG02% %FLAG04%
			matlab -automation -r run^('A:%mDIR%\\displayCHL.m'^)
			echo [Success] 0 1 1 %YY%%MM%%DD% gen CHL FLAG view data processing         %date% %time% >> %logDIR%\%LOG%
			goto _NEXT
	
		)
	)
)

if not exist %CHL04% (
	if exist %CHL03% (
		if exist %CHL02% (
			rem CHL02 o CHL03 o CHL04 x
			copy %CHL03% %CHL04%
			copy %FLAG03% %FLAG04%
			matlab -automation -r run^('A:%mDIR%\\displayCHL.m'^)
			echo [Success] 0 0 1 %YY%%MM%%DD% gen CHL FLAG view data processing         %date% %time% >> %logDIR%\%LOG%
			goto _NEXT
		)
	)
	if not exist %CHL03% (
		if exist %CHL02% (
			rem CHL02 x CHL03 o CHL04 x
			copy %CHL02% %CHL03%
			copy %CHL02% %CHL04%
			copy %FLAG02% %FLAG03%
			copy %FLAG02% %FLAG04%
			matlab -automation -r run^('A:%mDIR%\\displayCHL.m'^)
			echo [Success] 1 0 1 %YY%%MM%%DD% gen CHL FLAG view data processing         %date% %time% >> %logDIR%\%LOG%
			goto _NEXT
		)
	)
)


:_NEXT

copy %CHL02% %wDIR%\temp
copy %CHL03% %wDIR%\temp
copy %CHL04% %wDIR%\temp
copy %FLAG02% %wDIR%\temp
copy %FLAG03% %wDIR%\temp
copy %FLAG04% %wDIR%\temp
