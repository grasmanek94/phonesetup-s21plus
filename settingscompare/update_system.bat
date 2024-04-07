@echo off
title SYSTEM

:begin

adb shell settings list system > system_before.txt 
cls
git --no-pager diff system_before.txt

timeout /t 5 > nul
goto begin