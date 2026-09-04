# Incident Report – Windows Failed Logons
## Case Details
- **Case ID:** SOC-LAB-2026-001
- **Analyst:** Harold Heard
- **Date/time opened:** September 1, 2026, 4:52 PM ET
- **Hostname:** LAB-WINDOWS-01
- **Severity:** Low
- **Status:** Closed – Authorized Lab Activity
## Alert Summary
Three failed interactive logon attempts targeting the temporary `SOC-Lab-User` account were detected between 4:48:51 PM and 4:52:41 PM ET.
Windows recorded the activity as Security Event ID 4625. The attempts were intentionally generated in an authorized local laboratory to test Windows authentication auditing, evidence collection, and SOC triage procedures.
## Evidence Reviewed
- Windows Security Event ID 4625 records
- `data/failed-logons.csv`
- Windows logon audit-policy output
- Event Viewer screenshot
- PowerShell validation output
- Sanitized CSV analysis results
## Key Findings
- **Target account:** SOC-Lab-User
- **Failure count:** 3
- **First observed:** September 1, 2026, 4:48:51 PM ET
- **Last observed:** September 1, 2026, 4:52:41 PM ET
- **Source:** Local / LAB-WINDOWS-01
- **Logon type:** 2 – Interactive
- **Status:** 0xC000006D
- **Failure reason:** Incorrect username or password
## Analysis
The three failures occurred against one temporary local account during a short, documented testing window. The consistent target account, local source, interactive Logon Type 2, and known testing activity support the conclusion that these events were authorized laboratory activity.
In a production environment, repeated authentication failures could indicate typing errors, stale credentials, brute-force activity, or password spraying. An analyst should correlate the events with the source address, affected account, successful logons, endpoint telemetry, and approved testing records before determining severity.
No evidence of unauthorized access, account compromise, persistence, or successful authentication was identified.
## Containment and Recommendations
No containment was required because the activity was authorized and limited to an owned local lab system.
Recommended production actions include:
- Confirm the activity with the affected user or system owner.
- Review nearby successful-logon events.
- Monitor for additional failures from the same source.
- Escalate repeated failures that exceed the organization’s alert threshold.
- Reset credentials or temporarily disable the account if compromise is suspected.
- Block a source address when malicious activity is confirmed.
- Forward Windows Security logs to a SIEM for centralized detection and correlation.
## Final Disposition
**Closed – Authorized Lab Activity**
The failed logons were intentionally generated on an owned Windows lab system to validate Security Event ID 4625 collection, PowerShell analysis, evidence preservation, and SOC incident-triage procedures.
## Lessons Learned
This project demonstrated how Windows records failed authentication activity and how Event ID 4625 fields support an investigation. I learned to distinguish controlled test activity from potentially malicious behavior by examining the target account, timestamps, logon type, status code, source, and authorization context.
In a production SOC workflow, I would improve this process by forwarding events to a SIEM, establishing alert thresholds, correlating failed and successful logons, mapping confirmed suspicious behavior to the appropriate MITRE ATT&CK techniques, and documenting escalation procedures.

