<#
.SYNOPSIS
    This PowerShell script disables insecure guest logons to an SMB server to prevent unauthenticated access.

.NOTES
    Author          : Sadhvi Alam
    LinkedIn        : linkedin.com/in/sadhvi-alam-2643a430/
    GitHub          : github.com/sadhvialam-bit
    Date Created    : 2026-10-09
    Last Modified   : 2026-10-09
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-CC-000040
    Documentation   : https://stigaview.com/products/win11/latest/

.TESTED ON
    Date(s) Tested  : 2026-10-09
    Tested By       : Sadhvi Alam
    Systems Tested  : Windows Azure VM
    PowerShell Ver. : 5.1+

.USAGE
    Execute the script as Administrator to apply the STIG remediation.
    Example syntax:
    PS C:\> .\remediation-STIG-ID-WN11-CC-000040.ps1 
#>

Write-Host "Remediating WN11-CC-000040: Disabling insecure logons to an SMB server..." -ForegroundColor Cyan

$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\LanmanWorkstation"
$name = "AllowInsecureGuestAuth"
$value = 0

If (!(Test-Path $registryPath)) { 
    New-Item -Path $registryPath -Force | Out-Null
}
Set-ItemProperty -Path $registryPath -Name $name -Value $value -Type DWord

Write-Host "Remediation applied successfully. Please restart the VM and rescan." -ForegroundColor Green
