@echo off
chcp 65001 >nul
title לוח הקומה — התקנת הפעלה אוטומטית

net session >nul 2>&1 || (echo. & echo   ** צריך להריץ כמנהל ** & echo   קליק ימני על install.bat ובחר "הפעל כמנהל" & echo. & pause & exit /b)

set "LUSER=luach"
set "LPASS=luach"
set "S=%~dp0"

echo.
echo   ====== מתקין לוח הקומה ======
echo.

net user %LUSER% %LPASS% /add /fullname:"לוח הקומה" >nul 2>&1
net localgroup Users %LUSER% /add >nul 2>&1
wmic useraccount where "name='%LUSER%'" set PasswordExpires=false >nul 2>&1
echo   [1/5] משתמש "%LUSER%" מוכן  (סיסמה: %LPASS%)

set "WL=HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
reg add "%WL%" /v AutoAdminLogon    /t REG_SZ /d 1 /f >nul
reg add "%WL%" /v DefaultUserName   /t REG_SZ /d %LUSER% /f >nul
reg add "%WL%" /v DefaultPassword   /t REG_SZ /d %LPASS% /f >nul
reg add "%WL%" /v DefaultDomainName /t REG_SZ /d "%COMPUTERNAME%" /f >nul
echo   [2/5] כניסה אוטומטית — הופעלה

if not exist "C:\luach" md "C:\luach"
copy /y "%S%board-kiosk.bat" "C:\luach\board-kiosk.bat" >nul
copy /y "%S%run-hidden.vbs"  "C:\luach\run-hidden.vbs"  >nul
copy /y "%S%Open-Board.bat"  "C:\luach\Open-Board.bat"  >nul
copy /y "%S%Stop-Board.bat"  "C:\luach\Stop-Board.bat"  >nul
del "C:\luach\STOP.flag" >nul 2>&1
echo   [3/5] הקבצים הותקנו ל-C:\luach

set "STARTUP=C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp"
del "%STARTUP%\board-kiosk.bat" >nul 2>&1
copy /y "%S%run-hidden.vbs" "%STARTUP%\luach-board.vbs" >nul
copy /y "%S%Open-Board.bat" "C:\Users\Public\Desktop\Open-Board.bat" >nul
copy /y "%S%Stop-Board.bat" "C:\Users\Public\Desktop\Stop-Board.bat" >nul
echo   [4/5] יופעל בכל הדלקה + קיצורים על שולחן העבודה

powercfg /change standby-timeout-ac 0 >nul 2>&1
powercfg /change monitor-timeout-ac 0 >nul 2>&1
powercfg /change hibernate-timeout-ac 0 >nul 2>&1
echo   [5/5] שינה וכיבוי מסך — בוטלו

echo.
echo   ====== הסתיים בהצלחה! ======
echo.
echo   כבה והדלק את המחשב — הוא ייכנס לבד ללוח במסך מלא.
echo   לתחזוקה: Stop-Board לעצירה, Open-Board לפתיחה.
echo.
pause
