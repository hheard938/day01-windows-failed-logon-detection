# Incident Report - Windows Failed Logons

## Case details

- **Case ID:** SOC-LAB-2026-001
- **Analyst:** Harold Heard
- **Date/time opened:** [YYYY-MM-DD HH:MM TZ]
- **Hostname:** [REDACTED OR LAB HOSTNAME]
- **Severity:** Informational / Low / Medium / High
- **Status:** Closed - Authorized Lab Activity

## Alert summary

[Summarize what was detected, including the number of Event ID 4625 records and the time window.]

## Evidence reviewed

- Windows Security Event ID 4625
- `data/failed-logons.csv`
- Audit-policy output
- Event Viewer screenshot
- PowerShell validation output

## Key findings

- **Target account:** [USERNAME]
- **Failure count:** [COUNT]
- **First observed:** [TIMESTAMP]
- **Last observed:** [TIMESTAMP]
- **Source IP/workstation:** [VALUE OR LOCAL]
- **Logon type:** [VALUE]
- **Status/substatus:** [VALUES]
- **Failure reason:** [VALUE]

## Analysis

[Explain whether the pattern resembles user error, a stale credential, password spraying, brute force, or authorized lab activity. Cite the evidence supporting the conclusion.]

## Containment and recommendations

[List appropriate actions such as confirming the user, resetting credentials, disabling an account, blocking a source, tuning an alert, or continuing monitoring. For this lab, state that no containment was required because the activity was authorized.]

## Final disposition

**Closed - Authorized lab activity.** The failed logons were intentionally generated on an owned Windows lab system to validate Security Event ID 4625 collection and analysis.

## Lessons learned

[Describe what you learned and what you would improve in a production SOC workflow.]

