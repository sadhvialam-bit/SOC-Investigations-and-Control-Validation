# Executive Audit Report: Finance Endpoint Compromise & Threat Hunt

## 1. Business Risk & Impact Assessment
On April 22, 2026, an unauthorized user gained remote interactive access to `npt-ws01`, a critical workstation operated within the Finance department. The attacker successfully created a local administrator backdoor (`nexus_admin`). Given the endpoint's proximity to daily financial operations, unrestricted administrative access introduces severe vulnerabilities. An attacker operating at this privilege level poses a direct risk of manipulating mileage, personal expense processing, or vendor payment workflows integrated through platforms like Concur and SAP.

## 2. SLA & Incident Reporting Compliance (NIST SP 800-61)
*   **Incident Window:** 04:30 to 06:00 UTC
*   **User Reporting Time:** 09:14 UTC
*   **Dwell Time Risk:** A gap of over three hours existed between the initial automated C2 beaconing and the end-user generating Help Desk Ticket #4451. This highlights a reliance on reactive user reporting rather than automated SOC alerting, underscoring the critical necessity of proactive threat hunting to minimize attacker dwell time on high-value finance assets.

## 3. Control Failures Identified
The investigation revealed gaps in endpoint hardening that permitted the intrusion to progress:
*   **Application Control Bypass:** The attacker successfully executed an unapproved, untrusted binary (`WindowsUpdate.exe`) directly from the `C:\Windows\Temp\` directory.
*   **Unrestricted Network Authentication:** An external, public IP address (`20.110.92.50`) was permitted to authenticate over the network using an internal service account (`helpdesk`).

## 4. Audit Recommendations & Remediation
To align with enterprise risk management standards and protect accounts payable infrastructure, the following structural remediations are required:
*   **Application Control Enforcement:** Implement strict AppLocker or Windows Defender Application Control (WDAC) policies to explicitly block binary execution from user-writable directories such as `\Temp\` and `\Downloads\`.
*   **Service Account Hardening:** Restrict the `helpdesk` account from interactive or network logons originating outside the corporate VPN, and mandate MFA for all administrative access.
*   **Privilege Management:** Revoke local administrator rights from standard Finance users and implement Just-In-Time (JIT) access for helpdesk personnel.
