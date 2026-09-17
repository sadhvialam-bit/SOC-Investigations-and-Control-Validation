# Incident Report: Hands-on-Keyboard Attack on AP Endpoint

## Executive Summary
On September 17, 2026, Microsoft Defender generated a High-Severity alert for a compromised account conducting a hands-on-keyboard attack. The threat actor gained access to an Accounts Payable workstation (`CORP-AP-WS01`), executed enumeration commands, and established an unauthorized outbound connection using the Tor network. The host was successfully isolated to prevent lateral movement and data exfiltration.

## Impacted Asset
* **Hostname:** `CORP-AP-WS01`
* **Department:** Finance / Accounts Payable
* **Compromised Identity:** `sadhvi` (Local Admin)

## Investigation & Telemetry Evidence
**1. Initial Detection**
The initial alert triggered following anomalous behavior in the ASEP registry and interaction with `lsass.exe`, indicative of credential dumping attempts.
* <img width="1862" height="981" alt="Screenshot 2026-09-17 152915" src="https://github.com/user-attachments/assets/0beaf53c-2620-45aa-afec-6633ee93b4a2" />


**2. Process Execution & Discovery**
Advanced Hunting queries (`DeviceProcessEvents`) confirmed the attacker executed multiple system discovery commands, including `systeminfo.exe`, `netsh advfirewall`, and PowerShell `Get-CimInstance` queries.
* <img width="1861" height="986" alt="Screenshot 2026-09-17 155404" src="https://github.com/user-attachments/assets/0f866776-027f-409a-ac74-8a746f91f52d" />


**3. Command & Control (C2) Activity**
Network telemetry (`DeviceNetworkEvents`) revealed the execution of an unauthorized Tor browser binary (`tor.exe`) from the user's desktop, initiating outbound traffic over port 443 to external IPs (e.g., 94.100.6.11).
* <img width="1858" height="980" alt="Screenshot 2026-09-17 155953" src="https://github.com/user-attachments/assets/854f8bd3-b127-4213-a6ea-c5844c85faa2" />


## Containment Actions
* **Action Taken:** Full Device Isolation
* **Time of Containment:** Sep 17, 2026, 4:03 PM
* **Result:** The device was completely disconnected from the corporate network, neutralizing the active C2 connection while preserving forensic data.
* <img width="1858" height="977" alt="Screenshot 2026-09-17 160450" src="https://github.com/user-attachments/assets/0ce512f6-a8bf-4bd6-91c5-a9cd26023c56" />
