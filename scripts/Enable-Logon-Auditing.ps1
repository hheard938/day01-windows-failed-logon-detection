#Requires -RunAsAdministrator
[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'

Write-Host 'Current Logon audit policy:' -ForegroundColor Cyan
auditpol /get /subcategory:"Logon"

Write-Host 'Enabling Success and Failure auditing for Logon...' -ForegroundColor Cyan
auditpol /set /subcategory:"Logon" /success:enable /failure:enable
if ($LASTEXITCODE -ne 0) {
    throw "auditpol failed with exit code $LASTEXITCODE"
}

Write-Host 'Updated Logon audit policy:' -ForegroundColor Green
auditpol /get /subcategory:"Logon"
