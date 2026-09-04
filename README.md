# Day 1 – Windows Failed-Logon Detection Lab
![Difficulty](https://img.shields.io/badge/Difficulty-Beginner-green)
![Platform](https://img.shields.io/badge/Platform-Windows-blue)
![Event ID](https://img.shields.io/badge/Event_ID-4625-red)
![MITRE ATT&CK](https://img.shields.io/badge/MITRE-T1110-purple)
## Project Overview
This project demonstrates a small Security Operations Center (SOC) investigation workflow for detecting and analyzing failed Windows authentication attempts.
I configured Windows logon auditing, generated controlled failed-logon activity in an authorized lab environment, collected Security Event ID 4625 records with PowerShell, reviewed the results for suspicious patterns, and documented the investigation.
## Skills Demonstrated
- Windows Security Event Log analysis
- Security Event ID 4625 investigation
- PowerShell log collection and filtering
- CSV and XML data analysis
- Detection-rule development
- Incident documentation
- MITRE ATT&CK mapping
- Evidence collection and validation
## Investigation Workflow
1. Enabled Windows failure-auditing policies.
2. Generated authorized failed-logon activity in a controlled lab.
3. Collected Event ID 4625 records from the Windows Security log.
4. Exported the results for analysis.
5. Reviewed usernames, timestamps, source addresses, logon types, and failure reasons.
6. Created a detection rule for repeated authentication failures.
7. Documented the findings in an incident report.
8. Preserved screenshots as evidence of the completed investigation.
## Detection Logic
The detection identifies repeated Windows failed-logon events associated with Security Event ID 4625. Multiple failures involving the same account or source within a short period may indicate password guessing, brute-force activity, a misconfigured service, or an outdated stored credential.
Detection rule: [`detections/windows_failed_logon_4625.yml`](detections/windows_failed_logon_4625.yml)
## Results
The lab successfully produced and captured Windows failed-logon records. The exported data contained the fields needed for basic SOC triage, including timestamps, usernames, source information, logon types, and failure details.
The activity was expected because it was generated in an authorized test environment. In a production environment, the same pattern would require validation against account ownership, source-system history, asset criticality, and other authentication activity.
## MITRE ATT&CK Mapping
- **Related Technique:** Brute Force
- **Technique ID:** T1110
- **Tactic:** Credential Access
- **Detection Context:** Windows Security Event ID 4625 records failed authentication attempts. Repeated failures may be consistent with brute-force or password-guessing activity, but failed logons alone do not establish malicious activity. This lab used authorized test failures to demonstrate how an analysis identify and investigate this pattern.
## Evidence
- [Audit policy configuration](evidence/01-audit-policy.png)
- [Windows Event ID 4625](evidence/02-event-4625.png)
- [Exported CSV results](evidence/03-csv-results.png)
- [Validation results](evidence/04-validation-passed.jpg)
## Documentation
- [Completed incident report](docs/incident-report.md)
- [Sanitized failed-logon data](data/failed-logons.csv)
- [Sample dataset](data/sample-failed-logons.csv)
## PowerShell Automation
The `scripts` directory contains the PowerShell scripts used to configure auditing, collect failed-logon events, and validate the exported results.
## Security and Privacy
This project was completed only in an authorized lab environment. The published evidence and datasets contain no real passwords, email addresses, public IP addresses, or sensitive personal information.
## Key Takeaway
This lab demonstrates an end-to-end entry-level SOC workflow: generate authorized test activity, collect security telemetry, apply detection logic, analyze the results, document findings, and recommend further investigation when appropriate.
has context menu
