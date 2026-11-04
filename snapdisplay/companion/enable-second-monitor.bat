@echo off
setlocal
cd /d "%~dp0"
title SnapDisplay - Virtual Second Monitor Activator
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Start-Process powershell.exe -ArgumentList '-NoProfile -ExecutionPolicy Bypass -File \"\"%~dp0enable-second-monitor.ps1\"\"' -Verb RunAs"
