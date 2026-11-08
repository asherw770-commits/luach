@echo off
chcp 65001 >nul
rem ===== לוח הקומה — קיוסק מסך מלא ב-Chrome =====
rem הקישור הקבוע (מתעדכן אוטומטית מהאינטרנט):
set "URL=https://asherw770-commits.github.io/luach/"
set "PROFILE=C:\luach\chrome-profile"
set "FLAGS=--kiosk --start-fullscreen --user-data-dir=%PROFILE% --no-first-run --no-default-browser-check --disable-infobars --disable-session-crashed-bubble --disable-features=TranslateUI --autoplay-policy=no-user-gesture-required --overscroll-history-navigation=0 --noerrdialogs --disable-pinch --check-for-update-interval=604800"
set "C1=C:\Program Files\Google\Chrome\Application\chrome.exe"
set "C2=C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"
set "EDGE=C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"

rem המתנה קצרה שהרשת תתחבר אחרי ההדלקה
timeout /t 6 /nobreak >nul

if exist "%C1%" ( start "" "%C1%" %FLAGS% "%URL%"
) else if exist "%C2%" ( start "" "%C2%" %FLAGS% "%URL%"
) else if exist "%EDGE%" ( start "" "%EDGE%" --kiosk "%URL%" --edge-kiosk-type=fullscreen --no-first-run
) else ( start "" "%URL%" )
