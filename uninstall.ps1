# UACP Uninstallation Script for Windows (PowerShell)
# Removes the PowerShell module

param(
    [switch]$Help
)

if ($Help) {
    Write-Host "UACP Uninstallation Script for Windows"
    Write-Host ""
    Write-Host "Usage:"
    Write-Host "  .\uninstall.ps1        Uninstall UACP PowerShell module"
    Write-Host "  .\uninstall.ps1 -Help  Show this help message"
    Write-Host ""
    exit 0
}

Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
Write-Host "  UACP Uninstallation (Windows)"
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
Write-Host ""

# Module directory
$moduleName = "UACP"
$moduleDir = Join-Path $env:USERPROFILE "Documents\PowerShell\Modules\$moduleName"

# Check if module exists
if (-not (Test-Path $moduleDir)) {
    Write-Host "✓ UACP module is not installed"
    Write-Host "  Looked in: $moduleDir"
    exit 0
}

# Show what will be removed
Write-Host "The following module will be removed:"
Write-Host "  $moduleDir"
Write-Host ""

# Confirm
$response = Read-Host "Continue with uninstallation? (y/n)"
if ($response -ne 'y' -and $response -ne 'Y') {
    Write-Host "Uninstallation cancelled."
    exit 0
}

# Remove module from current session if loaded
Write-Host ""
Write-Host "Removing module from current session..."
Remove-Module $moduleName -Force -ErrorAction SilentlyContinue
Write-Host "✓ Removed from session"

# Remove module directory
Write-Host "Removing module files..."
Remove-Item -Path $moduleDir -Recurse -Force
Write-Host "✓ Removed module directory"

Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
Write-Host "  ✓ Uninstallation Complete!"
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
Write-Host ""
Write-Host "The UACP PowerShell module has been removed."
Write-Host ""
Write-Host "Note: The source files in this directory were NOT removed."
Write-Host "      Only the PowerShell module was deleted."
Write-Host ""
Write-Host "To reinstall:"
Write-Host "  .\install.ps1"
Write-Host ""
