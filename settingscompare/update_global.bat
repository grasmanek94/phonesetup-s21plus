@echo off
title GLOBAL

:begin

adb shell settings list global > global_before.txt 
cls
git --no-pager diff global_before.txt

timeout /t 1 > nul
goto begin