# UACP Installation Script for Windows (PowerShell)
# Creates a PowerShell module that wraps the bash script

param(
    [switch]$Help
)

if ($Help) {
    Write-Host "UACP Installation Script for Windows"
    Write-Host ""
    Write-Host "Prerequisites:"
    Write-Host "  - Git Bash must be installed"
    Write-Host "  - bash.exe must be in PATH"
    Write-Host ""
    Write-Host "Usage:"
    Write-Host "  .\install.ps1        Install UACP PowerShell module"
    Write-Host "  .\install.ps1 -Help  Show this help message"
    Write-Host ""
    exit 0
}

Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
Write-Host "  UACP Installation (Windows)"
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
Write-Host ""

# Check for bash
$bashPath = Get-Command bash -ErrorAction SilentlyContinue
if (-not $bashPath) {
    Write-Host "❌ Error: bash not found in PATH"
    Write-Host "   Please install Git Bash: https://git-scm.com/downloads"
    exit 1
}
Write-Host "[1/5] ✓ Found bash at: $($bashPath.Source)"

# Get configuration from bash script
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$installScript = Join-Path $scriptDir "install.sh"

if (-not (Test-Path $installScript)) {
    Write-Host "❌ Error: install.sh not found at $installScript"
    exit 1
}

Write-Host "[2/5] Getting configuration from bash script..."
$configJson = & bash $installScript -powershell
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Error: Failed to get configuration from bash script"
    exit 1
}

$config = $configJson | ConvertFrom-Json
Write-Host "      ✓ Version: $($config.Version)"

# Create PowerShell module directory
$moduleName = "UACP"
$moduleDir = Join-Path $env:USERPROFILE "Documents\PowerShell\Modules\$moduleName"

Write-Host "[3/5] Creating PowerShell module..."
if (-not (Test-Path $moduleDir)) {
    New-Item -ItemType Directory -Path $moduleDir -Force | Out-Null
}
Write-Host "      ✓ Module directory: $moduleDir"

# Create module manifest
$manifestPath = Join-Path $moduleDir "$moduleName.psd1"
$moduleScriptPath = Join-Path $moduleDir "$moduleName.psm1"

Write-Host "[4/5] Creating module files..."

# Create .psm1 (module script)
$moduleContent = @"
# UACP PowerShell Module
# Wraps the bash uacp script for Windows users

`$script:BashScript = "$($config.BashScript -replace '\\', '/')"
`$script:Version = "$($config.Version)"

function Invoke-UACP {
    param(
        [Parameter(ValueFromRemainingArguments=`$true)]
        [string[]]`$Arguments
    )

    # Check if bash is available
    `$bash = Get-Command bash -ErrorAction SilentlyContinue
    if (-not `$bash) {
        Write-Error "bash not found. Please install Git Bash."
        return
    }

    # Convert Windows paths in arguments to Unix paths if needed
    `$unixScript = `$script:BashScript
    if (`$env:OS -eq "Windows_NT") {
        # Convert to Unix path for Git Bash
        `$unixScript = `$unixScript -replace '\\', '/'
        if (`$unixScript -match '^([A-Z]):') {
            `$drive = `$matches[1].ToLower()
            `$unixScript = `$unixScript -replace '^[A-Z]:', "/ `$drive"
        }
    }

    # Execute bash script with arguments
    & bash `$unixScript @Arguments
}

# Export functions
Export-ModuleMember -Function Invoke-UACP

# Create aliases for common usage
Set-Alias -Name uacp -Value Invoke-UACP
Export-ModuleMember -Alias uacp
"@

$moduleContent | Out-File -FilePath $moduleScriptPath -Encoding UTF8
Write-Host "      ✓ Created $moduleName.psm1"

# Create .psd1 (module manifest)
$manifestContent = @"
@{
    RootModule = '$moduleName.psm1'
    ModuleVersion = '$($config.Version)'
    GUID = 'a1b2c3d4-e5f6-7890-abcd-ef1234567890'
    Author = 'OG-Ken'
    Description = 'Unified Agentic Context Protocol - Filesystem-based context management for AI agents'
    PowerShellVersion = '5.1'
    FunctionsToExport = @('Invoke-UACP')
    AliasesToExport = @('uacp')
    PrivateData = @{
        PSData = @{
            ProjectUri = 'https://github.com/OG-Ken/UACP'
            LicenseUri = 'https://github.com/OG-Ken/UACP/blob/main/LICENSE'
        }
    }
}
"@

$manifestContent | Out-File -FilePath $manifestPath -Encoding UTF8
Write-Host "      ✓ Created $moduleName.psd1"

# Verify module
Write-Host "[5/5] Verifying installation..."
Import-Module $moduleDir -Force -ErrorAction SilentlyContinue
if (Get-Command uacp -ErrorAction SilentlyContinue) {
    Write-Host "      ✓ Module imported successfully"
} else {
    Write-Host "      ⚠️  Module created but not yet available"
    Write-Host "      Restart PowerShell to use the 'uacp' command"
}

Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
Write-Host "  ✓ Installation Complete!"
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
Write-Host ""
Write-Host "Module installed at:"
Write-Host "  $moduleDir"
Write-Host ""
Write-Host "Try it out:"
Write-Host "  uacp --version"
Write-Host "  uacp --help"
Write-Host "  uacp init"
Write-Host ""
Write-Host "Note: If 'uacp' command is not found, restart PowerShell."
Write-Host ""
Write-Host "To uninstall:"
Write-Host "  .\uninstall.ps1"
Write-Host ""
