@echo off
chcp 65001 >nul
rem פתיחת הלוח מחדש (אחרי Stop-Board או אם נסגר)
del "C:\luach\STOP.flag" >nul 2>&1
start "" wscript "C:\luach\run-hidden.vbs"
