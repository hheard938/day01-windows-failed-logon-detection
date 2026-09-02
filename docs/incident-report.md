Incident Report - Windows Failed Logons
Case details
Case ID: SOC-LAB-2026-001
Analyst: Harold Heard
Date/time opened: 2026-09-01 16:52 ET
Hostname: LAB-WINDOWS-01
Severity: Low
Status: Closed - Authorized Lab Activity
Alert summary
Three failed interactive logon attempts targeting the temporary SOC-Lab-User account were detected between 16:48:51 and 16:52:41 ET. Windows recorded the activity as Security Event ID 4625. The attempts were intentionally generated in an authorized local laboratory to test Windows authentication auditing, evidence collection, and SOC triage procedures.
Evidence reviewed
Windows Security Event ID 4625
data/failed-logons.csv
Windows Logon audit-policy output
Event Viewer screenshot
PowerShell validation output
Sanitized CSV analysis results
Key findings
Target account: SOC-Lab-User
Failure count: 3
First observed: 2026-09-01 16:48:51 ET
Last observed: 2026-09-01 16:52:41 ET
Source IP/workstation: LOCAL / LAB-WINDOWS-01
Logon type: 2 - Interactive
Status: 0xC000006D
Failure reason: Incorrect username or password
Analysis
The three failures occurred against one temporary local account during a short, documented testing window. The consistent target account, local source, interactive Logon Type 2, and known testing activity support the conclusion that these events were authorized laboratory activity.
In a production environment, repeated authentication failures could indicate typing errors, stale credentials, brute-force activity, or password spraying. An analyst would correlate the events with the source address, affected account, successful logons, endpoint telemetry, and approved change or testing records before determining severity.
No evidence of unauthorized access, account compromise, persistence, or successful authentication was identified.
Containment and recommendations
No containment was required because the activity was authorized and limited to an owned local lab system.
Recommended production actions would include:
Confirming the activity with the affected user or system owner.
Reviewing nearby successful-logon events.
Monitoring for additional failures from the same source.
Escalating repeated failures that exceed the organization’s alert threshold.
Resetting credentials or temporarily disabling the account if compromise is suspected.
Blocking the source address when malicious activity is confirmed.
Forwarding Windows Security logs to a SIEM for centralized detection and correlation.
Final disposition
Closed - Authorized lab activity. The failed logons were intentionally generated on an owned Windows lab system to validate Security Event ID 4625 collection, PowerShell analysis, evidence preservation, and SOC incident-triage procedures.
Lessons learned
This project demonstrated how Windows records failed authentication activity and how Event ID 4625 fields support an investigation. I learned to distinguish a controlled test from potentially malicious behavior by examining the target account, timestamps, logon type, status code, source, and authorization context.
In a production SOC workflow, I would improve this process by forwarding events to a SIEM, establishing alert thresholds, correlating failures with successful logons, mapping detections to MITRE ATT&CK, and documenting escalation procedures.
