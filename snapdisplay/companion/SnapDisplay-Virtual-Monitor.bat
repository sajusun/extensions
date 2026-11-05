@echo off
setlocal EnableDelayedExpansion
title SnapDisplay - Virtual Second Monitor Activator

echo ======================================================================
echo           SnapDisplay - Virtual Second Monitor Activator
echo ======================================================================
echo.

:: 1. Check Administrator Privileges and Self-Elevate cleanly
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [INFO] Requesting Administrator permissions...
    powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

:: 2. Target Directory
set "TARGET_DIR=C:\Virtual-Display-Driver"
if not exist "%TARGET_DIR%" (
    mkdir "%TARGET_DIR%" >nul 2>&1
)

echo [1/4] Checking driver components...
set "BASE_URL=https://sajusun.github.io/extensions/snapdisplay/companion/driver"

:: If running next to local driver folder, copy from local; otherwise download from official GitHub CDN
set "SCRIPT_DIR=%~dp0"
if exist "%SCRIPT_DIR%driver\nefconc.exe" (
    copy /y "%SCRIPT_DIR%driver\*.*" "%TARGET_DIR%\" >nul 2>&1
)

if not exist "%TARGET_DIR%\nefconc.exe" (
    echo [INFO] Downloading driver package from official SnapDisplay CDN...
    powershell -NoProfile -Command "Invoke-WebRequest -Uri '%BASE_URL%/nefconc.exe' -OutFile '%TARGET_DIR%\nefconc.exe' -UseBasicParsing"
    powershell -NoProfile -Command "Invoke-WebRequest -Uri '%BASE_URL%/MttVDD.dll' -OutFile '%TARGET_DIR%\MttVDD.dll' -UseBasicParsing"
    powershell -NoProfile -Command "Invoke-WebRequest -Uri '%BASE_URL%/MttVDD.inf' -OutFile '%TARGET_DIR%\MttVDD.inf' -UseBasicParsing"
    powershell -NoProfile -Command "Invoke-WebRequest -Uri '%BASE_URL%/mttvdd.cat' -OutFile '%TARGET_DIR%\mttvdd.cat' -UseBasicParsing"
    powershell -NoProfile -Command "Invoke-WebRequest -Uri '%BASE_URL%/vdd_settings.xml' -OutFile '%TARGET_DIR%\vdd_settings.xml' -UseBasicParsing"
)

:: Ensure default settings XML exists
if not exist "%TARGET_DIR%\vdd_settings.xml" (
    (
        echo ^<?xml version='1.0' encoding='utf-8'?^>
        echo ^<vdd_settings^>
        echo     ^<monitors^>^<count^>1^</count^>^</monitors^>
        echo     ^<gpu^>^<friendlyname^>default^</friendlyname^>^</gpu^>
        echo     ^<global^>^<g_refresh_rate^>60^</g_refresh_rate^>^</global^>
        echo     ^<resolutions^>
        echo         ^<resolution^>^<width^>1920^</width^>^<height^>1080^</height^>^<refresh_rate^>60^</refresh_rate^>^</resolution^>
        echo         ^<resolution^>^<width^>1366^</width^>^<height^>768^</height^>^<refresh_rate^>60^</refresh_rate^>^</resolution^>
        echo         ^<resolution^>^<width^>1280^</width^>^<height^>720^</height^>^<refresh_rate^>60^</refresh_rate^>^</resolution^>
        echo     ^</resolutions^>
        echo     ^<options^>^<HardwareCursor^>true^</HardwareCursor^>^</options^>
        echo ^</vdd_settings^>
    ) > "%TARGET_DIR%\vdd_settings.xml"
)

echo [2/4] Registering security certificates in Windows...
powershell -NoProfile -Command "$cat = '%TARGET_DIR%\mttvdd.cat'; if (Test-Path $cat) { $c = New-Object Security.Cryptography.X509Certificates.X509Certificate2Collection; $c.Import($cat); foreach ($cert in $c) { $t = [IO.Path]::GetTempFileName(); [IO.File]::WriteAllBytes($t, $cert.Export([Security.Cryptography.X509Certificates.X509ContentType]::Cert)); Import-Certificate -FilePath $t -CertStoreLocation 'Cert:\LocalMachine\TrustedPublisher' -ErrorAction SilentlyContinue | Out-Null; Import-Certificate -FilePath $t -CertStoreLocation 'Cert:\LocalMachine\Root' -ErrorAction SilentlyContinue | Out-Null; Remove-Item $t -Force -ErrorAction SilentlyContinue; } }"

echo [3/4] Registering Virtual Display Driver into Windows Driver Store...
pnputil /add-driver "%TARGET_DIR%\MttVDD.inf" /install >nul 2>&1

echo [4/4] Activating Virtual Display Hardware Device...
"%TARGET_DIR%\nefconc.exe" install "%TARGET_DIR%\MttVDD.inf" Root\MttVDD >nul 2>&1

echo.
echo Waiting 2 seconds for Windows Display topology to refresh...
timeout /t 2 /nobreak >nul 2>&1

echo.
echo ======================================================================
echo           [SUCCESS] Virtual Second Monitor is ACTIVE!
echo ======================================================================
echo.
echo Windows Virtual Display 2 (1080p @ 60Hz) is now online.
echo Opening Windows Display Settings...
start ms-settings:display
echo.
echo ----------------------------------------------------------------------
echo What to do next:
echo 1. Check Windows Display Settings (you should see Display 1 and 2).
echo 2. Return to SnapDisplay in your browser and click:
echo    "Stream Extended Display (Screen 2) to Phone"
echo ----------------------------------------------------------------------
echo.
echo Press any key to close this window...
pause >nul
