@echo off
setlocal
cd /d "%~dp0"
title SnapDisplay - Remove Virtual Second Monitor
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0disable-second-monitor.ps1"
