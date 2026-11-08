@echo off
chcp 65001 >nul
title לוח הקומה — התקנת הפעלה אוטומטית

rem --- חייב הרשאות מנהל ---
net session >nul 2>&1
if %errorlevel% neq 0 (
  echo.
  echo   ** צריך להריץ כמנהל **
  echo   סגור חלון זה, לחץ קליק ימני על הקובץ ובחר:
  echo   "Run as administrator"  /  "הפעל כמנהל"
  echo.
  pause
  exit /b
)

set "LUSER=luach"
set "LPASS=luach"
set "SRC=%~dp0board-kiosk.bat"

if not exist "%SRC%" (
  echo   ** חסר הקובץ board-kiosk.bat ליד הקובץ הזה **
  echo   ודא ששני הקבצים נמצאים באותה תיקייה.
  pause
  exit /b
)

echo.
echo   ====== מתקין לוח הקומה ======
echo.

rem 1) משתמש ייעודי ללוח
net user %LUSER% %LPASS% /add /fullname:"לוח הקומה" >nul 2>&1
net localgroup Users %LUSER% /add >nul 2>&1
wmic useraccount where "name='%LUSER%'" set PasswordExpires=false >nul 2>&1
echo   [1/5] משתמש "%LUSER%" מוכן  (סיסמה: %LPASS%)

rem 2) כניסה אוטומטית בהדלקה
set "WL=HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
reg add "%WL%" /v AutoAdminLogon    /t REG_SZ /d 1 /f >nul
reg add "%WL%" /v DefaultUserName   /t REG_SZ /d %LUSER% /f >nul
reg add "%WL%" /v DefaultPassword   /t REG_SZ /d %LPASS% /f >nul
reg add "%WL%" /v DefaultDomainName /t REG_SZ /d "%COMPUTERNAME%" /f >nul
echo   [2/5] כניסה אוטומטית — הופעלה

rem 3) התקנת המפעיל
if not exist "C:\luach" md "C:\luach"
copy /y "%SRC%" "C:\luach\board-kiosk.bat" >nul
echo   [3/5] המפעיל הותקן ל-C:\luach

rem 4) הפעלה אוטומטית בכל הדלקה + קיצור בשולחן העבודה
set "STARTUP=C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp"
copy /y "%SRC%" "%STARTUP%\board-kiosk.bat" >nul
copy /y "%SRC%" "C:\Users\Public\Desktop\Open-Board.bat" >nul
echo   [4/5] יופעל בכל הדלקה + קיצור "Open-Board" על שולחן העבודה

rem 5) שלא ייכבה / יישן / יכבה מסך
powercfg /change standby-timeout-ac 0 >nul 2>&1
powercfg /change monitor-timeout-ac 0 >nul 2>&1
powercfg /change hibernate-timeout-ac 0 >nul 2>&1
echo   [5/5] שינה וכיבוי מסך — בוטלו

echo.
echo   ====== הסתיים בהצלחה! ======
echo.
echo   כבה והדלק את המחשב — הוא ייכנס לבד ללוח במסך מלא.
echo   ליציאה מהלוח לתחזוקה: Alt+F4.  לפתיחה מחדש: "Open-Board" בשולחן העבודה.
echo.
pause
