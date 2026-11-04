# SnapDisplay - 1-Click Virtual Second Monitor Activator
# Runs with Administrator privileges to install the Virtual Display Driver (IddCx)

$Host.UI.RawUI.WindowTitle = "SnapDisplay - Virtual Second Monitor Activator"

Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host "             SnapDisplay - Virtual Second Monitor Activator           " -ForegroundColor Cyan
Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host ""

# 1. Check Administrator Privileges and Self-Elevate
$identity = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = New-Object Security.Principal.WindowsPrincipal($identity)
$isAdmin = $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "[1/5] Requesting Administrator permissions (UAC prompt)..." -ForegroundColor Yellow
    try {
        $psi = New-Object System.Diagnostics.ProcessStartInfo
        $psi.FileName = "powershell.exe"
        $psi.Arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
        $psi.Verb = "runas"
        [System.Diagnostics.Process]::Start($psi) | Out-Null
        exit 0
    } catch {
        Write-Host ""
        Write-Host "[ERROR] Administrator permissions were denied." -ForegroundColor Red
        Write-Host "Please right-click enable-second-monitor.bat and choose 'Run as Administrator'." -ForegroundColor Yellow
        Write-Host ""
        Write-Host "Press any key to exit..."
        $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        exit 1
    }
}

Write-Host "[1/5] Administrator privileges confirmed." -ForegroundColor Green
Write-Host ""

# 2. Setup Driver Working Directory
$scriptDir = $PSScriptRoot
$driverDir = Join-Path $scriptDir "driver"
$tempDir = Join-Path $env:TEMP "SnapDisplayVDD"

if (-not (Test-Path (Join-Path $driverDir "nefconc.exe"))) {
    Write-Host "[INFO] Local driver files not found. Fetching package..." -ForegroundColor Cyan
    if (-not (Test-Path $tempDir)) {
        New-Item -ItemType Directory -Path $tempDir -Force | Out-Null
    }
    $zipPath = Join-Path $tempDir "companion.zip"
    $downloadUrl = "https://sajusun.github.io/extensions/snapdisplay/companion/snapdisplay-second-monitor.zip"
    try {
        Write-Host "   Downloading package from GitHub..." -ForegroundColor Gray
        Invoke-WebRequest -Uri $downloadUrl -OutFile $zipPath -UseBasicParsing -TimeoutSec 30
        Write-Host "   Extracting package..." -ForegroundColor Gray
        Expand-Archive -Path $zipPath -DestinationPath $tempDir -Force
        $driverDir = Join-Path $tempDir "driver"
    } catch {
        Write-Host "[ERROR] Could not download driver package: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host "Please ensure your internet connection is active." -ForegroundColor Yellow
        Write-Host "Press any key to exit..."
        $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
        exit 1
    }
}

$nefconExe = Join-Path $driverDir "nefconc.exe"
$infPath = (Resolve-Path (Join-Path $driverDir "MttVDD.inf")).Path
$catPath = (Resolve-Path (Join-Path $driverDir "mttvdd.cat")).Path
$xmlSrc = Join-Path $driverDir "vdd_settings.xml"

# 3. Setup C:\Virtual-Display-Driver\vdd_settings.xml
Write-Host "[2/5] Configuring virtual display properties..." -ForegroundColor Cyan
$targetDir = "C:\Virtual-Display-Driver"
if (-not (Test-Path $targetDir)) {
    New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
}

$xmlTarget = Join-Path $targetDir "vdd_settings.xml"
if (Test-Path $xmlSrc) {
    Copy-Item $xmlSrc $xmlTarget -Force
} else {
    $defaultXml = @"
<?xml version='1.0' encoding='utf-8'?>
<vdd_settings>
    <monitors>
        <count>1</count>
    </monitors>
    <gpu>
        <friendlyname>default</friendlyname>
    </gpu>
    <global>
        <g_refresh_rate>60</g_refresh_rate>
        <g_refresh_rate>90</g_refresh_rate>
        <g_refresh_rate>120</g_refresh_rate>
    </global>
    <resolutions>
        <resolution>
            <width>1920</width>
            <height>1080</height>
            <refresh_rate>60</refresh_rate>
        </resolution>
        <resolution>
            <width>1366</width>
            <height>768</height>
            <refresh_rate>60</refresh_rate>
        </resolution>
        <resolution>
            <width>1280</width>
            <height>720</height>
            <refresh_rate>60</refresh_rate>
        </resolution>
    </resolutions>
    <options>
        <CustomEdid>false</CustomEdid>
        <PreventSpoof>false</PreventSpoof>
        <EdidCeaOverride>false</EdidCeaOverride>
        <HardwareCursor>true</HardwareCursor>
        <SDR10bit>false</SDR10bit>
        <HDRPlus>false</HDRPlus>
        <logging>false</logging>
        <debuglogging>false</debuglogging>
    </options>
</vdd_settings>
"@
    Set-Content -Path $xmlTarget -Value $defaultXml -Encoding UTF8 -Force
}
Write-Host "   Configuration file ready at C:\Virtual-Display-Driver\vdd_settings.xml" -ForegroundColor Green
Write-Host ""

# 4. Register Security Certificates
Write-Host "[3/5] Trusting driver certificates in Windows..." -ForegroundColor Cyan
try {
    $catBytes = [System.IO.File]::ReadAllBytes($catPath)
    $certs = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2Collection
    $certs.Import($catBytes)
    foreach ($cert in $certs) {
        $tmp = Join-Path $env:TEMP "$($cert.Thumbprint).cer"
        [System.IO.File]::WriteAllBytes($tmp, $cert.Export([System.Security.Cryptography.X509Certificates.X509ContentType]::Cert))
        Import-Certificate -FilePath $tmp -CertStoreLocation "Cert:\LocalMachine\TrustedPublisher" -ErrorAction SilentlyContinue | Out-Null
        Import-Certificate -FilePath $tmp -CertStoreLocation "Cert:\LocalMachine\Root" -ErrorAction SilentlyContinue | Out-Null
        Remove-Item $tmp -Force -ErrorAction SilentlyContinue
    }
    Write-Host "   Driver certificates successfully trusted." -ForegroundColor Green
} catch {
    Write-Host "   Warning while importing certificate: $($_.Exception.Message)" -ForegroundColor Yellow
}
Write-Host ""

# 5. Stage & Install Driver into Windows
Write-Host "[4/5] Installing Virtual Display Driver (IddCx)..." -ForegroundColor Cyan

# Stage in Driver Store via pnputil
Write-Host "   Registering package into Windows Driver Store..." -ForegroundColor Gray
$pnpOut = pnputil /add-driver $infPath /install 2>&1 | Out-String
Write-Host "   Package registered." -ForegroundColor Gray

# Check if Root\MttVDD device node already exists
$existingDev = Get-PnpDevice -ErrorAction SilentlyContinue | Where-Object { $_.InstanceId -like "*MttVDD*" -or $_.FriendlyName -like "*Virtual Display*" } | Select-Object -First 1
if ($existingDev) {
    Write-Host "   Device node Root\MttVDD already present. Refreshing device..." -ForegroundColor Gray
    if ($existingDev.Status -ne "OK") {
        Enable-PnpDevice -InstanceId $existingDev.InstanceId -Confirm:$false -ErrorAction SilentlyContinue | Out-Null
    }
} else {
    Write-Host "   Creating virtual device node (Root\MttVDD)..." -ForegroundColor Gray
    $nefconOut = & $nefconExe install $infPath "Root\MttVDD" 2>&1 | Out-String
}

# Wait for Windows DWM and PnP Manager to initialize the display
Write-Host "   Waiting for Windows to initialize display surface..." -ForegroundColor Gray
Start-Sleep -Seconds 3

# 6. Verify Device Status
Write-Host ""
Write-Host "[5/5] Checking display status..." -ForegroundColor Cyan
$dev = Get-PnpDevice -ErrorAction SilentlyContinue | Where-Object { $_.InstanceId -like "*MttVDD*" -or $_.FriendlyName -like "*Virtual Display*" } | Select-Object -First 1

if ($dev -and ($dev.Status -eq "OK" -or $dev.Status -eq "Started")) {
    Write-Host ""
    Write-Host "======================================================================" -ForegroundColor Green
    Write-Host "         [SUCCESS] Virtual Second Monitor is ONLINE and ACTIVE!       " -ForegroundColor Green
    Write-Host "======================================================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Device Name: $($dev.FriendlyName)" -ForegroundColor Green
    Write-Host "Device ID:   $($dev.InstanceId)" -ForegroundColor Green
    Write-Host "Status:      $($dev.Status)" -ForegroundColor Green
} else {
    Write-Host ""
    Write-Host "[NOTE] Driver registered. If Display 2 does not appear immediately," -ForegroundColor Yellow
    Write-Host "       please reboot your PC once to allow Windows kernel to initialize IddCx." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Opening Windows Display Settings..." -ForegroundColor Cyan
Start-Process "ms-settings:display"

Write-Host ""
Write-Host "======================================================================" -ForegroundColor White
Write-Host "Next Steps in SnapDisplay:" -ForegroundColor White
Write-Host "1. In Windows Display Settings, verify you see [ 1 ]  [ 2 ]" -ForegroundColor Gray
Write-Host "2. Make sure Multiple displays is set to 'Extend these displays'" -ForegroundColor Gray
Write-Host "3. Return to SnapDisplay in your browser and click:" -ForegroundColor Gray
Write-Host "   'Stream Extended Display (Screen 2) to Phone'" -ForegroundColor Cyan
Write-Host "======================================================================" -ForegroundColor White
Write-Host ""
Write-Host "Press any key to close this window..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
