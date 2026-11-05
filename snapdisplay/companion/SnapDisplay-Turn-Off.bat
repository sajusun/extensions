@echo off
setlocal EnableDelayedExpansion
title SnapDisplay - Turn Off Virtual Second Monitor

echo ======================================================================
echo         SnapDisplay - Turn Off Virtual Second Monitor
echo ======================================================================
echo.

net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [INFO] Requesting Administrator permissions...
    powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

set "TARGET_DIR=C:\Virtual-Display-Driver"
set "NEFCON_EXE=%TARGET_DIR%\nefconc.exe"

if exist "%NEFCON_EXE%" (
    echo Removing Virtual Display Device node (Root\MttVDD)...
    "%NEFCON_EXE%" --remove-device-node --hardware-id Root\MttVDD --class-guid {4D36E968-E325-11CE-BFC1-08002BE10318} >nul 2>&1
) else (
    echo Disabling device via pnputil...
    pnputil /remove-device "Root\MttVDD" >nul 2>&1
)

echo.
echo ======================================================================
echo       [SUCCESS] Virtual Second Monitor has been turned OFF!
echo ======================================================================
echo.
echo Windows has reverted to your primary screen.
echo.
echo Press any key to close this window...
pause >nul
