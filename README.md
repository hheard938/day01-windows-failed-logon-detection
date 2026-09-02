# Day 1 - Windows Failed-Logon Detection Lab

![Blue Team](https://img.shields.io/badge/Team-Blue-0B5CAD)
![Difficulty](https://img.shields.io/badge/Difficulty-Beginner-2EA44F)
![Platform](https://img.shields.io/badge/Platform-Windows-0078D4)

## Project objective

Build a small SOC investigation workflow that enables Windows logon auditing, generates authorized test activity, exports Security Event ID 4625, identifies suspicious patterns, and documents the result as an incident report.

This project uses only your own Windows computer or Windows virtual machine. Do not test credentials against any system or account you do not own or administer.

## Skills demonstrated

- Windows Security Event Log analysis
- Event ID 4625 triage
- PowerShell collection and XML parsing
- Basic detection engineering with Sigma
- Authentication-failure analysis
- Evidence handling and incident documentation
- Git and GitHub portfolio documentation

## Authorized lab and prerequisites

- Windows 10/11 computer or Windows VM you own
- Local administrator access
- PowerShell 5.1 or newer
- Git and a GitHub account
- A temporary local test account; do not use a work, school, or production account

## Repository contents

```text
day01-windows-failed-logon-detection/
├── README.md
├── LICENSE
├── .gitignore
├── data/
│   └── sample-failed-logons.csv
├── detections/
│   └── windows_failed_logon_4625.yml
├── docs/
│   └── incident-report-template.md
├── evidence/
│   └── .gitkeep
└── scripts/
    ├── Enable-Logon-Auditing.ps1
    ├── Export-FailedLogons.ps1
    └── Test-Export.ps1
```

## Lab steps

### 1. Open an elevated PowerShell terminal

Search for **PowerShell**, choose **Run as administrator**, and move into the repository:

```powershell
Set-Location "$HOME\Documents\GitHub\day01-windows-failed-logon-detection"
```

`Set-Location` changes the terminal's working directory to your local project folder.

### 2. Review the current audit policy

```powershell
auditpol /get /subcategory:"Logon"
```

Record the original Success and Failure settings so you can restore them during cleanup.

### 3. Enable failure auditing

```powershell
Set-ExecutionPolicy -Scope Process Bypass -Force
.\scripts\Enable-Logon-Auditing.ps1
```

The execution-policy change applies only to the current PowerShell process. The script enables Success and Failure auditing for the Logon subcategory.

### 4. Create a temporary local lab account

```powershell
$Password = Read-Host "Enter a temporary strong password" -AsSecureString
New-LocalUser -Name "SOC-Lab-User" -Password $Password -Description "Temporary Day 1 SOC lab account"
```

Use a unique temporary password that is not used anywhere else.

### 5. Generate three controlled failures

Run the following command three times. When prompted, deliberately enter an incorrect password for the temporary account:

```powershell
runas /user:.\SOC-Lab-User cmd.exe
```

Stop after three attempts. If your computer has an account-lockout policy, use fewer attempts than its threshold. Do not perform this step against a domain, work, school, cloud, or third-party account.

### 6. Export recent Event ID 4625 records

```powershell
.\scripts\Export-FailedLogons.ps1 -HoursBack 2 -OutputPath .\data\failed-logons.csv
```

The script reads only Event ID 4625 from the local Security log, parses useful XML fields, and writes them to a CSV file.

### 7. Review the evidence

```powershell
Import-Csv .\data\failed-logons.csv |
    Sort-Object TimeCreated -Descending |
    Format-Table TimeCreated, TargetUserName, IpAddress, LogonType, Status -AutoSize
```

Count failures by username:

```powershell
Import-Csv .\data\failed-logons.csv |
    Group-Object TargetUserName |
    Sort-Object Count -Descending |
    Select-Object Count, Name
```

Count failures by source IP:

```powershell
Import-Csv .\data\failed-logons.csv |
    Where-Object { $_.IpAddress -and $_.IpAddress -notin '-', '127.0.0.1', '::1' } |
    Group-Object IpAddress |
    Sort-Object Count -Descending |
    Select-Object Count, Name
```

Local interactive failures may show `-`, `127.0.0.1`, or `::1` instead of a remote address. That is expected in this lab.

### 8. Validate the export

```powershell
.\scripts\Test-Export.ps1 -CsvPath .\data\failed-logons.csv
```

The test confirms that the file exists, contains the expected columns, and has at least one failed-logon record.

### 9. Document the investigation

Copy `docs/incident-report-template.md` to `docs/incident-report.md` and replace every placeholder. Explain:

- What triggered the investigation
- How many failures occurred
- Which account and source were involved
- Whether the activity was expected lab activity or a real incident
- What containment or hardening action you would recommend

### 10. Add evidence

Place redacted screenshots in `evidence/`. Never publish passwords, email addresses, real public IP addresses, computer serial numbers, internal hostnames, or unrelated usernames.

Suggested names:

```text
evidence/01-audit-policy.png
evidence/02-event-4625.png
evidence/03-csv-results.png
evidence/04-validation-passed.jpg
```

## Expected results

- Windows reports Failure auditing for Logon.
- Event Viewer shows one or more Security events with Event ID 4625.
- `data/failed-logons.csv` contains parsed records.
- The temporary username appears in the export.
- `Test-Export.ps1` returns `[PASS]` messages.
- Your incident report concludes that the observed activity was authorized lab testing.

## Detection logic

The included Sigma rule detects Windows failed-logon events. In a production SIEM, add aggregation such as five or more failures from one account or source in ten minutes. Thresholds must be tuned to the environment to reduce false positives.

## Validation tests

1. Confirm audit policy:

   ```powershell
   auditpol /get /subcategory:"Logon"
   ```

2. Confirm Security log evidence:

   ```powershell
   Get-WinEvent -FilterHashtable @{LogName='Security'; Id=4625; StartTime=(Get-Date).AddHours(-2)} -MaxEvents 5
   ```

3. Confirm your temporary username is present:

   ```powershell
   Import-Csv .\data\failed-logons.csv | Where-Object TargetUserName -eq 'SOC-Lab-User'
   ```

4. Run the automated test:

   ```powershell
   .\scripts\Test-Export.ps1 -CsvPath .\data\failed-logons.csv
   ```

## Cleanup

Remove the temporary account after collecting evidence:

```powershell
Remove-LocalUser -Name "SOC-Lab-User"
```

If Logon failure auditing was disabled before the lab, restore it:

```powershell
auditpol /set /subcategory:"Logon" /failure:disable
```

Delete any unredacted screenshots or exports before pushing to GitHub. Keep only sanitized evidence.

## Publish to GitHub

```powershell
git init
git add .
git commit -m "Complete Day 1 Windows failed-logon detection lab"
git branch -M main
git remote add origin https://github.com/YOUR-USERNAME/day01-windows-failed-logon-detection.git
git push -u origin main
```

Replace `YOUR-USERNAME` with your GitHub username. Create the empty repository on GitHub before the final two commands.

## Resume bullet

> Built a Windows authentication-monitoring lab using PowerShell and Security Event ID 4625; parsed failed-logon telemetry into CSV, validated detection output, authored a Sigma rule, and documented SOC triage findings and remediation steps.

## Interview talking points

- **Why Event ID 4625 matters:** It records failed Windows logon attempts and helps identify brute-force activity, password spraying, stale credentials, and user error.
- **What I analyzed:** Time, account, workstation, source IP, logon type, status, and substatus.
- **How I reduced false positives:** I grouped events by username and source, considered local loopback values, and would tune a threshold to the organization's baseline.
- **How I validated the project:** I generated authorized test events, exported them, confirmed the required fields, and reconciled the CSV with Event Viewer.
- **How I would scale it:** Forward Security logs to a SIEM, apply a time-based threshold, enrich source addresses, map the alert to MITRE ATT&CK, and open a ticket with supporting evidence.

## MITRE ATT&CK context

Repeated authentication failures may be associated with Brute Force (`T1110`). A failed logon alone does not prove malicious behavior; analysts must correlate identity, source, volume, timing, and business context.

## Portfolio completion checklist

- [ ] Audit policy screenshot added and redacted
- [ ] Event ID 4625 screenshot added and redacted
- [ ] Sanitized CSV generated
- [ ] Validation script passed
- [ ] Incident report completed
- [ ] README placeholders reviewed
- [ ] No secrets or sensitive identifiers committed
- [ ] Repository pushed to GitHub

## Disclaimer

This project is for defensive learning on systems you own or are explicitly authorized to administer. It does not authorize testing against third-party systems or accounts.

