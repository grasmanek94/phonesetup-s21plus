@echo off
title SECURE

:begin

adb shell settings list secure > secure_before.txt
cls
git  --no-pager diff secure_before.txt
timeout /t 5 > nul


goto begin