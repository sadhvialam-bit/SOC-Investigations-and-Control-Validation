# GRC Assessment: Honeypot Breach of CORP-NA01-BROCAD (RDP Account Takeover and MySQL Extortion)

**Type:** Post-incident control assessment
**Scope:** One Azure-hosted Windows 11 VM running MySQL 8.0, plus its identity, network, configuration, logging, detection and data-protection controls
**Incident date:** 2026-10-05 (UTC)
**Supporting evidence:** [Technical DFIR report](README.md) · portal and on-host screenshots captured during the exercise
**Frameworks referenced:** NIST CSF 2.0 · NIST SP 800-53 Rev. 5 · CIS Controls v8 · ISO/IEC 27001:2022 Annex A

> **Context and assumption.** This VM was a **deliberately weakened honeypot** built for a cyber-range capstone. Several "failures" below were intentional. For this assessment the VM is **treated as if it were a production asset**, so each finding shows what the same configuration would mean in a real environment. Where a control was weakened on purpose, the finding says so.

---

## 1. Executive summary

Once exposed to the internet, the VM was breached through **two independent routes** within one day:

1. **MySQL extortion.** A remotely reachable `root` account with the password `root` was logged into from three IPs. One of them (**45.8.17.25**) **dumped and dropped a database and left a ransom note** (`RECOVER_YOUR_DATA_info`). This is a real **integrity and availability impact**, and possibly confidentiality too.
2. **RDP account takeover.** A local admin account (`administrator`) was brute-forced in **under 2 minutes**. A **second IP** then used the password for an **interactive RDP session**.

**What worked:** telemetry was set up before exposure, and the Sentinel detection fired **5 m 36 s** after the RDP-side compromise. Containment (isolation) and recovery were carried out and documented.

**What failed:** preventive controls were absent at every layer (network, host firewall, authentication, database configuration). The alert was then left **unassigned**, so the attacker logged in over RDP **21 minutes after** the incident was created, and isolation came **~5 hours** later.

| # | Control area | Result |
|---|---|---|
| 1 | Network boundary (NSG) | ❌ Allow-all inbound rule |
| 2 | Host firewall | ❌ Disabled, no change record |
| 3 | Privileged account management | ❌ Ad hoc admin with a weak password, no MFA |
| 4 | Default accounts | ❌ Guest enabled with RDP rights |
| 5 | Database authentication and exposure | ❌ `root@'%'` / `root`, bound to 0.0.0.0 |
| 6 | Data protection / backup | ⚠️ Partial: one schema restored from a script, sample DB lost |
| 7 | Logging | ✅ MySQL audit, Sentinel and MDE in place · ⚠️ local command-line auditing missing |
| 8 | Detection | ✅ Rule fired in 5.6 min |
| 9 | Response | ❌ Incident unassigned; containment took ~5 h |

**Overall inherent risk: Critical (realized).** If the six P1 actions are applied (five of them already done), residual risk drops to **Low**.

---

## 2. Methodology

1. **Baseline comparison:** pre- and post-incident MDE investigation packages were diffed to find configuration drift.
2. **Cloud evidence review:** Sentinel incidents, Defender XDR advanced hunting (`DeviceLogonEvents`, `MySQLAudit_CL`, `NTANetAnalytics`, `DeviceProcessEvents`), and Azure NSG configuration.
3. **Control testing:** each finding is tied to a specific artifact or screenshot.
4. **Framework mapping:** NIST CSF 2.0, NIST 800-53 Rev. 5, CIS Controls v8, ISO 27001:2022 Annex A.
5. **Risk rating:** 5 × 5 likelihood × impact. 20–25 Critical, 12–19 High, 6–11 Medium, 1–5 Low.

---

## 3. Controls that worked

Credit is due here. These controls are why the incident could be reconstructed at all.

| Control | Evidence | Framework |
|---|---|---|
| Centralized MySQL audit logging (general log → AMA → `MySQLAudit_CL`) set up **before** exposure | DCR: Custom Text Logs, `mysql_general.log` → `MySQLAudit_CL` | AU-2, AU-12 · CIS 8.2 · A.8.15 |
| Detection rules written and armed before exposure (VM logon, MySQL logon) | Rule logic: `DeviceLogonEvents` → LogonSuccess for `administrator`/`guest`, Host + IP entities, 10-min schedule | SI-4 · CIS 8.11 · A.8.16 · DE.CM-09 |
| Detection fired in 5 m 36 s (incident 230018) | Incident 230018: Medium, Active, Unassigned, Unclassified; first activity 15:57:22 UTC; created 16:02:58 UTC; entities `corp-na01-broca` and 59.15.116.99 | DE.AE-02 |
| Before and after forensic snapshots (MDE investigation packages) | MDE device page → Collect Investigation Package | IR-4 · A.5.28 |
| Outbound egress restricted at tenant level; only denied NTP flows seen, no C2 / mining | `NTANetAnalytics`: only denied outbound flows are UDP 123 (NTP) to Azure public | SC-7(5) · CIS 13 · A.8.20 |
| Endpoint isolation available and used | MDE Isolate Device, comment "Post-Breach Isolation – SA" | IR-4 · RS.MI-01 |
| Defender AV running with RTP on; no detections or exclusions | MDE package `MPRegistry.txt` | SI-3 · CIS 10.1 · A.8.7 |

---

## 4. Findings and control-gap analysis

### F-01: Inbound network boundary fully open
| | |
|---|---|
| **Severity** | Critical *(intentional in the lab)* |
| **Observation** | NSG rule `DANGER-Allow-All-Inbound` (priority 100, Any/Any/Any) exposed RDP 3389, SMB 445 and MySQL 3306/33060 to the internet. |
| **Evidence** | NSG `CORP-NA01-BROCAD-nsg`: priority 100 `DANGER-Allow-All-Inbound` (Any/Any/Any → Allow), public IP 104.209.158.190 |
| **Effect** | Precondition for both breaches; 9 attacking IPs reached the host within hours. |
| **Root cause** | No Azure Policy blocking internet-sourced management ports; no Bastion or JIT standard. |
| **Mappings** | CSF PR.IR-01 · 800-53 SC-7, AC-17, CM-7 · CIS 4.4, 12.2 · ISO A.8.20, A.8.22 |
| **Status** | ✅ Rule deleted; NSG now shows only the default rules (DenyAllInBound) |

### F-02: Host firewall disabled outside change control
| | |
|---|---|
| **Severity** | High *(intentional in the lab)* |
| **Observation** | The Windows Firewall was turned off for all three profiles at 05:55:35 through `wf.msc`, with no change record. This removed the second layer of defense behind the NSG. |
| **Evidence** | Security 4950 ×3; registry `EnableFirewall` 1→0 (MDE package diff) |
| **Root cause** | Firewall state not enforced by policy; no drift alerting on 4950/4946. |
| **Mappings** | CSF PR.PS-01 · 800-53 CM-3, CM-6, SC-7 · CIS 4.1, 4.5 · ISO A.8.9, A.8.32 |
| **Status** | ✅ Re-enabled on all profiles (wf.msc: Domain, Private and Public On, inbound blocked) |

### F-03: Privileged local account with weak authentication
| | |
|---|---|
| **Severity** | Critical |
| **Observation** | `administrator` was created ad hoc and added to Administrators and Remote Desktop Users, with "password never expires" and a guessable password. It was guessed after 228 wrong attempts, then used for RDP from a second IP. |
| **Evidence** | `DeviceLogonEvents`: repeated LogonFailed from 59.15.116.99, then LogonSuccess (Network) at 15:57 UTC; Security 4720/4732 (baseline); 4624 recs 19458, 22455 |
| **Root cause** | No approval process for privileged accounts; `MinPasswordLength: 0` (Security 4739); no MFA for remote admin access; a predictable account name. |
| **Mappings** | CSF PR.AA-01/03/05 · 800-53 AC-2, AC-6(5), IA-2(1), IA-5(1) · CIS 5.2, 5.4, 6.5 · ISO A.5.16–5.18, A.8.2, A.8.5 |
| **Status** | ✅ `administrator` deleted (Computer Management) · ✅ `salam` password reset · ⏳ MFA / LAPS still to do |

### F-04: Default Guest account enabled with remote access
| | |
|---|---|
| **Severity** | High |
| **Observation** | `Guest` was enabled, given a password, and added to Users and Remote Desktop Users. It was targeted from 45.156.128.76. |
| **Root cause** | The hardening baseline doesn't prohibit enabling default accounts; no access review. |
| **Mappings** | CSF PR.AA-05 · 800-53 AC-2(3), CM-6, CM-7 · CIS 4.7, 5.3 · ISO A.5.18, A.8.9 |
| **Status** | ✅ Removed from Remote Desktop Users and Users; "Account is disabled" checked |

### F-05: Database exposed with a default-strength superuser
| | |
|---|---|
| **Severity** | Critical |
| **Observation** | MySQL was bound to `0.0.0.0`, and a remote superuser `root@'%'` used the password `root` with `GRANT ALL … WITH GRANT OPTION`. Three IPs logged in. **45.8.17.25** dumped the `world` schema (mysqldump pattern), **dropped 3 tables** and created the ransom table `RECOVER_YOUR_DATA_info`. |
| **Evidence** | `MySQLAudit_CL` auth parse: `root` LogonSuccess from 93.174.93.12, 77.90.185.30 and 45.8.17.25; `MySQLAudit_CL` queries at 14:10 UTC: mysqldump-style SELECTs, `CREATE TABLE world.RECOVER_YOUR_DATA_info`, ransom INSERT, three `DROP TABLE` statements |
| **Effect** | **Realized impact:** data destroyed (integrity and availability) and probably copied out (confidentiality). |
| **Root cause** | No database hardening standard (no remote root, no password policy, no TLS, no network allow-list); the database port was treated like any other service port. |
| **Mappings** | CSF PR.AA-01, PR.DS-01, PR.PS-01 · 800-53 AC-6, IA-5, CM-6, CM-7, SC-7 · CIS 3.3, 4.7, 5.4, 12.2 · ISO A.8.2, A.8.5, A.8.9, A.8.20 |
| **Status** | ✅ `bind-address = 0.0.0.0` removed from `my.ini` · ✅ `root@'%'` rotated then dropped (MySQL Workbench); only `root@localhost` left |

### F-06: Data protection and recovery only partly in place
| | |
|---|---|
| **Severity** | High |
| **Observation** | `lnp_corp` (fake PII: names, addresses, dates of birth, SSN-format values) was restored from its import script. The **`world` database destroyed by the attacker does not appear to have been restored**, and no backup was taken before exposure, even though the checklist recommended one. Whether `lnp_corp` was read can't yet be ruled out. |
| **Evidence** | MySQL Workbench: `DROP DATABASE lnp_corp`, then re-import script |
| **Effect** | Permanent loss of the `world` data. In production, a possible **PII disclosure** would trigger the breach-notification assessment (e.g. under PIPEDA, GDPR Art. 33, or U.S. state laws). |
| **Root cause** | No backup policy, recovery-point objective (RPO) or restore test for the database; sensitive data stored unencrypted on an internet-reachable host. |
| **Mappings** | CSF PR.DS-01, PR.DS-11, RC.RP-01 · 800-53 CP-9, CP-10, SC-28, IR-6 · CIS 3.11, 11.1–11.4 · ISO A.8.13, A.5.34, A.5.26 |
| **Status** | ✅ `lnp_corp` restored · ⏳ `world` not restored · ⏳ check `MySQLAudit_CL` for any read of `lnp_corp` |

### F-07: Response did not follow detection
| | |
|---|---|
| **Severity** | High *(the delay was partly intentional, since the honeypot let the attacker stay)* |
| **Observation** | Incident 230018 was created at 16:02:58 and was still **Active / Unassigned / Unclassified at 17:08**. The attacker's RDP logon (16:24) and a third-party credential check (17:03) came **after** the alert. Isolation followed at ~21:06 (~5 h). The device showed **21 active alerts / 18 active incidents** at isolation time. |
| **Evidence** | Incident 230018: Medium, Active, Unassigned, Unclassified; first activity 15:57:22 UTC; created 16:02:58 UTC; entities `corp-na01-broca` and 59.15.116.99 |
| **Metrics** | Time to compromise 1 m 47 s · time to detect 5 m 36 s · time to contain ~5 h 03 m |
| **Root cause** | No triage SLA or on-call owner; automation rules didn't include a containment action (e.g. disable the account or isolate the device on "successful logon after brute force"). |
| **Mappings** | CSF DE.AE-02, RS.MA-01/02, RS.MI-01 · 800-53 IR-4, IR-5, IR-8, SI-4(5) · CIS 17.2, 17.4 · ISO A.5.25, A.5.26 |
| **Status** | ✅ Contained (isolation) · ⏳ SLA and automated containment playbook still to do |

### F-08: Account lockout alone did not prevent compromise
| | |
|---|---|
| **Severity** | Medium |
| **Observation** | The lockout policy fired 22 times but only after the password had been guessed. Lockouts against an exposed account also create a denial-of-service risk for the real owner. |
| **Mappings** | CSF PR.AA-03 · 800-53 AC-7 · CIS 6.4 · ISO A.8.5 |

### F-09: Local logging not enough on its own
| | |
|---|---|
| **Severity** | Medium |
| **Observation** | The host's own Security log had no command-line process auditing, and `pfirewall.log` was absent. Cloud-side MDE `DeviceProcessEvents` does exist, so attacker activity *can* be reconstructed if it is exported before retention expires. |
| **Evidence** | `DeviceProcessEvents`: 1,060 events in 24 h for `administrator`/`system` |
| **Root cause** | No logging standard defining required local sources and retention. |
| **Mappings** | CSF PR.PS-04 · 800-53 AU-2, AU-3, AU-11, AU-12 · CIS 8.2, 8.5, 8.10 · ISO A.8.15 |

---

## 5. Risk register entries

| Field | R-2026-001 Remote admin access | R-2026-002 Database extortion |
|---|---|---|
| **Risk statement** | Exposed RDP/NTLM plus a weak local admin with no MFA let an external actor gain admin access to cloud VMs | An exposed DB with a weak remote superuser lets an external actor destroy or steal data and demand ransom |
| **Vulnerabilities** | F-01, F-02, F-03, F-04, F-08 | F-01, F-05, F-06 |
| **Inherent likelihood** | 5 (realized in under 2 min) | 5 (realized; 3 separate actors) |
| **Inherent impact** | 5 (full host control) | 5 (data destroyed; PII possibly exposed) |
| **Inherent risk** | **25, Critical** | **25, Critical** |
| **Treatment** | Mitigate | Mitigate |
| **Target residual** | 1 × 4 = **4, Low** | 1 × 4 = **4, Low** |
| **Owner** | Cloud Infrastructure Lead | Database Owner / Data Steward |

---

## 6. Root-cause analysis (5 Whys)

1. **Why was data destroyed and an admin session gained?** Default or weak credentials on internet-reachable MySQL and RDP were guessed.
2. **Why were the services reachable?** An allow-all NSG rule plus a disabled host firewall, with no policy to block it.
3. **Why did the alert not stop the attacker?** The incident had no owner and no automated containment.
4. **Why were the weak settings allowed?** No enforced hardening baseline for VMs or databases, and no approval process for privileged accounts.
5. **Why wasn't data recoverable?** No backup and restore-testing requirement.

**Underlying cause:** security depended on manual configuration and manual response, with no **policy-as-code guardrails** and no **response playbooks with SLAs**.

---

## 7. Remediation plan and status

| # | Action | Addresses | Priority | Owner (role) | Status | Evidence |
|---|---|---|---|---|---|---|
| 1 | Isolate the compromised host | F-07 | P1 | SOC | ✅ Done (~21:06) | MDE isolation action, comment "Post-Breach Isolation – SA" |
| 2 | Remove the allow-all NSG rule; management ports reachable only through Bastion or JIT | F-01 | P1 | Cloud Infra | ✅ Rule removed · ⏳ Bastion/JIT | NSG shows only default rules |
| 3 | Delete `administrator`, disable `Guest`, reset the remaining admin password | F-03, F-04 | P1 | System Admin | ✅ Done | `administrator` deleted; Guest disabled and removed from groups; `salam` reset |
| 4 | Remove remote MySQL root; bind to localhost; rotate credentials | F-05 | P1 | DBA | ✅ Done | `bind-address` removed; `root@'%'` dropped |
| 5 | Re-enable the host firewall and enforce it through Azure Policy / Intune | F-02 | P1 | Endpoint Eng | ✅ Re-enabled · ⏳ policy enforcement | All three firewall profiles On |
| 6 | Rebuild the VM from a trusted image, or confirm it's clean using `DeviceProcessEvents` | F-09 | P1 | System Admin | ⏳ Scan started; process review open | Quick scan 0 threats; full scan started |
| 7 | Restore all databases from known-good backups; confirm whether PII was accessed | F-06 | P1 | Data Steward | ✅ `lnp_corp` · ⏳ `world`, access review | `lnp_corp` re-imported from script |
| 8 | MFA for all remote admin access; Windows LAPS for local admins | F-03, F-08 | P2 | IAM | ⏳ Open | — |
| 9 | Triage SLA (e.g. Medium ≤ 30 min) plus a playbook that auto-disables the account or isolates the device on "logon success after brute force" | F-07 | P2 | SOC | ⏳ Open | — |
| 10 | Database hardening standard: no remote superuser, password policy, TLS, IP allow-list | F-05 | P2 | DBA / GRC | ⏳ Open | — |
| 11 | Backup policy with RPO/RTO and quarterly restore tests | F-06 | P2 | Data Steward | ⏳ Open | — |
| 12 | Logging standard: 4688 with command line, PowerShell 4104, RDP operational logs, firewall log, retention | F-09 | P3 | Security Eng | ⏳ Open | — |
| 13 | Policy-as-code baseline (CIS Windows + Azure Policy initiative); drift alerts on 4950/4946 | Root cause | P3 | Cloud Infra / GRC | ⏳ Open | — |
| 14 | Quarterly access reviews of local Administrators and Remote Desktop Users | F-03, F-04 | P3 | IAM / GRC | ⏳ Open | — |

---

## 8. Policy and governance gaps

| Gap | Recommended document or control |
|---|---|
| No secure configuration baseline for VMs | **Secure Configuration Standard** (CIS Benchmark, enforced through Azure Policy / Intune) |
| No rule against exposing management or DB ports | **Network Security Standard** ("no management or database ports from the internet") |
| No approval process for privileged accounts | **Privileged Access Management Procedure** |
| Weak authentication | **Authentication Standard** (length, MFA for admin and remote access) |
| No database hardening | **Database Security Standard** |
| No backup requirements | **Backup and Recovery Policy** (RPO/RTO, restore testing) |
| No triage SLA or containment automation | **Incident Response Plan + Account-Compromise Playbook** |
| No breach-notification decision process | **Data Breach Notification Procedure** (PII impact assessment) |

---

## 9. Metrics to track (key risk indicators)

| KRI | Target | Observed in this incident |
|---|---|---|
| VMs with management or DB ports open to the internet | 0% | 100% |
| Privileged accounts protected by MFA | 100% | 0% |
| Mean time to detect (credential compromise) | < 15 min | **5.6 min ✅** |
| Mean time to acknowledge or assign an incident | < 30 min | > 65 min ❌ |
| Mean time to contain | < 1 h | ~5 h ❌ |
| Databases with a tested backup | 100% | 0% |
| Endpoints sending 4688 with command lines to the SIEM | ≥ 95% | 0% (local) |

---

## 10. Lessons learned

- **Detection is not protection.** The alert fired in under 6 minutes, but without an owner or automated containment the attacker still got an RDP session afterwards.
- **Automated attackers hit every exposed service.** The database was breached **before** RDP, by a different set of actors, and the damage there (destroyed data plus a ransom note) was worse than on the host itself.
- **Backups are part of security.** Only the schema with a rebuild script came back; the other was lost.
- **Building telemetry first paid off.** Because logging and detections existed before exposure, every step of both breaches could be reconstructed and evidenced.
- **Comparing two snapshots is a useful audit technique.** Diffing the pre- and post-incident packages showed configuration drift that a single review would have missed.
