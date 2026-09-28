# Meridian Web Intrusion: SQL Injection & Defense Evasion

## Executive Summary
* **Target Asset:** `ip-10-1-15-67` (Ubuntu 22.04)
* **Exposed Services:** Apache, PHP, MySQL
* **Known Attacker IP:** `10.1.134.57`
* **Incident Window:** 06 February 2026, 02:42 to 05:30 UTC
* **Environment Context:** The host utilized a six-service automated defense suite that actively reverted unauthorized changes during the intrusion. The following forensic timeline isolates true attacker activity from automated remediation telemetry.

### Forensic Timeline & KQL Evidence

**1. Initial Access: Local File Inclusion (LFI)**
The threat actor established initial access by leveraging a vulnerability in the `config_viewer.php` endpoint. This allowed the attacker to read sensitive local files, specifically targeting `/etc/passwd` to enumerate users and `database.conf` to steal credentials.
*   **Log Source:** `MeridianAccess_CL`

<img width="918" height="735" alt="Evidence_1" src="https://github.com/user-attachments/assets/c30af0bd-358d-46fa-9664-3ff4734e7666" />


**2. Persistence & Defense Evasion**
The attacker established a durable backdoor process (`health_check`) hidden within a legitimate application directory (`/opt/meridian/scripts/`). The host's automated defense stack flagged this script as non-baseline during its sweeps but failed to remediate it, as the stack was only programmed to revert temp directories, SSH keys, and crontabs.

<img width="918" height="626" alt="Evidence_2" src="https://github.com/user-attachments/assets/4c9383e6-ab13-41f6-8440-da3c33ebcdd5" />
<img width="916" height="592" alt="Evidence_3" src="https://github.com/user-attachments/assets/c7c35315-7ca4-43bd-83f2-f7893de7d0cc" />


**3. Privilege Escalation & Credential Harvesting**
Using the credentials harvested from `database.conf`, the attacker authenticated via SSH as `svc_backup`. They subsequently executed a pre-staged SUID bash shell (`rootbash -p`) to escalate their privileges to root.
*   **Log Sources:** `MeridianAuth_CL` / `MeridianAudit_CL`

<img width="917" height="568" alt="Evidence_4" src="https://github.com/user-attachments/assets/07de2cb0-8b28-4507-a2b6-5c4cfdcc2a49" />
<img width="914" height="715" alt="Evidence_5" src="https://github.com/user-attachments/assets/d8c0887a-a9c0-443e-a2bd-0c8dd7079833" />


**4. Action on Objectives: Database Exfiltration**
Leveraging their escalated privileges, the attacker successfully executed an export query against the primary MySQL database, exfiltrating the highly sensitive patient data records before the intrusion was fully contained. 
*   **Log Source:** `MeridianDefender_CL`

<img width="916" height="628" alt="Evidence_6" src="https://github.com/user-attachments/assets/3780162b-7a87-4210-8e2d-008ca94e4378" />

## Tactical Containment & Remediation Plan
To fully eradicate the threat and secure the web application, the following actions must be prioritized:
1.  **Application Patching:** Identify and remediate the specific LFI vulnerability in the PHP web application code.
2.  **Credential Reset:** Force a global password rotation for all MySQL and local Ubuntu accounts compromised during the harvesting phase.
3.  **Network Blocking:** Implement perimeter firewall rules to permanently block the attacker IP (`10.1.134.57`).
4.  **Defense Tuning:** Review the automated defense stack's configuration to ensure it isolates compromised hosts from the network rather than relying on narrow file-reversion rules.
5.  **Manual Eradication:** Manually terminate process PID 267155 and delete the `/opt/meridian/scripts/health_check` backdoor.<img width="918" height="735" alt="Evidence_1" src="https://github.com/user-attachments/assets/f5ce88f4-bfe5-4233-83bf-e668c207a4c5" />
