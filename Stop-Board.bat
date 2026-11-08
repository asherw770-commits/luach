@echo off
chcp 65001 >nul
rem עצירת הלוח לתחזוקה (השומר יפסיק לפתוח מחדש)
echo stop> "C:\luach\STOP.flag"
timeout /t 1 /nobreak >nul
taskkill /f /im chrome.exe >nul 2>&1
echo הלוח נעצר. לפתיחה מחדש — לחיצה כפולה על Open-Board.
timeout /t 2 /nobreak >nul
