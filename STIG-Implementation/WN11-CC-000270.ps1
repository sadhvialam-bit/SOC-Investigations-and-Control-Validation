<#
.SYNOPSIS
    This PowerShell script prevents passwords from being saved in the Remote Desktop Client to protect credentials.

.NOTES
    Author          : Sadhvi Alam
    LinkedIn        : linkedin.com/in/sadhvi-alam-2643a430/
    GitHub          : github.com/sadhvialam-bit
    Date Created    : 2026-10-09
    Last Modified   : 2026-10-09
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-CC-000270
    Documentation   : https://stigaview.com/products/win11/latest/

.TESTED ON
    Date(s) Tested  : 2026-10-09
    Tested By       : Sadhvi Alam
    Systems Tested  : Windows Azure VM
    PowerShell Ver. : 5.1+

.USAGE
    Execute the script as Administrator to apply the STIG remediation.
    Example syntax:
    PS C:\> .\remediation-STIG-ID-WN11-CC-000270.ps1 
#>

Write-Host "Remediating WN11-CC-000270: Preventing passwords from being saved in the Remote Desktop Client..." -ForegroundColor Cyan

$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services"
$name = "DisablePasswordSaving"
$value = 1

If (!(Test-Path $registryPath)) { 
    New-Item -Path $registryPath -Force | Out-Null
}
Set-ItemProperty -Path $registryPath -Name $name -Value $value -Type DWord

Write-Host "Remediation applied successfully. Please restart the VM and rescan." -ForegroundColor Green
