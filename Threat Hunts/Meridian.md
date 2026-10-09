# Threat Hunt Report: Meridian Investigation

**Participant:** Sadhvi Alam
**Date:** September 2026

## Platforms and Languages Leveraged

**Platforms:**

* Cyber Range Career Platform

* Azure Log Analytics Workspace (`LAW-HuntPractice`)

* Linux-based Web and Database Environment (`ip-10-1-15-67`)

**Languages/Tools:**

* Kusto Query Language (KQL) for querying access, authentication, audit, and defender logs

* Forensic Acquisition Tools: `avml` (Microsoft's open-source Linux memory-acquisition tool)

## Scenario

An external attacker originating from IP `10.1.134.57` targeted a healthcare portal residing on the internal host `10.1.15.67`. The adversary conducted methodical reconnaissance before exploiting a local file inclusion (LFI) vulnerability to extract credentials. These credentials facilitated SSH access and subsequent privilege escalation via a pre-staged SUID shell. The attacker maintained persistence using a deceptive script in an application directory, established command and control, tampered with backup configurations, and successfully exfiltrated patient records.

## Key Observations

* **Initial Vector:** A vulnerable endpoint, `config_viewer.php`, was directly targeted before automated scanning commenced.

* **Reconnaissance:** The attacker sequentially utilized `nmap`, `curl`, `whatweb`, and `gobuster` to enumerate the web server.

* **Credential Access:** The attacker leveraged an LFI vulnerability to sequentially pull `../../../etc/passwd` and `database.conf`, immediately reusing the credentials to log in via SSH as `svc_backup`.

* **Privilege Escalation:** After failing to escalate via `sudo` and root SSH, the attacker executed a pre-staged SUID bash shell (`/tmp/rootbash -p`) to gain root access.

* **Persistence:** A persistent backdoor was planted at `/opt/meridian/scripts/health_check`, which survived automated remediation sweeps because it masqueraded as a legitimate application script.

* **Command and Control:** The backdoor initiated outbound callbacks to `10.1.134.57:4444`.

* **Collection:** A full export of patient records was extracted from the database.

* **Collateral Damage:** The environment's automated defense sweep accidentally removed `sysmon.service` as a "non-baseline" service early in the timeline, blinding process-level telemetry for the remainder of the intrusion.

## Timeline & Queries Used

### Reconnaissance & Initial Access:

The investigation began by evaluating access logs for the attacker IP `10.1.134.57`. The attacker mapped the web server using four distinct recon tools, culminating in an 18,454-request gobuster directory brute-force. Prior to the scan, they deliberately probed `config_viewer.php`, indicating prior intelligence.

```
MeridianAccess_CL
| where isnotempty(EventTime_t)
| where ClientIp_s == "10.1.134.57"
| summarize FirstSeen=min(EventTime_t), Requests=count() by UserAgent_s
| order by FirstSeen asc

```

📌 *Traversal Endpoint Targeted:* `config_viewer.php`

### Credential Theft via LFI:

The attacker utilized the `config_viewer` file parameter to extract the system's `passwd` file followed by `database.conf`.

```
MeridianAccess_CL
| where ClientIp_s == "10.1.134.57"
| where RequestUri_s has "config_viewer" and RequestUri_s has "file="
| where StatusCode_s == "200"
| project EventTime_t, RequestUri_s, ResponseSize_s

```

<img width="918" height="735" alt="01-LFI-Extraction" src="https://github.com/user-attachments/assets/bdf396e4-2d3e-4d80-a547-b28dbd9e08ff" />


📌 *Artifacts Read:* `../../../etc/passwd`, `database.conf`

### Borrowed Access & Privilege Escalation:

Fifty-seven seconds after reading the configuration file, the attacker authenticated via SSH as `svc_backup`. Following failed attempts to use `sudo` or authenticate as root directly, they utilized a pre-staged SUID binary to escalate to root privileges.

```
MeridianAudit_CL
| where Types_s has "EXECVE"
| where Argv_s has "rootbash"
| project EventTime_t, comm_s, exe_s, Argv_s, auid_s, euid_s

```

<img width="512" height="317" alt="02-SSH-Borrowed-Access" src="https://github.com/user-attachments/assets/d9055111-c312-4885-8735-cdbabd5bfa9b" />

<img width="914" height="715" alt="03-Rootbash-PrivEsc" src="https://github.com/user-attachments/assets/507978de-8a73-497a-891d-87731300adff" />


📌 *SUID Shell:* `/tmp/rootbash -p`

### Persistence Mechanism:

To establish durable access that blended into the environment, the attacker planted a script disguised as routine application maintenance. This survived the system's automated defensive sweep, which only targeted specific directories and file types.

```
MeridianDefender_CL
| where EventCategory_s == "SWEEP"
| where RawMessage_s has "health_check"
| project EventTime_t, RawMessage_s

```

<img width="916" height="592" alt="04-Persistence-Detection" src="https://github.com/user-attachments/assets/96c79b34-64ca-4cc2-a24d-b6dc2c8b6d39" />

<img width="918" height="626" alt="05-Persistence-Process" src="https://github.com/user-attachments/assets/25ea8bc7-3191-4dc8-90bd-b092c7a57150" />


📌 *Persistence Path:* `/opt/meridian/scripts/health_check`

### Data Collection:

he attacker successfully exported the highest-value target from the healthcare portal's database.

```
MeridianDefender_CL
| where EventCategory_s == "WEB"
| where RawMessage_s has "export"
| project EventTime_t, RawMessage_s

```

<img width="916" height="628" alt="06-Data-Exfiltration" src="https://github.com/user-attachments/assets/198f9342-1a4b-41f4-aaef-c5f60056b25c" />


### Defense Blind Spot & Containment Failure:

Early in the timeline, the automated sweep falsely flagged and killed `sysmon.service`, removing critical logging. Later, network blocks dropped 73 outbound connections to the C2 server, but this only blocked network traffic; it did not neutralize the running process.

```
MeridianDefender_CL
| where EventCategory_s == "NETWORK"
| where DestIp_s == "10.1.134.57"
| summarize count() by DestPort_s
| project DestPort_s, count_

```

📌 *C2 Destination:* `10.1.134.57:4444`

## Summary of Findings

| Section | Description | Answer/Value | 
| ----- | ----- | ----- | 
| 1 | Recon Playbook | `4, nmap, curl, whatweb, gobuster` | 
| 2 | The Traversal Point | `config_viewer.php` | 
| 2 | Files Extracted via LFI | `../../../etc/passwd, database.conf` | 
| 3 | Borrowed Access Account | `svc_backup` | 
| 3 | Failed Escalation Paths | `sudo - command not allowed, ssh - failed password` | 
| 4 | The Planted Root Shell | `/tmp/rootbash -p` | 
| 5 | The Second Foothold | `/opt/meridian/scripts/health_check` | 
| 5 | Why Persistence Survived | `The sweep only reverts SSH keys, crontabs, and temp directories; the new shell is in an application directory.` | 
| 6 | Calling Home | `10.1.134.57:4444, not neutralised` | 
| 6 | Network Block Reality | `proves network activity was blocked, does not prove the process was killed` | 
| 7 | Exfiltrated Data | `patient records` | 
| 7 | The Tampered File | `backup.conf` | 
| 8 | Pre-intrusion Noise | `false positive` | 
| 8 | Collateral Damage from Sweep | `sysmon.service, sysmon logging gaps` | 
| 9 | Capturing the Evidence | `REVEAL: avml, /tmp/evidence/memory.lime` | 
| 9 | Required Manual Action | `manually terminate the rogue process /opt/meridian/scripts/health_check` | 

## Response Actions

* **Volatile Data Capture:** The returning admin appropriately executed `avml` twice to capture live memory to `/tmp/evidence/memory.lime` before disturbing the active host.

* **Automated Remediation:** The system's automated sweep successfully detected and killed the `/tmp/rootbash` shell and reverted the tampered `backup.conf` file.

* **Pending Manual Action:** Incident Response must still manually terminate the rogue process running at `/opt/meridian/scripts/health_check` to achieve true containment.

## Diamond Model of Intrusion Analysis

| Feature | Description | 
| ----- | ----- | 
| **Adversary** | External threat actor operating from IP `10.1.134.57` | 
| **Capability** | Methodical reconnaissance toolkit, exploitation of Public-Facing Applications (LFI), credential reuse, pre-staged SUID binaries for privilege escalation, and custom scripting for persistence | 
| **Infrastructure** | Attacker IP `10.1.134.57`, internal web application host `10.1.15.67`, Command & Control on port `4444` / `43212` | 
| **Victim** | Meridian healthcare portal, patient data records, and the `svc_backup` account | 

```
                   +-----------------------+
                   |     Infrastructure    |
                   | (10.1.134.57, C2 4444)|
                   +-----------+-----------+
                               |
                               v
+----------------+     +------+-------+     +------------------+
|   Adversary    |<--->|   Capability  |<--->|      Victim      |
|  Unknown APT   |     | LFI, SUID Bin,|     | Meridian Health  |
|                |     | Cred Reuse    |     | patient data     |
+----------------+     +---------------+     +------------------+

```

## Lessons Learned

* **Detection-Remediation Gaps:** Automated defensive tooling that restricts its cleanup to standard directories (like `/tmp`) will miss persistence mechanisms hiding in legitimate application paths.

* **Containment Fallacies:** Implementing a network firewall block against C2 callbacks does not neutralize the threat; the malicious process remains active and will retry if the block is lifted.

* **Collateral Damage:** Overly aggressive automated sweeps can impair defenses, such as accidentally removing critical telemetry services like `sysmon.service`.

* **Forensic Order of Operations:** Capturing volatile memory state of a live backdoor prior to manual remediation is critical for comprehensive incident analysis.
