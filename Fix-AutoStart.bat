@echo off
chcp 65001 >nul
title לוח הקומה — תיקון הפעלה אוטומטית
net session >nul 2>&1 || (echo. & echo   ** צריך להריץ כמנהל ** & echo   קליק ימני על הקובץ ובחר "הפעל כמנהל" & echo. & pause & exit /b)
set "STARTUP=C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp"
echo.
echo   ====== תיקון הפעלה אוטומטית ======
echo.
echo   משחרר חסימת אבטחה (MOTW) מקבצי הלוח...
powershell -NoProfile -Command "Get-ChildItem -Path 'C:\luach' -Recurse -File -ErrorAction SilentlyContinue | Unblock-File; Unblock-File -Path '%STARTUP%\luach-board.vbs','C:\Users\Public\Desktop\Open-Board.bat','C:\Users\Public\Desktop\Stop-Board.bat' -ErrorAction SilentlyContinue" >nul 2>&1
echo   בוצע.
echo.
echo   כבה והדלק את המחשב — הלוח ייפתח לבד, בלי חלון האזהרה.
echo.
pause
