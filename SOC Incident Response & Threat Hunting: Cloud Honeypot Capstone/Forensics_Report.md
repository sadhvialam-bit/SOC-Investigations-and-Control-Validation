# Live-Exposed Honeypot: RDP Account Takeover and MySQL Data Extortion

**Host:** Azure VM `CORP-NA01-BROCAD` (Windows hostname / MDE device `corp-na01-broca`, cut to the 15-character NetBIOS limit). Windows 11 Pro 25H2, MySQL Server 8.0.45
**Date:** 2026-10-05 (all times **UTC** unless marked otherwise)
**Project:** Cyber Range capstone: build → instrument → baseline → detect → weaken and expose → contain → recover
**Evidence:** Two MDE investigation packages (taken before and after the breach), Microsoft Sentinel / Defender XDR advanced hunting, Azure portal and on-host screenshots
**Companion document:** [GRC Assessment](GRC-Assessment.md)

> **Context.** This VM was a **deliberately weakened honeypot**. Weak accounts, an open NSG, the host firewall being off, and remotely reachable MySQL were all part of the lab design. Nothing on the host was real production data.

---

## TL;DR

The honeypot was breached **twice, through two independent routes**:

| | Windows / RDP | MySQL (3306) |
|---|---|---|
| **Access** | `administrator` brute-forced over NTLM from **59.15.116.99** (15:57:22) | `root@'%'` with password `root`, logged into by **93.174.93.12**, **77.90.185.30**, **45.8.17.25** |
| **Follow-on** | Interactive **RDP** logon from a different IP, **80.94.95.238** (16:24:09). Credentials checked again by **193.213.83.126** (17:03:35) | **45.8.17.25** dumped the `world` database, **dropped 3 tables**, and left a ransom table, `RECOVER_YOUR_DATA_info` (14:10) |
| **Effect** | Admin session left disconnected; no malware or persistence found | **Data destroyed and held for ransom** (database extortion) |
| **Detected?** | **Yes.** Sentinel incident 230018 created 5 m 36 s after the compromise | Rule was deployed; whether it fired isn't shown in the evidence |

**Incident type:** Opportunistic internet-wide credential attacks leading to **(1) unauthorized RDP access** and **(2) MySQL data-destruction extortion**. The host was isolated at ~21:06 and remediated by 21:34.

---

## 1. Environment and preparation

Telemetry was set up before exposure, following the capstone checklist:

| Control | Evidence |
|---|---|
| MySQL general query log → Azure Monitor Agent → `MySQLAudit_CL` in `LAW-Cyber-Range` | DCR: Custom Text Logs, `mysql_general.log` → `MySQLAudit_CL` |
| Ingestion checked (04:51) | `MySQLAudit_CL` returning `corp-na01-brocad` rows (04:51 UTC) |
| Sentinel rule **Cyber-Defense-Final-corp-na01-broca**: `DeviceLogonEvents`, LogonSuccess for `administrator`/`guest`, every 10 min | Rule logic: `DeviceLogonEvents` → LogonSuccess for `administrator`/`guest`, Host + IP entities, 10-min schedule |
| Sentinel rule **Cyber-Defense-Final-MySQL**: failed-then-successful MySQL login, every 10 min, Credential Access | Rule details: Enabled, Medium, Credential Access, 10-min schedule, incidents enabled, automation rules attached |

**Deliberate weakening, as designed:**
- 05:35–05:45: `salam` created `administrator` (local admin + RDP users) and enabled `Guest` (RDP users). Source: baseline Security 4720/4732/4722.
- 05:55:35: Windows Firewall disabled for all three profiles. Sources: Security 4950; prefetch shows `wf.msc` opened at 05:55:10.
- NSG rule **`DANGER-Allow-All-Inbound`** (priority 100, Any/Any) was in place. Screenshot taken ~06:01; the hunting queries use 05:12:01 as the exposure time.

*Evidence: NSG `CORP-NA01-BROCAD-nsg`: priority 100 `DANGER-Allow-All-Inbound` (Any/Any/Any → Allow), public IP 104.209.158.190.*

---

## 2. Baseline determination (MDE packages)

| Package | Collected (UTC) | Collection ID | Role |
|---|---|---|---|
| `Pre-Breach.zip` | 2026-10-05 05:49:59–05:50:47 | `166255b6-…` | **Baseline** |
| `MDE_Investigation_Package_POST_BREACH.zip` | 2026-10-05 20:30:24–20:30:50 | `82c28fea-…` | Comparison |

**Why the pre-breach package is the baseline:**
- The `Forensics Collection Summary.csv` timestamps put it ~14.7 h earlier.
- The later Security log continues the baseline's record IDs (4,653 overlap, no gaps).
- Boot time moves from 04:49 to 13:56, after a scheduled shutdown at 08:01.

The baseline was taken **mid-setup**. The weak accounts already existed; the firewall change came 5 minutes later.

> The MDE package does **not** include the MySQL general log, so the database breach is only visible through Sentinel (`MySQLAudit_CL`).

---

## 3. Attack timeline

| UTC | Source | Activity | Evidence |
|---|---|---|---|
| 05:12 | — | Recorded exposure time (NSG open) | Hunting query parameter |
| 05:50 | — | Baseline MDE package | Package metadata |
| 05:55:35 | `salam` session | Host firewall disabled | Security 4950 ×3 |
| **06:58:38** | **93.174.93.12** | 3 failed `root` logins → **MySQL root login succeeds** | `MySQLAudit_CL` |
| 08:01–13:56 | Azure | Scheduled shutdown and restart | System 1074 / 6005 |
| **14:02:05** | **77.90.185.30** | `root`/`admin`/`sa` attempts → **root login succeeds** (repeats 15:21 and 16:38) | `MySQLAudit_CL` |
| **14:10:08** | **45.8.17.25** | **MySQL root login succeeds** | `MySQLAudit_CL` |
| **14:10:18–20** | 45.8.17.25 | `SELECT /*!40001 SQL_NO_CACHE */ * FROM countrylanguage` (mysqldump signature) → `CREATE TABLE world.RECOVER_YOUR_DATA_info` → `INSERT … 'Saved file name: world.sql'` → **`DROP TABLE world.country`, `world.city`, `world.countrylanguage`** | `MySQLAudit_CL` |
| 14:57:39 | 173.255.214.88 | First failed Windows logon from the internet | Security 4625 |
| 15:53:45 | 46.245.99.226 | Spraying of 28 generic usernames (461 attempts) | Security 4625 |
| 15:55:35 | **59.15.116.99** | NTLM brute force of `administrator` (1,141 attempts) | Security 4625, `DeviceLogonEvents` |
| **15:57:22** | **59.15.116.99** | **`administrator` logon succeeds** (network, NTLM) | Security 4624 rec 19458 |
| **16:02:58** | Sentinel | **Incident 230018 created** (Medium, Active, Unassigned) | Incident page |
| 16:01:11 → 20:19:53 | — | `administrator` locked out 22 times by the continuing brute force | Security 4740 |
| **16:24:09** | **80.94.95.238** (WIN-7OS71AQBILK) | **Interactive RDP logon (type 10)**. No failed attempts beforehand, so the password was already known | Security 4624 recs 22455/22457 |
| 16:24–16:25:40 | Session 3 | First-logon profile creation (Edge, OneDrive setup); session disconnected | Prefetch, temp listing |
| 16:29:47 | Console | Reconnect fails because the account is locked | Security 4625 `0xC0000234` |
| **17:03:35** | **193.213.83.126** (PC-C4W9W34) | Credential check (logon and logoff in the same second) | Security 4624 rec 22917 |
| 17:08 | — | Incident 230018 **still Unassigned / Unclassified** | Screenshot |
| 19:28:33 | System | Smart App Control switched itself off (no user session active) | Defender 5007 |
| 20:30 | Analyst | Post-breach MDE package collected | Package metadata |
| **~21:06** | Analyst | **Device isolated in MDE** ("Post-Breach Isolation – SA") | Screenshot |
| 21:14–21:34 | Analyst | Eradication and recovery (see §7) | Screenshots |

---

## 4. Breach 1: Windows / RDP

**Brute force followed by successful logon (`DeviceLogonEvents`):**

*Evidence: `DeviceLogonEvents`: repeated LogonFailed from 59.15.116.99, then LogonSuccess (Network) at 15:57 UTC.*

**Sentinel incident 230018:** first activity 15:57:22 (11:57:22 EDT); created 16:02:58 (12:02:58 EDT); entities `corp-na01-broca` and `59.15.116.99`.

*Evidence: Incident 230018: Medium, Active, Unassigned, Unclassified; first activity 15:57:22 UTC; created 16:02:58 UTC; entities `corp-na01-broca` and 59.15.116.99.*

**Key observations:**
- The password was guessed after **228 bad-password attempts**, about 2 minutes after the brute force started.
- The **RDP logon came from a different IP that had no failed attempts**, so the password had been passed on (a scanner or access broker found it, someone else used it).
- The continuing brute force **locked the account 22 times**, which also stopped the attacker from reconnecting at 16:29.
- **No persistence was found in the MDE package comparison:** scheduled tasks unchanged (252/252), no new service binaries, no malicious Run keys, no Defender detections, no exclusions.
- **Outbound:** `NTANetAnalytics` shows only denied NTP (UDP 123) flows. There were no blocked C2, mining or pivot attempts.

*Evidence: `NTANetAnalytics`: only denied outbound flows are UDP 123 (NTP) to Azure public.*

---

## 5. Breach 2: MySQL data extortion

**Successful `root` logins from the internet:**

*Evidence: `MySQLAudit_CL` auth parse: `root` LogonSuccess from 93.174.93.12, 77.90.185.30 and 45.8.17.25.*

**Query log showing the dump-drop-ransom sequence by 45.8.17.25 (14:10 UTC / 10:10 EDT):**

*Evidence: `MySQLAudit_CL` queries at 14:10 UTC: mysqldump-style SELECTs, `CREATE TABLE world.RECOVER_YOUR_DATA_info`, ransom INSERT, three `DROP TABLE` statements.*

**What the queries show:**
1. **Collection / exfiltration:** `SHOW TRIGGERS`, `show fields`, `SELECT /*!40001 SQL_NO_CACHE */ * FROM countrylanguage`. This is the exact pattern **mysqldump** generates, so the data was copied out over the MySQL session.
2. **Ransom note:** `CREATE TABLE world.RECOVER_YOUR_DATA_info (README_ME text)`, then `INSERT … ('Saved file name: world.sql …')`.
3. **Destruction:** `SET FOREIGN_KEY_CHECKS=0`, then `DROP TABLE world.country`, `world.city`, `world.countrylanguage`.

This is the well-known automated **"pay to recover your database"** pattern: dump the data, drop it, leave a note.

`77.90.185.30` logged in three times, using the same `root`/`admin`/`sa` sequence each time. That looks like an automated credential checker. `93.174.93.12` got in first, at 06:58. What either of them did afterwards isn't shown in the screenshots.

> **Data at risk:** The `lnp_corp` schema held **fake PII** (names, addresses, dates of birth, SSN-format values). The evidence shows only `world` was dumped and dropped. Whether `lnp_corp` was read needs a full `MySQLAudit_CL` query export (see §9). In production, it would decide whether breach notification is required.

---

## 6. Artifact comparison (MDE packages)

| Category | Item | Change | Assessment | Evidence |
|---|---|---|---|---|
| Security log | 1,770 × 4625 from 6 public IPs | ADDED | **Suspicious**: T1110 | `Security.evtx` |
| Security log | 4624 `administrator` from 59.15.116.99 / 80.94.95.238 (type 10) / 193.213.83.126 | ADDED | **Suspicious**: T1078.003, T1021.001 | Recs 19458, 22455, 22917 |
| Security log | 1102 log clear | — | None; log intact | Contiguous record IDs |
| Firewall | `EnableFirewall` 1→0 on all three profiles; ~60 WFP filters removed | CHANGED | Deliberate weakening (T1562.004 if unauthorized) | `Autoruns.txt`, 4950 |
| Defender / WDAC | Smart App Control off; App Control user-mode Audit→Off | CHANGED | Most likely automatic, at the end of the evaluation period | Defender 5007 at 19:28 |
| Defender | Detections, exclusions, RTP | UNCHANGED | No detections; RTP on | `MPDetection`, `MPRegistry` |
| Users | `administrator` profile, BAM entry, per-user services | ADDED | Attacker's first RDP logon | Temp listing, 4697 |
| Sessions | `salam` Active → `administrator` Disc | CHANGED | Attacker's session left disconnected | `QueryUser.txt` |
| Local groups | — | UNCHANGED | Weak config is already in the baseline | `LocalGroups.txt` |
| Scheduled tasks / services | — | UNCHANGED | No persistence | `ScheduledTasks.csv`, Services hive |
| Network | 3389/445/3306/33060 on 0.0.0.0 | UNCHANGED, now exposed | Exposure | `ActiveNetConnections.txt` |
| Prefetch | ROBOCOPY, XCOPY, QUSER, SENSESAMPLEUPLOADER, NGEN | ADDED | Benign: MDE collection and .NET maintenance | Parsed `.pf` files |
| Prefetch | AUDITPOL at 17:03:15 | CHANGED | Unattributed; low confidence | `AUDITPOL.EXE-5C071DAC.pf` |

---

## 7. Containment, eradication and recovery

| UTC | Action | Evidence |
|---|---|---|
| 20:30 | Post-breach investigation package collected | MDE device page → Collect Investigation Package |
| ~21:06 | **Device isolated** in MDE | MDE Isolate Device, comment "Post-Breach Isolation – SA" |
| ~21:14 | NSG `DANGER-Allow-All-Inbound` **deleted** (default DenyAllInBound restored) | NSG now shows only the default rules (DenyAllInBound) |
| ~21:18 | `administrator` account **deleted** | Computer Management → Delete `administrator` |
| ~21:19 | `Guest` removed from Remote Desktop Users / Users and **disabled** | Guest Properties: group memberships removed; "Account is disabled" checked |
| ~21:20 | `salam` password reset | Set Password for `salam` |
| ~21:22 | MySQL `bind-address = 0.0.0.0` removed from `my.ini` | `my.ini`: `bind-address = 0.0.0.0` flagged for removal |
| 21:26–21:27 | MySQL `root@'%'` password rotated, then **dropped**; only `root@localhost` left | MySQL Workbench: `ALTER USER root@'%'`, then `DROP USER root@'%'`; only `root@localhost` remains |
| 21:30 | `lnp_corp` dropped and **restored** from the import script | MySQL Workbench: `DROP DATABASE lnp_corp`, then re-import script |
| ~21:33 | Windows Firewall **re-enabled** on all profiles | wf.msc: Domain, Private and Public profiles On, inbound blocked |
| ~21:34 | Defender full scan started (earlier quick scan: 0 threats) | Windows Security: last quick scan 0 threats; full scan selected |

**Response metrics (RDP breach):**

| Metric | Value |
|---|---|
| Time to compromise (brute force start → success) | **1 m 47 s** |
| Time to detect (success → incident created) | **5 m 36 s** |
| Attacker RDP logon after the incident was created | +21 min |
| Time to contain (incident → isolation) | **~5 h 03 m**. Deliberate in a honeypot (the attacker was allowed to stay). In production this would be a major gap |

---

## 8. Indicators of compromise

| Type | Value | Context |
|---|---|---|
| IPv4 | `59.15.116.99` | Windows brute force (1,141) → `administrator` logon |
| IPv4 | `80.94.95.238` | **RDP interactive logon** as `administrator` |
| IPv4 | `193.213.83.126` | `administrator` credential check |
| IPv4 | `45.8.17.25` | **MySQL root → dump, drop, ransom note** |
| IPv4 | `77.90.185.30` | MySQL root logins ×3 (`root`/`admin`/`sa` checker) |
| IPv4 | `93.174.93.12` | First MySQL root login (06:58) |
| IPv4 | `46.245.99.226`, `94.26.68.55` | Windows username spraying |
| IPv4 | `173.255.214.88`, `45.156.128.76` | Single Windows logon attempts |
| Hostname | `WIN-7OS71AQBILK`, `PC-C4W9W34` | Attacker workstation names |
| DB artifact | Table `RECOVER_YOUR_DATA_info`; string `Saved file name: world.sql` | Ransom note |
| Account | `administrator` (SID `…-1000`), `Guest`, MySQL `root@'%'` | Compromised or targeted accounts |

---

## 9. MITRE ATT&CK mapping

| Tactic | Technique | Evidence |
|---|---|---|
| Reconnaissance / Credential Access | T1110.001 Password Guessing; T1110.003 Password Spraying | 4625 floods; MySQL root/admin/sa attempts |
| Initial Access / Persistence | T1078.003 Valid Accounts: Local | `administrator`, MySQL `root` |
| Lateral Movement / Initial Access | T1021.001 Remote Desktop Protocol | Type 10 from 80.94.95.238 |
| Collection | T1005 Data from Local System (database dump) | mysqldump `SQL_NO_CACHE` queries |
| Exfiltration | Over the existing MySQL session (closest: T1041) | Dump preceded the drops; note says `world.sql` saved |
| Impact | T1485 Data Destruction; T1657 Financial Theft (extortion) | `DROP TABLE` ×3; `RECOVER_YOUR_DATA_info` |
| Defense Evasion (setup) | T1562.004 Disable or Modify System Firewall | 4950, as designed |

---

## 10. Gaps and next steps

- **Process activity in the RDP session.** The package's Security log has no command-line 4688 events. However, `DeviceProcessEvents` exists in Defender (1,060 events in 24 h). **Export `DeviceProcessEvents`, `DeviceFileEvents` and `DeviceRegistryEvents` for `administrator`, 16:24–16:30**, to confirm nothing ran.

- **Full MySQL query log.** Export `MySQLAudit_CL` from 05:12 to 21:30 to confirm:
  - what 93.174.93.12 and 77.90.185.30 did after logging in;
  - whether `lnp_corp` was read.
- **MySQL Sentinel rule outcome.** The rule was deployed (suppression 1 day), but the evidence doesn't show its incident. Check Sentinel for a "Cyber-Defense-Final-MySQL" incident around 06:58 or 14:02.
- **`world` sample database.** It was not restored in the recovery screenshots.
- **Firewall flow log.** `pfirewall.log` was absent, and there are no TerminalServices logs in the package.
- **Unattributed AUDITPOL run** at 17:03:15.

---

## Appendix: Analysis method

- Both MDE packages were extracted, and the registry exports, CSVs and text outputs were diffed.
- `Security.evtx`, plus `System`/`Application.evtx` recovered from `MPSupportFiles.cab` (MSZIP), were parsed with [python-evtx](https://github.com/williballenthin/python-evtx).
- Prefetch files (compressed with Xpress Huffman, the "MAM" format) were decompressed with [dissect.util](https://github.com/fox-it/dissect.util) and parsed for run times and referenced files.
- Defender configuration and detections came from `MPRegistry.txt`, `MPOperationalEvents.txt` and `MPDetection-*.log`.
- IOCs were searched for across every artifact in both packages; all of them appear only after the baseline.
- Cloud-side evidence (Sentinel, Defender XDR advanced hunting, Azure NSG) and on-host remediation were captured as screenshots. Portal timestamps shown in EDT (UTC−4) were converted to UTC.
