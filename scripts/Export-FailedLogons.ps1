#Requires -RunAsAdministrator
[CmdletBinding()]
param(
    [ValidateRange(1, 168)]
    [int]$HoursBack = 24,

    [string]$OutputPath = ".\data\failed-logons.csv"
)

$ErrorActionPreference = 'Stop'
$startTime = (Get-Date).AddHours(-$HoursBack)
$outputParent = Split-Path -Parent $OutputPath

if ($outputParent -and -not (Test-Path $outputParent)) {
    New-Item -ItemType Directory -Path $outputParent -Force | Out-Null
}

$events = Get-WinEvent -FilterHashtable @{
    LogName   = 'Security'
    Id        = 4625
    StartTime = $startTime
} -ErrorAction SilentlyContinue

if (-not $events) {
    Write-Warning "No Event ID 4625 records found since $startTime. Generate authorized test failures and run the script again."
    @() | Export-Csv -Path $OutputPath -NoTypeInformation
    return
}

$records = foreach ($event in $events) {
    $xml = [xml]$event.ToXml()
    $fields = @{}
    foreach ($item in $xml.Event.EventData.Data) {
        $fields[$item.Name] = [string]$item.'#text'
    }

    [pscustomobject]@{
        TimeCreated       = $event.TimeCreated.ToString('o')
        EventId           = $event.Id
        Computer          = $event.MachineName
        TargetUserName    = $fields['TargetUserName']
        TargetDomainName  = $fields['TargetDomainName']
        WorkstationName   = $fields['WorkstationName']
        IpAddress         = $fields['IpAddress']
        IpPort            = $fields['IpPort']
        LogonType         = $fields['LogonType']
        Status            = $fields['Status']
        SubStatus         = $fields['SubStatus']
        FailureReason     = $fields['FailureReason']
        ProcessName       = $fields['ProcessName']
        AuthenticationPkg = $fields['AuthenticationPackageName']
    }
}

$records | Sort-Object TimeCreated -Descending | Export-Csv -Path $OutputPath -NoTypeInformation
Write-Host "Exported $($records.Count) failed-logon record(s) to $OutputPath" -ForegroundColor Green
