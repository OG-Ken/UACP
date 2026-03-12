# UACP Bootstrap - One-line remote installer for Windows (PowerShell)
#
# Usage (PowerShell):
#   iwr -useb https://raw.githubusercontent.com/OG-Ken/UACP/main/bootstrap.ps1 | iex
#
# This script:
#   1. Checks prerequisites (git, bash via Git Bash)
#   2. Downloads UACP to a temporary directory
#   3. Copies files to a permanent install location (%LOCALAPPDATA%\uacp)
#   4. Runs install.ps1 to create the PowerShell module
#   5. Verifies the installation
#   6. Cleans up the temporary download
#
# Re-running this script will update UACP to the latest version.

$ErrorActionPreference = "Stop"

$REPO_URL   = "https://github.com/OG-Ken/UACP.git"
$INSTALL_DIR = Join-Path $env:LOCALAPPDATA "uacp"
$TEMP_DIR   = $null

# ----------------------------------------------------------------------------
# Cleanup function — called in finally block
# ----------------------------------------------------------------------------
function Invoke-Cleanup {
    if ($TEMP_DIR -and (Test-Path $TEMP_DIR)) {
        Remove-Item -Path $TEMP_DIR -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host "  [OK] Temporary files cleaned up"
    }
}

try {
    Write-Host "================================="
    Write-Host "  UACP Bootstrap Installer (Windows)"
    Write-Host "================================="
    Write-Host ""

    # --------------------------------------------------------------------------
    # Step 1: Check prerequisites
    # --------------------------------------------------------------------------
    Write-Host "[1/5] Checking prerequisites..."

    $git = Get-Command git -ErrorAction SilentlyContinue
    if (-not $git) {
        Write-Host "  [ERROR] git is required but not found."
        Write-Host "          Install Git (includes Git Bash): https://git-scm.com/downloads"
        exit 1
    }
    Write-Host "  [OK] git found: $($git.Source)"

    $bash = Get-Command bash -ErrorAction SilentlyContinue
    if (-not $bash) {
        Write-Host "  [ERROR] bash (Git Bash) is required but not found."
        Write-Host "          Install Git Bash: https://git-scm.com/downloads"
        Write-Host "          Make sure 'bash' is available in your PATH."
        exit 1
    }
    Write-Host "  [OK] bash found: $($bash.Source)"

    # --------------------------------------------------------------------------
    # Step 2: Download UACP to a temp directory
    # --------------------------------------------------------------------------
    Write-Host ""
    Write-Host "[2/5] Downloading UACP..."

    $TEMP_DIR = Join-Path $env:TEMP "uacp-bootstrap-$(Get-Random)"
    git clone --depth=1 --quiet $REPO_URL "$TEMP_DIR\uacp" 2>&1 | Out-Null
    Write-Host "  [OK] Downloaded to temporary location"

    # Extract version
    $uacpScript = Get-Content "$TEMP_DIR\uacp\uacp" | Where-Object { $_ -match '^UACP_VERSION=' }
    $version = ($uacpScript -replace 'UACP_VERSION="', '') -replace '"', ''
    Write-Host "  [OK] Version: $version"

    # --------------------------------------------------------------------------
    # Step 3: Copy files to permanent install location
    # --------------------------------------------------------------------------
    Write-Host ""
    Write-Host "[3/5] Installing to $INSTALL_DIR..."

    if (-not (Test-Path $INSTALL_DIR)) {
        New-Item -ItemType Directory -Path $INSTALL_DIR -Force | Out-Null
    }

    # Copy core files
    Copy-Item "$TEMP_DIR\uacp\uacp"         "$INSTALL_DIR\uacp"         -Force
    Copy-Item "$TEMP_DIR\uacp\install.sh"   "$INSTALL_DIR\install.sh"   -Force
    Copy-Item "$TEMP_DIR\uacp\uninstall.sh" "$INSTALL_DIR\uninstall.sh" -Force
    Copy-Item "$TEMP_DIR\uacp\install.ps1"  "$INSTALL_DIR\install.ps1"  -Force
    Copy-Item "$TEMP_DIR\uacp\uninstall.ps1" "$INSTALL_DIR\uninstall.ps1" -Force

    # Copy templates (overwrite for updates)
    if (Test-Path "$INSTALL_DIR\templates") {
        Remove-Item "$INSTALL_DIR\templates" -Recurse -Force
    }
    Copy-Item "$TEMP_DIR\uacp\templates" "$INSTALL_DIR\templates" -Recurse -Force

    Write-Host "  [OK] Files installed to $INSTALL_DIR"

    # --------------------------------------------------------------------------
    # Step 4: Run install.ps1 to register the PowerShell module
    # --------------------------------------------------------------------------
    Write-Host ""
    Write-Host "[4/5] Registering 'uacp' PowerShell module..."
    Write-Host ""

    & "$INSTALL_DIR\install.ps1"

    # --------------------------------------------------------------------------
    # Step 5: Verify the installation
    # --------------------------------------------------------------------------
    Write-Host ""
    Write-Host "[5/5] Verifying installation..."

    # Reload modules to pick up the new UACP module
    Import-Module (Join-Path $env:USERPROFILE "Documents\PowerShell\Modules\UACP") -Force -ErrorAction SilentlyContinue

    if (Get-Command uacp -ErrorAction SilentlyContinue) {
        Write-Host "  [OK] 'uacp' command is accessible"
        Write-Host ""
        uacp version
    } else {
        Write-Host "  [WARN] 'uacp' not available yet."
        Write-Host "         Restart PowerShell to use the 'uacp' command."
    }

    # Temp dir cleaned up in finally block

    Write-Host ""
    Write-Host "================================="
    Write-Host "  Bootstrap Complete!"
    Write-Host "================================="
    Write-Host ""
    Write-Host "UACP is installed at: $INSTALL_DIR"
    Write-Host ""
    Write-Host "To update UACP later, re-run this bootstrap command."
    Write-Host "To uninstall: & '$INSTALL_DIR\uninstall.ps1'"
    Write-Host ""

} finally {
    Invoke-Cleanup
}
