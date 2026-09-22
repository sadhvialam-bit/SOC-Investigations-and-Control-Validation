# Proactive Threat Hunt: Endpoint Compromise & C2 Beaconing

![Help Desk Ticket #4451](Screenshot%201.jpg)

## Deliverable 2: Investigation Report
* **Ticket Number:** Help Desk Ticket #4451
* **Reporter:** Mark Smith (Finance Department)
* **Impacted Asset:** `npt-ws01`
* **Incident Window:** 22 April 2026, 04:30 to 06:00 UTC

### Forensic Timeline & KQL Evidence

**1. Initial Access & Execution**
The attacker bypassed standard user accounts and successfully authenticated over the network using the `helpdesk` account from an external IP address (`20.110.92.50`). Following authentication, the attacker utilized WMI (`wmiprvse.exe`) to remotely execute commands, dropping a 37MB implant named `WindowsUpdate.exe` into the `C:\Windows\Temp\` directory. 

*   **Execution Command:** `cmd.exe /Q /c start "" "C:\Windows\Temp\WindowsUpdate.exe"`
*   **Implant SHA256:** `20cef6a013953890f9d38605d25d60dd63b42b09946bbb18ddb4a456da306e77`

![Initial Access Evidence - Execution](Screenshot%202.png)
![Initial Access Evidence - File Drop](Screenshot%203.png)

**2. Command & Control (C2)**
Upon execution, the implant immediately initiated outbound C2 beaconing over port 443.
*   **C2 Domain:** `updates.abordasync.website`

![Command and Control Evidence](Screenshot%204.png)

**3. Persistence Mechanisms**
The attacker established multiple redundant persistence mechanisms disguised as legitimate Windows services and updaters:
*   **Registry Run Key:** `WindowsHealthCheck`
*   **Scheduled Task:** `GoogleUpdaterTask`
*   **System Service:** `WindowsHealthSvc`

![Persistence Mechanisms Evidence](Screenshot%205.png)

**4. Privilege Escalation & Lateral Movement**
The threat actor executed `net.exe` commands to create a local backdoor account named `nexus_admin` and subsequently added it to the local Administrators group. Telemetry indicates the attacker then attempted lateral movement toward a secondary host, `npt-srv01`.

![Privilege Escalation Evidence](Screenshot%206.png)

## Deliverable 1: Tactical Containment Plan
To halt the active intrusion and eradicate the attacker's footprint, the following actions are required immediately:
1.  **Isolation:** Execute full device isolation on `npt-ws01` and `npt-srv01`.
2.  **Account Remediation:** Disable the `nexus_admin` backdoor account and the compromised `helpdesk` account. Force a global password reset for `helpdesk`.
3.  **Network Blocking:** Block C2 IP `20.110.92.50` and domain `updates.abordasync.website` at the perimeter firewall. Add the implant's SHA256 hash to the EDR blocklist.
4.  **Eradication:** Delete the `WindowsHealthCheck` Run key, the `GoogleUpdaterTask` scheduled task, and the `WindowsHealthSvc` service.
