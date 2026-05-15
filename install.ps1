# gt installer for Windows
# Usage: iwr https://raw.githubusercontent.com/procloudify/gt/main/install.ps1 | iex

$ErrorActionPreference = "Stop"

$REPO    = "https://raw.githubusercontent.com/procloudify/gt/main"
$BIN     = "gt"
$INSTALL = "$env:USERPROFILE\.gt\bin"

function Write-Ok($msg)   { Write-Host "  + $msg" -ForegroundColor Green }
function Write-Info($msg) { Write-Host "  > $msg" -ForegroundColor Cyan }
function Write-Warn($msg) { Write-Host "  ! $msg" -ForegroundColor Yellow }
function Write-Fail($msg) { Write-Host "  x $msg" -ForegroundColor Red; exit 1 }

Write-Host ""
Write-Host "   ██████╗ ████████╗" -ForegroundColor Cyan
Write-Host "  ██╔════╝╚══██╔══╝ " -ForegroundColor Cyan
Write-Host "  ██║  ███╗  ██║    " -ForegroundColor Cyan
Write-Host "  ██║   ██║  ██║    " -ForegroundColor Cyan
Write-Host "  ╚██████╔╝  ██║    " -ForegroundColor Cyan
Write-Host "   ╚═════╝   ╚═╝    " -ForegroundColor Cyan
Write-Host ""
Write-Host "  gt -- simple git flow CLI" -ForegroundColor White
Write-Host "  Built by Pro Cloudify - github.com/procloudify/gt" -ForegroundColor DarkGray
Write-Host "  Open source - MIT License - Contributions welcome" -ForegroundColor DarkGray
Write-Host ""

# Detect if this is a fresh install or an update
$isUpdate = Test-Path "$INSTALL\gt"
if ($isUpdate) {
    Write-Info "Existing install found -- checking for updates..."
} else {
    Write-Info "Installing to $INSTALL"
}

# Fetch remote script
try {
    $remoteScript = Invoke-WebRequest -Uri "$REPO/bin/gt" -UseBasicParsing
    $remoteVer = ($remoteScript.Content -split "`n" | Where-Object { $_ -match '^GT_VERSION=' } | Select-Object -First 1) -replace 'GT_VERSION=|"',''
} catch {
    Write-Fail "Could not reach github.com/procloudify/gt. Check your internet connection."
}

# If updating, compare versions and bail early if already current
if ($isUpdate) {
    $currentVer = (Get-Content "$INSTALL\gt" -ErrorAction SilentlyContinue | Where-Object { $_ -match '^GT_VERSION=' } | Select-Object -First 1) -replace 'GT_VERSION=|"',''
    if ($currentVer -eq $remoteVer -and $currentVer -ne "") {
        Write-Ok "Already up to date -- v$currentVer"
        Write-Host ""
        exit 0
    }
    Write-Info "Updating: v$currentVer -> v$remoteVer"
} else {
    Write-Info "Installing v$remoteVer"
}

# Create install dir
if (-not (Test-Path $INSTALL)) {
    New-Item -ItemType Directory -Path $INSTALL -Force | Out-Null
}

# Write gt script to disk
try {
    [System.IO.File]::WriteAllText("$INSTALL\gt", $remoteScript.Content)
} catch {
    Write-Fail "Failed to write gt: $_"
}

# Create gt.cmd shim (for CMD)
$cmdShim = @"
@echo off
where bash >nul 2>&1
if %errorlevel% equ 0 (
    bash "%~dp0gt" %*
) else (
    where wsl >nul 2>&1
    if %errorlevel% equ 0 (
        wsl bash "%~dp0gt" %*
    ) else (
        echo gt requires Git Bash or WSL. Install Git for Windows: https://git-scm.com
        exit /b 1
    )
)
"@
$cmdShim | Out-File -FilePath "$INSTALL\gt.cmd" -Encoding ascii

# Create gt.ps1 shim (for PowerShell -- ps1 is preferred over .cmd in PS)
$ps1Shim = @'
$bash = (Get-Command bash -ErrorAction SilentlyContinue)?.Source
if (-not $bash) {
    $bash = (Get-Command wsl -ErrorAction SilentlyContinue)?.Source
    if (-not $bash) {
        Write-Error "gt requires Git Bash or WSL. Install Git for Windows: https://git-scm.com"
        exit 1
    }
    & wsl bash "$PSScriptRoot/gt" @args
} else {
    & bash "$PSScriptRoot/gt" @args
}
'@
$ps1Shim | Out-File -FilePath "$INSTALL\gt.ps1" -Encoding utf8

Write-Ok "gt v$remoteVer ready"

# Add to user PATH (persists across terminals)
$userPath = [Environment]::GetEnvironmentVariable("PATH", "User")
if ($userPath -notlike "*$INSTALL*") {
    [Environment]::SetEnvironmentVariable("PATH", "$INSTALL;$userPath", "User")
    Write-Ok "Added $INSTALL to your PATH"
}

Write-Host ""
if ($isUpdate) {
    Write-Ok "gt updated to v$remoteVer!"
} else {
    Write-Ok "gt installed successfully!"
    Write-Host ""
    Write-Host "  Get started:" -ForegroundColor White
    Write-Host "  gt help          show all commands" -ForegroundColor Cyan
    Write-Host "  gt init          init a project" -ForegroundColor Cyan
    Write-Host "  gt push          bump version + push main" -ForegroundColor Cyan
}
Write-Host ""
Write-Host "  NOTE: Restart your terminal (or run the line below) to use gt:" -ForegroundColor Yellow
Write-Host "  `$env:PATH = `"$INSTALL;`$env:PATH`"" -ForegroundColor DarkGray
Write-Host ""
Write-Host "  To uninstall: gt uninstall" -ForegroundColor DarkGray
Write-Host ""
