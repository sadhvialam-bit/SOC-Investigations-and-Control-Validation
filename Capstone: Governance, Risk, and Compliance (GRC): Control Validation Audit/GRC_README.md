# Governance, Risk, and Compliance (GRC): Control Validation Audit

## Audit Objective & Scope
This targeted audit assesses the effectiveness of implemented technical controls, identity management, and incident response procedures against a live-fire simulation in a Microsoft Azure cloud environment. 

A purposely vulnerable Windows 11 virtual machine (`corp-na01-broca`) hosting a MySQL database was exposed to the public internet. The objective of this project is to evaluate organizational resilience, map vulnerabilities to control failures, and validate the efficacy of internal controls when perimeter defenses are intentionally degraded.

## Tools & Technologies
* **Environment:** Microsoft Azure (Virtual Machines, Network Security Groups)
* **SIEM/EDR:** Microsoft Sentinel, Microsoft Defender for Endpoint
* **Audit Focus Areas:** Identity & Access Management (IAM), Network Security, Data Integrity, Incident Response Configuration

---

## Control Deficiencies & Risk Realization
The live-fire simulation exposed critical vulnerabilities stemming from deliberate control bypasses, highlighting the immediate financial and operational risks associated with misconfigured infrastructure:

* **Inadequate Network Access Controls:** The implementation of an unrestricted inbound Network Security Group (NSG) rule bypassed standard network segmentation protocols. 
  * **Risk Realization:** Allowed automated external scanners to map exposed services (RDP/3389, MySQL/3306) within hours.
* **Weak Identity & Access Management (IAM):** The use of default administrative usernames (`administrator`, `root`) combined with the absence of Account Lockout policies and Multi-Factor Authentication (MFA). 
  * **Risk Realization:** Enabled rapid, successful brute-force authentication leading to total system and database compromise.
* **Insufficient Data Protection & Integrity:** Lack of application-layer controls preventing destructive SQL commands by remote accounts. 
  * **Risk Realization:** Resulted in unauthorized data deletion and a ransomware demand, demonstrating a complete failure of data availability and integrity controls.

**Audit Evidence:**
<img width="1490" height="906" alt="Evidence_7a" src="https://github.com/user-attachments/assets/2a1ef2d6-c488-4a48-897c-0c5a73e41f2c" />

*Log artifacts demonstrating the realization of data destruction risk due to poor application-layer IAM controls.*

<img width="880" height="761" alt="Evidence_6c" src="https://github.com/user-attachments/assets/51e941ef-a07a-4cdc-b2d4-4762640a8135" />

*Validation that continuous monitoring and SIEM controls (Microsoft Sentinel) successfully triggered during the breach.*

---

## Corrective Action Plan (CAP)
To align with corporate auditing standards and internal control frameworks, the following compensating controls must be mandated for all future deployments to mitigate identified risks.

| Control Domain | Identified Deficiency | Recommended Remediation | Priority |
| :--- | :--- | :--- | :--- |
| **Network Security** | Unrestricted inbound internet access via Azure NSG. | Enforce Default-Deny firewall policies and implement Just-In-Time (JIT) access for all management ports (RDP/SSH). | Critical |
| **Identity Management** | Default accounts enabled without MFA or lockout policies. | Mandate MFA for all external access, disable default local administrative accounts, and enforce complex password/lockout policies. | Critical |
| **Data Protection** | Over-privileged application accounts allowed remote data destruction. | Enforce Principle of Least Privilege (PoLP) on database accounts; restrict destructive commands (DROP/DELETE) for network-facing accounts; implement immutable backups. | Critical |
| **Continuous Monitoring** | Reliance on manual containment post-breach. | Maintain SIEM analytics rules to detect rapid authentication failures and integrate SOAR playbooks for automated host isolation upon high-severity alerts. | High |

**Remediation Evidence:**

<img width="1287" height="785" alt="Evidence_8c" src="https://github.com/user-attachments/assets/3642f62d-b736-4f91-9bf5-7f8c08d67d97" />

*Execution of endpoint isolation procedures (Containment Control).*

<img width="1298" height="586" alt="Evidence_8e" src="https://github.com/user-attachments/assets/30fcb44b-ed0c-45ee-8f0c-0c5e883a920c" />

*Eradication of vulnerable NSG rules, restoring network access controls.*
