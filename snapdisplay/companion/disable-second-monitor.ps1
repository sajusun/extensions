# SnapDisplay - Virtual Second Monitor Remover
$Host.UI.RawUI.WindowTitle = "SnapDisplay - Remove Virtual Second Monitor"

$identity = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = New-Object Security.Principal.WindowsPrincipal($identity)
$isAdmin = $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    try {
        $psi = New-Object System.Diagnostics.ProcessStartInfo
        $psi.FileName = "powershell.exe"
        $psi.Arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
        $psi.Verb = "runas"
        [System.Diagnostics.Process]::Start($psi) | Out-Null
        exit 0
    } catch {
        Write-Host "Administrator privileges required to remove driver." -ForegroundColor Red
        pause
        exit 1
    }
}

Write-Host "Removing Virtual Display Device node..." -ForegroundColor Cyan
$scriptDir = $PSScriptRoot
$driverDir = Join-Path $scriptDir "driver"
$nefconExe = Join-Path $driverDir "nefconc.exe"

if (-not (Test-Path $nefconExe)) {
    $nefconExe = Join-Path $env:TEMP "SnapDisplayVDD\driver\nefconc.exe"
}

if (Test-Path $nefconExe) {
    & $nefconExe --remove-device-node --hardware-id "Root\MttVDD" --class-guid "{4D36E968-E325-11CE-BFC1-08002BE10318}" | Out-Null
} else {
    $dev = Get-PnpDevice -HardwareID "Root\MttVDD" -ErrorAction SilentlyContinue
    if ($dev) {
        Disable-PnpDevice -InstanceId $dev.InstanceId -Confirm:$false -ErrorAction SilentlyContinue | Out-Null
    }
}

Write-Host ""
Write-Host "======================================================================" -ForegroundColor Green
Write-Host " [SUCCESS] Virtual Second Monitor has been removed from Windows!     " -ForegroundColor Green
Write-Host "======================================================================" -ForegroundColor Green
Write-Host ""
Write-Host "Press any key to close this window..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
