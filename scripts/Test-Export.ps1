[CmdletBinding()]
param(
    [string]$CsvPath = ".\data\failed-logons.csv"
)

$ErrorActionPreference = 'Stop'
$requiredColumns = @('TimeCreated', 'EventId', 'Computer', 'TargetUserName', 'IpAddress', 'LogonType', 'Status')

if (-not (Test-Path $CsvPath)) {
    throw "[FAIL] CSV not found: $CsvPath"
}

$rows = @(Import-Csv $CsvPath)
if ($rows.Count -lt 1) {
    throw '[FAIL] CSV contains no failed-logon records.'
}

$columns = @($rows[0].PSObject.Properties.Name)
$missing = @($requiredColumns | Where-Object { $_ -notin $columns })
if ($missing.Count -gt 0) {
    throw "[FAIL] Missing required columns: $($missing -join ', ')"
}

$non4625 = @($rows | Where-Object { $_.EventId -ne '4625' })
if ($non4625.Count -gt 0) {
    throw "[FAIL] Found $($non4625.Count) record(s) that are not Event ID 4625."
}

Write-Host "[PASS] CSV exists and contains $($rows.Count) Event ID 4625 record(s)." -ForegroundColor Green
Write-Host '[PASS] Required SOC triage columns are present.' -ForegroundColor Green
