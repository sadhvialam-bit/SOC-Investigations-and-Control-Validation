# SOC Incident Response & Threat Hunting: Cloud Honeypot Capstone

## Objective
This project demonstrates end-to-end Incident Response (IR) and Threat Hunting capabilities within a live Azure cloud environment. A purposely vulnerable Windows 11 virtual machine (`corp-na01-broca`) hosting a MySQL database was exposed to the public internet to attract, detect, and analyze live threat actor activity. 

The primary objective was to engineer custom SIEM detections, monitor lateral movement, perform host-level forensics, and execute a complete containment and eradication protocol following a successful multi-vector breach.

## Tools & Technologies
* **Environment:** Microsoft Azure (Virtual Machines, Network Security Groups, Log Analytics Workspace)
* **SIEM:** Microsoft Sentinel (KQL for Custom Analytics Rules & Threat Hunting)
* **EDR:** Microsoft Defender for Endpoint (MDE)
* **Application:** MySQL Server 8.0

---

## Incident Lifecycle & Forensic Analysis

### Phase 1: Detection & Initial Access
After intentionally weakening the Network Security Group (NSG) and host firewalls, custom Sentinel analytics rules successfully detected external threat actors bypassing authentication controls.
* **Vector 1 (OS Level):** A threat actor (`59.15.116.99`) successfully brute-forced the RDP service (Port 3389) via the `administrator` account.
* **Vector 2 (Application Level):** A separate threat actor (`77.90.185.30`) successfully brute-forced the MySQL Server (Port 3306) via the `root` account. 
* **SIEM Alerting:** Sentinel successfully correlated the OS-level breach, generated Incident ID `230018`, and mapped the threat actor's IP directly to the compromised Azure VM entity.

**Evidence:**
<img width="1505" height="776" alt="Evidence_6a" src="https://github.com/user-attachments/assets/b17c9222-9aee-4555-a28c-9739044d0543" />

*Initial access via RDP brute-force detected in Advanced Hunting logs.*

<img width="1502" height="1018" alt="Evidence_6b" src="https://github.com/user-attachments/assets/89287a9d-729c-4ddb-b47d-bcc43ec31035" />

*Secondary access via MySQL root brute-force.*

<img width="880" height="761" alt="Evidence_6c" src="https://github.com/user-attachments/assets/84439b8b-5a21-4938-a9e8-ef4de986b930" />

*Sentinel generating an incident and mapping the attacker IP to the host entity.*

### Phase 2: Analysis & Impact
Following the initial access alerts, a deep-dive forensic investigation was launched using Advanced Hunting queries in Microsoft Defender to determine post-compromise activity.
* **Host-Level Forensics (`DeviceProcessEvents`):** An investigation into the RDP attacker's activity revealed no malicious payload executions, PowerShell bypasses, or persistence mechanisms on the Windows OS. The OS layer remained structurally clean.
* **Application-Level Forensics (`MySQLAudit_CL`):** Database logs revealed a highly destructive ransomware attack. Immediately following authentication, the attacker (`77.90.185.30`) executed `DROP TABLE` commands against production tables, generated a new table named `RECOVER_YOUR_DATA_info`, and used an `INSERT INTO` command to drop a ransom note.

**Evidence:**
<img width="1490" height="906" alt="Evidence_7a" src="https://github.com/user-attachments/assets/802b829e-7cbd-4342-8d7a-53299bf70c58" />

*Malicious SQL queries dropping production tables and inserting a ransom note.*

<img width="1395" height="737" alt="Evidence_7b" src="https://github.com/user-attachments/assets/9508f22b-c33b-436f-b864-d1e835772f5d" />

*DeviceProcessEvents confirming no post-compromise execution on the OS layer.*

### Phase 3: Containment
To halt the active database destruction and sever the attackers' command and control, immediate incident response containment protocols were executed.
* **Device Isolation:** The compromised VM was fully isolated from the network via Microsoft Defender for Endpoint, locking the attackers out while preserving the host for final forensic imaging.
* **Network Severance:** The vulnerable `DANGER-Allow-All-Inbound` rule was manually eradicated from the Azure NSG to permanently block external RDP and MySQL traffic.

**Evidence:**
<img width="1273" height="792" alt="Evidence_8b" src="https://github.com/user-attachments/assets/3a32b3aa-3360-44d3-9a54-3303d7add90b" />
<br>
<img width="1287" height="785" alt="Evidence_8c" src="https://github.com/user-attachments/assets/4a4f108f-ecd0-4576-8e82-d63976647d74" />

*Executing and confirming host isolation via Microsoft Defender.*

<img width="1298" height="552" alt="Evidence_8d" src="https://github.com/user-attachments/assets/fe22cc28-2840-4659-b1a0-15e4ce817070" />
<br>
<img width="1298" height="586" alt="Evidence_8e" src="https://github.com/user-attachments/assets/2a9612e5-5857-419d-b33b-acaab8e1caa9" />

*Severing attacker network access by removing the vulnerable NSG rule.*

### Phase 4: Eradication & Recovery
With the threat successfully contained, the environment was hardened to restore the security baseline and prepare the application for data restoration.
* **Identity Management:** The compromised local `administrator` account was disabled via `compmgmt.msc`.
* **Database Securing:** The vulnerable remote `root@%` user was permanently dropped from MySQL, and the corrupted `lnp_corp` database was dropped to prepare for a clean backup restoration.
* **Host Defenses:** The Windows Defender Firewall was fully re-enabled for Domain, Private, and Public profiles, followed by a full Microsoft Defender Antivirus sweep to ensure no latent malware remained on the disk.

**Evidence:**
<img width="982" height="705" alt="Evidence_8f" src="https://github.com/user-attachments/assets/853b0a99-bce4-4b68-9f8b-525f5aee6b09" />

*Disabling the compromised local administrator account.*

<img width="1180" height="880" alt="Evidence_8g" src="https://github.com/user-attachments/assets/4c0efebf-afe3-43a7-a045-219dd69b775d" />
<br>
<img width="1329" height="887" alt="Evidence_8h" src="https://github.com/user-attachments/assets/c35d9893-9ae7-4131-ada1-e51b2355b2d1" />

*Dropping the remote root user and the corrupted database to prepare for recovery.*

<img width="1039" height="776" alt="Evidence_8i" src="https://github.com/user-attachments/assets/97f86e86-e617-4fb8-a42d-5645c0c1ca69" />
<br>
<img width="371" height="340" alt="Evidence_8j" src="https://github.com/user-attachments/assets/b4025715-6a98-458e-ad09-4f4c98d251e8" />

*Restoring host-level firewall defenses across all profiles.*

<img width="1189" height="834" alt="Evidence_8k" src="https://github.com/user-attachments/assets/49593d1c-7c7f-4b8f-bafc-6360ebbf9fb4" />

*Final Defender Antivirus scan to verify host integrity.*
