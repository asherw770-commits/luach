@echo off
chcp 65001 >nul
rem ===== לוח הקומה — שומר מסך מלא (watchdog) =====
set "URL=https://asherw770-commits.github.io/luach/"
set "DIR=C:\luach"
set "PROFILE=%DIR%\chrome-profile"
set "FLAGS=--kiosk --start-fullscreen --user-data-dir=%PROFILE% --no-first-run --no-default-browser-check --disable-infobars --disable-session-crashed-bubble --hide-crash-restore-bubble --disable-features=TranslateUI --autoplay-policy=no-user-gesture-required --overscroll-history-navigation=0 --noerrdialogs --disable-pinch --disable-component-update --check-for-update-interval=604800 --disable-background-timer-throttling --disable-renderer-backgrounding --disable-backgrounding-occluded-windows"

set "CHROME="
if exist "C:\Program Files\Google\Chrome\Application\chrome.exe" set "CHROME=C:\Program Files\Google\Chrome\Application\chrome.exe"
if not defined CHROME if exist "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" set "CHROME=C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"

rem --- המתנה שהרשת תעלה (עד ~90 שניות) כדי לא להיתקע בדף שגיאה ---
set /a NETTRY=0
:netwait
if exist "%DIR%\STOP.flag" goto end
ping -n 1 asherw770-commits.github.io >nul 2>&1 && goto netok
set /a NETTRY+=1
if %NETTRY% geq 30 goto netok
timeout /t 3 /nobreak >nul
goto netwait
:netok

timeout /t 4 /nobreak >nul

:loop
if exist "%DIR%\STOP.flag" goto end
rem ALIVE = כמה תהליכי chrome עם חלון גלוי (0 = הקיוסק נעלם/קרס, גם אם נשאר תהליך רפאים)
set "ALIVE=1"
for /f %%i in ('powershell -NoProfile -Command "@(Get-Process chrome -ErrorAction SilentlyContinue ^| Where-Object {$_.MainWindowHandle -ne 0}).Count"') do set "ALIVE=%%i"
if not "%ALIVE%"=="0" goto wait
rem אין חלון קיוסק גלוי — לנקות שאריות ולפתוח מחדש
taskkill /f /im chrome.exe >nul 2>&1
timeout /t 1 /nobreak >nul
if exist "%PROFILE%\Default\Preferences" powershell -NoProfile -Command "$p='%PROFILE%\Default\Preferences'; (Get-Content -Raw $p) -replace '\"exit_type\":\"[^\"]*\"','\"exit_type\":\"Normal\"' -replace '\"exited_cleanly\":false','\"exited_cleanly\":true' | Set-Content -NoNewline $p" >nul 2>&1
if defined CHROME start "" "%CHROME%" %FLAGS% "%URL%"
if not defined CHROME start "" "%URL%"
:wait
timeout /t 12 /nobreak >nul
goto loop

:end
