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

timeout /t 6 /nobreak >nul

:loop
if exist "%DIR%\STOP.flag" goto end
tasklist /fi "imagename eq chrome.exe" 2>nul | find /i "chrome.exe" >nul && goto wait
if exist "%PROFILE%\Default\Preferences" powershell -NoProfile -Command "$p='%PROFILE%\Default\Preferences'; (Get-Content -Raw $p) -replace '\"exit_type\":\"[^\"]*\"','\"exit_type\":\"Normal\"' -replace '\"exited_cleanly\":false','\"exited_cleanly\":true' | Set-Content -NoNewline $p" >nul 2>&1
if defined CHROME start "" "%CHROME%" %FLAGS% "%URL%"
if not defined CHROME start "" "%URL%"
:wait
timeout /t 8 /nobreak >nul
goto loop

:end
