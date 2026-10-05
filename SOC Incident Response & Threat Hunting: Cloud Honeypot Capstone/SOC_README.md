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
![RDP Brute Force Success](Evidence_6a.png)
*Initial access via RDP brute-force detected in Advanced Hunting logs.*

![MySQL Brute Force Success](Evidence_6b.png)
*Secondary access via MySQL root brute-force.*

![Sentinel Incident Graph](Evidence_6c.png)
*Sentinel generating an incident and mapping the attacker IP to the host entity.*

### Phase 2: Analysis & Impact
Following the initial access alerts, a deep-dive forensic investigation was launched using Advanced Hunting queries in Microsoft Defender to determine post-compromise activity.
* **Host-Level Forensics (`DeviceProcessEvents`):** An investigation into the RDP attacker's activity revealed no malicious payload executions, PowerShell bypasses, or persistence mechanisms on the Windows OS. The OS layer remained structurally clean.
* **Application-Level Forensics (`MySQLAudit_CL`):** Database logs revealed a highly destructive ransomware attack. Immediately following authentication, the attacker (`77.90.185.30`) executed `DROP TABLE` commands against production tables, generated a new table named `RECOVER_YOUR_DATA_info`, and used an `INSERT INTO` command to drop a ransom note.

**Evidence:**
![SQL Ransomware Execution](Evidence_7a.png)
*Malicious SQL queries dropping production tables and inserting a ransom note.*

![Clean Host OS](Evidence_7b.png)
*DeviceProcessEvents confirming no post-compromise execution on the OS layer.*

### Phase 3: Containment
To halt the active database destruction and sever the attackers' command and control, immediate incident response containment protocols were executed.
* **Device Isolation:** The compromised VM was fully isolated from the network via Microsoft Defender for Endpoint, locking the attackers out while preserving the host for final forensic imaging.
* **Network Severance:** The vulnerable `DANGER-Allow-All-Inbound` rule was manually eradicated from the Azure NSG to permanently block external RDP and MySQL traffic.

**Evidence:**
![Device Isolation Initiation](Evidence_8b.png)
<br>
![Device Isolation Confirmation](Evidence_8c.png)
*Executing and confirming host isolation via Microsoft Defender.*

![NSG Rule Deletion](Evidence_8d.png)
<br>
![NSG Secured](Evidence_8e.png)
*Severing attacker network access by removing the vulnerable NSG rule.*

### Phase 4: Eradication & Recovery
With the threat successfully contained, the environment was hardened to restore the security baseline and prepare the application for data restoration.
* **Identity Management:** The compromised local `administrator` account was disabled via `compmgmt.msc`.
* **Database Securing:** The vulnerable remote `root@%` user was permanently dropped from MySQL, and the corrupted `lnp_corp` database was dropped to prepare for a clean backup restoration.
* **Host Defenses:** The Windows Defender Firewall was fully re-enabled for Domain, Private, and Public profiles, followed by a full Microsoft Defender Antivirus sweep to ensure no latent malware remained on the disk.

**Evidence:**
![Account Disabled](Evidence_8f.png)
*Disabling the compromised local administrator account.*

![Drop MySQL Root User](Evidence_8g.png)
<br>
![Drop Compromised Database](Evidence_8h.png)
*Dropping the remote root user and the corrupted database to prepare for recovery.*

![Firewall Restored](Evidence_8i.png)
<br>
![Firewall Active](Evidence_8j.png)
*Restoring host-level firewall defenses across all profiles.*

![Malware Scan](Evidence_8k.png)
*Final Defender Antivirus scan to verify host integrity.*
