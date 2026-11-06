@echo off
setlocal EnableDelayedExpansion
title SnapDisplay - Virtual Second Monitor Controller

:: ====================================================================
:: 1. Self-Elevate to Administrator (Single Clean Windows UAC Prompt)
:: ====================================================================
net session >nul 2>&1
if %errorlevel% neq 0 (
    powershell -NoProfile -WindowStyle Hidden -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
    exit /b
)

:: Ensure working directory is set
set "TARGET_DIR=C:\Virtual-Display-Driver"
set "BASE_URL=https://sajusun.github.io/extensions/snapdisplay/companion/driver"
set "SCRIPT_DIR=%~dp0"

:: ====================================================================
:: 2. Check If Virtual Display Device Node is Already Active
:: ====================================================================
set "IS_ACTIVE=0"
pnputil /enum-devices /instanceid "Root\MttVDD" 2>&1 | findstr /i "Root\MttVDD" >nul 2>&1
if %errorlevel% equ 0 (
    set "IS_ACTIVE=1"
)

if "%IS_ACTIVE%"=="1" goto :ACTIVE_MENU
goto :DO_ACTIVATE

:: ====================================================================
:: 3. Interactive Menu When Already Active (Deactivate / Toggle)
:: ====================================================================
:ACTIVE_MENU
cls
echo ======================================================================
echo           SnapDisplay - Virtual Second Monitor Controller
echo ======================================================================
echo.
echo   STATUS: [ ONLINE ] Windows Virtual Second Monitor is currently ACTIVE.
echo.
echo   Choose an option:
echo.
echo     [1] Turn OFF / Deactivate Virtual Display (Restore Single Screen)
echo     [2] Open Windows Display Settings
echo     [3] Re-activate / Refresh Virtual Display
echo     [4] Exit
echo.
echo ======================================================================
set "CHOICE="
set /p "CHOICE=Enter choice (1-4) [Press Enter for 1 to Turn OFF]: "
if "%CHOICE%"=="" set "CHOICE=1"
if "%CHOICE%"=="1" goto :DO_DEACTIVATE
if "%CHOICE%"=="2" goto :DO_SETTINGS
if "%CHOICE%"=="3" goto :DO_ACTIVATE
exit /b

:: ====================================================================
:: 4. Deactivate Virtual Display
:: ====================================================================
:DO_DEACTIVATE
echo.
echo [1/2] Removing Virtual Display Device node (Root\MttVDD)...
if exist "%TARGET_DIR%\nefconc.exe" (
    "%TARGET_DIR%\nefconc.exe" --remove-device-node --hardware-id Root\MttVDD --class-guid {4D36E968-E325-11CE-BFC1-08002BE10318} >nul 2>&1
)
pnputil /remove-device "Root\MttVDD" >nul 2>&1

echo [2/2] Restoring Windows display topology...
timeout /t 1 /nobreak >nul 2>&1

echo.
echo ======================================================================
echo       [SUCCESS] Virtual Second Monitor has been turned OFF!
echo ======================================================================
echo.
echo Windows has returned to your primary single screen.
echo Whenever you want to re-enable Display 2, just run this file again!
echo.
echo Press any key to close this window...
pause >nul
exit /b

:: ====================================================================
:: 5. Open Windows Display Settings
:: ====================================================================
:DO_SETTINGS
start ms-settings:display
exit /b

:: ====================================================================
:: 6. Activate Virtual Display
:: ====================================================================
:DO_ACTIVATE
cls
echo ======================================================================
echo           SnapDisplay - Virtual Second Monitor Activator
echo ======================================================================
echo.

if not exist "%TARGET_DIR%" (
    mkdir "%TARGET_DIR%" >nul 2>&1
)

echo [1/4] Checking driver components...

:: Copy local driver files if present; otherwise download
if exist "%SCRIPT_DIR%driver\nefconc.exe" (
    copy /y "%SCRIPT_DIR%driver\*.*" "%TARGET_DIR%\" >nul 2>&1
)

if not exist "%TARGET_DIR%\nefconc.exe" (
    echo       Downloading driver package from SnapDisplay CDN...
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
echo 1. In Windows Display Settings, you should see [ 1 ]  [ 2 ].
echo 2. Return to SnapDisplay in your browser and click:
echo    "Stream Extended Display (Screen 2) to Phone"
echo.
echo 💡 HOW TO TURN OFF LATER:
echo    - Run this same file anytime to Turn OFF / Deactivate Display 2.
echo    - OR press [T] right now to Turn OFF immediately.
echo ----------------------------------------------------------------------
echo.
choice /c TE /n /m "Press [T] to Turn OFF now, or [E] (or wait 10s) to keep running and exit: " /t 10 /d E
if errorlevel 2 exit /b
if errorlevel 1 goto :DO_DEACTIVATE
