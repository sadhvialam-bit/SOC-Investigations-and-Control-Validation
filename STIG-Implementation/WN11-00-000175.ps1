<#
.SYNOPSIS
    This PowerShell script disables the Secondary Logon service to prevent alternate credential exposure.

.NOTES
    Author          : Sadhvi Alam
    LinkedIn        : linkedin.com/in/sadhvi-alam-2643a430/
    GitHub          : github.com/sadhvialam-bit
    Date Created    : 2026-10-09
    Last Modified   : 2026-10-09
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-00-000175
    Documentation   : https://stigaview.com/products/win11/latest/

.TESTED ON
    Date(s) Tested  : 2026-10-09
    Tested By       : Sadhvi Alam
    Systems Tested  : Windows Azure VM
    PowerShell Ver. : 5.1+

.USAGE
    Execute the script as Administrator to apply the STIG remediation.
    Example syntax:
    PS C:\> .\remediation-STIG-ID-WN11-00-000175.ps1 
#>

Write-Host "Remediating WN11-00-000175: Disabling the Secondary Logon service..." -ForegroundColor Cyan

Stop-Service -Name "seclogon" -Force -ErrorAction SilentlyContinue
Set-Service -Name "seclogon" -StartupType Disabled

Write-Host "Remediation applied successfully. Please restart the VM and rescan." -ForegroundColor Green
