# Evidence request list (PBC) - Quillfield Systems Inc. (fictional)

> **Simulated scenario** for a self-directed learning and portfolio project. No real company, client or audit. Statuses show the result of the simulated readiness dry run.

A "provided by client" (PBC) list is what the service auditor sends before fieldwork. This version was used as a **dry run**: each request was issued to the control owner as if it came from the auditor, so that missing or weak evidence shows up now rather than during the audit.

| | |
| --- | --- |
| Issued (simulated) | September 28, 2026 |
| Due | October 7, 2026 |
| Type I as-of date (planned) | March 31, 2027 |
| Control IDs | See [control-matrix.md](control-matrix.md) |
| Gap IDs | See [gap-assessment.md](gap-assessment.md) |

## Guidance for control owners

1. **Show where it came from.** For any system listing (users, roles, devices, changes), provide the export *and* a screenshot or note showing the query or report path, the parameters, the date and time it was run, and who ran it. Auditors use this to rely on the completeness and accuracy of the population.
2. **Type I vs. Type II.** For the Type I, the auditor tests design and implementation as of the as-of date: the current configuration, the current population and at least one instance of each recurring control (for example, one completed quarterly access review). Where a request below gives a period, it is for the readiness dry run, to check that the control actually runs. A later Type II would need evidence across the whole review period.
3. **No edited evidence.** Provide system screenshots with the URL and date visible, or native exports. Do not retype data into a spreadsheet.
4. **Upload location:** the "SOC 2 Type I - PBC" SharePoint library (internal only, no external sharing), one folder per request ID.

Status key: **Provided** - **Provided, exceptions noted** (evidence exists but shows a gap) - **Partial** (some items missing) - **Not available** (control does not exist yet).

## Governance, risk and monitoring (CC1-CC5)

| Req | Controls | Request | As of / period | Format and source | Provided by | Dry-run status |
| --- | --- | --- | --- | --- | --- | --- |
| E-01 | RISK-02, AC-10, CONF-01 | Draft system description, architecture diagram and data flow diagram for the Quillfield AP platform, including subservice organizations and in-scope locations | Current | PDF or diagram file | CTO | Partial - architecture diagram only; no system description yet |
| E-02 | GOV-01 | All information security policies with version history, approver and approval date, and the page showing where staff can read them | Current | Confluence export | Director, IT & Security | Provided, exceptions noted (G-01) |
| E-03 | GOV-04 | Org chart and job descriptions for Director, IT & Security; Security Engineer; IT Administrator; DevOps Lead | As of date | BambooHR export; PDF | People Operations Manager | Provided |
| E-04 | GOV-03 | Agenda and minutes of leadership meetings where security or compliance was discussed; most recent board pack | Last 2 quarters | PDF | CTO | Provided, exceptions noted (G-01) |
| E-05 | GOV-05, VND-02 | MSA and DPA templates, public trust page, subprocessor list, and evidence that security@ is monitored | Current | PDF; screenshots | Controller | Provided |
| E-06 | GOV-02, HR-01 | List of new hires in the period. For a sample (selected by the auditor): signed offer letter or contractor agreement with confidentiality clause, code of conduct and AUP acknowledgement, background check completion date | Apr 1 - Sep 30, 2026 | BambooHR report; signed documents | People Operations Manager | Provided |
| E-07 | HR-02 | Training completion report by person (employees and contractors) and the most recent phishing simulation results | Calendar 2026 | Training platform export | Security Engineer | Provided, exceptions noted (G-02) |
| E-08 | RISK-01 | Most recent risk assessment, risk register and evidence of leadership review | Most recent | PDF; spreadsheet | Director, IT & Security | Not available (G-01) |
| E-09 | RISK-02, AC-12 | Asset inventories: Azure Resource Graph export of production resources, Intune device list, SaaS application register, Defender for Cloud Apps discovered apps report | As of date | CSV exports | IT Administrator | Partial - no SaaS register (G-08) |
| E-10 | MON-01 | Control self-assessment results and deficiency tracker with status and dates | Most recent quarter | Jira or spreadsheet | Director, IT & Security | Not available (G-01) |
| E-11 | MON-02 | Most recent penetration test report, scope and engagement letter, Jira tickets for each finding, retest letter | Most recent test | PDF; Jira export | Director, IT & Security | Provided, exceptions noted (G-09) |

## Logical and physical access (CC6)

| Req | Controls | Request | As of / period | Format and source | Provided by | Dry-run status |
| --- | --- | --- | --- | --- | --- | --- |
| E-12 | AC-01, AC-04 | Entra ID export of all enabled user accounts (UPN, account type, created date, last sign-in, department). Active employee list from BambooHR and the contractor roster for the same date | As of date | Entra admin center or Graph export; BambooHR report | IT Administrator; People Operations Manager | Provided, exceptions noted (G-04) |
| E-13 | AC-01 | List of in-scope applications showing SSO configuration; list of any local or shared accounts and their owners | As of date | Entra enterprise apps export; screenshots | IT Administrator | Provided, exceptions noted (G-04) |
| E-14 | AC-02, AC-12 | All Conditional Access policies and the membership of every excluded group | As of date | JSON export; screenshots | Director, IT & Security | Provided, exceptions noted (G-06) |
| E-15 | AC-03 | Population of access grants to in-scope systems (from Entra and GitHub audit logs). For a sample: the request ticket with approval | Apr 1 - Sep 30, 2026 | Audit log export; JSM tickets | IT Administrator | Provided, exceptions noted (G-05) |
| E-16 | AC-04 | Terminations list (employees and contractors) with termination dates, plus Entra audit log disable events and GitHub org removal events for the same people | Apr 1 - Sep 30, 2026 | BambooHR report; Entra audit log; GitHub audit log | IT Administrator | Provided, exceptions noted (G-04) |
| E-17 | AC-05 | The most recent quarterly user access review for each in-scope system: population with extraction evidence, completeness check, reviewer sign-off, and removal tickets | Most recent quarter | Review workbook; Jira tickets | Director, IT & Security | Not available (G-03) |
| E-18 | AC-06, AC-05 | Entra directory role assignments (active and eligible), PIM settings for privileged roles, Azure RBAC assignments on the production subscription | As of date | Entra/PIM export; `az role assignment list` output | Director, IT & Security | Provided, exceptions noted (G-06) |
| E-19 | AC-06 | App registrations and service principals with credential type, expiry date and owner | As of date | Entra export or Graph query | Director, IT & Security | Provided, exceptions noted (G-06) |
| E-20 | AC-07 | SoD matrix; internal admin console roles and permissions; log of payee bank-detail edits with who made and who approved each edit | Jul 1 - Sep 30, 2026 | Spreadsheet; app audit table export | VP Engineering | Partial - no SoD matrix; edit log provided (G-07) |
| E-21 | AC-07, CHG-03 | GitHub "production" environment protection settings and deployment history showing triggering user and approver | Jul 1 - Sep 30, 2026 | Screenshot; GitHub API export | DevOps Lead | Provided, exceptions noted (G-07) |
| E-22 | AC-08, VND-03 | Microsoft Azure SOC 2 Type II report and Quillfield's review of it; office badge access user list | Most recent report; as of date | PDF; badge system export | IT Administrator | Partial - badge list provided; no SOC report review (G-14) |
| E-23 | AC-09 | List of devices retired or reassigned, with Intune wipe log entry or certificate of destruction for each | Calendar 2026 | Intune export; vendor certificates | IT Administrator | Provided |
| E-24 | AC-10 | NSG rules for production, private endpoint configuration for Azure SQL and Storage, Front Door WAF policy and mode, most recent Tenable external scan | As of date | Exports; screenshots | DevOps Lead | Provided (staging RDP observation closed Oct 7) |
| E-25 | AC-11 | Minimum TLS settings, Azure SQL TDE status, Storage encryption with customer-managed key, Key Vault access configuration | As of date | Screenshots; Azure Policy compliance | DevOps Lead | Provided |
| E-26 | AC-12 | Intune device compliance report and Defender for Endpoint device inventory | As of date | CSV exports | IT Administrator | Provided, exceptions noted (G-08) |

## System operations (CC7)

| Req | Controls | Request | As of / period | Format and source | Provided by | Dry-run status |
| --- | --- | --- | --- | --- | --- | --- |
| E-27 | OPS-01, CHG-04 | Vulnerability remediation SLA, scan schedules, vulnerability ageing report (Tenable and Defender for Cloud), secure score history, exception register | As of date; last 90 days | Tenable and Defender exports | Security Engineer | Partial - no SLA or exception register (G-09) |
| E-28 | OPS-02 | Sentinel data connector status and Log Analytics workspace retention settings | As of date | Screenshots | Security Engineer | Provided, exceptions noted (G-10) |
| E-29 | OPS-03 | Sentinel incident export with created, acknowledged and closed times, closure reason and comments; list of enabled analytics rules; on-call schedule | Jul 1 - Sep 30, 2026 | Sentinel export | Security Engineer | Provided, exceptions noted (G-10) |
| E-30 | OPS-04 | Approved incident response plan, most recent tabletop report, incident tickets for the period, post-incident reviews, breach record log | Calendar 2026 | PDF; Jira export | Director, IT & Security | Partial - draft plan and one incident timeline only (G-11) |
| E-31 | OPS-05 | Azure SQL backup retention (PITR and LTR) and backup storage redundancy; Blob soft delete and versioning settings; most recent restore test record | As of date | Screenshots; test record | DevOps Lead | Partial - no restore test (G-12) |

## Change management (CC8)

| Req | Controls | Request | As of / period | Format and source | Provided by | Dry-run status |
| --- | --- | --- | --- | --- | --- | --- |
| E-32 | CHG-01, CHG-02 | Population of pull requests merged to the default branch of each production repository and of production deployments. For a sample: the PR showing reviewer and status checks, and the linked Jira ticket | Jul 1 - Sep 30, 2026 | GitHub API export; Jira | DevOps Lead | Provided, exceptions noted (G-13) |
| E-33 | CHG-02 | Branch protection or ruleset configuration for each production repository and the list of bypass actors | As of date | JSON export; screenshots | DevOps Lead | Provided, exceptions noted (G-13) |
| E-34 | CHG-03 | Azure Activity log report of write operations in the production subscription by human users (not the pipeline identity) and evidence of review | Last 30 days | KQL query and output | DevOps Lead | Provided, exceptions noted (G-13) |
| E-35 | CHG-04 | GitHub Advanced Security settings (code scanning, Dependabot, secret scanning, push protection) per production repo; alert summary | As of date | Screenshots; export | VP Engineering | Provided |

## Risk mitigation and vendors (CC9)

| Req | Controls | Request | As of / period | Format and source | Provided by | Dry-run status |
| --- | --- | --- | --- | --- | --- | --- |
| E-36 | BCP-01 | BC/DR plan with RTO and RPO, most recent DR test report, cyber insurance certificate | Most recent | PDF | CTO | Partial - insurance certificate only (G-12) |
| E-37 | VND-01 | Vendor inventory with security tier, owner and data types; reconciliation to the NetSuite active vendor master and corporate card spend | As of date | Spreadsheet; NetSuite export | Controller | Partial - vendor master only, no tiers (G-14) |
| E-38 | VND-02 | For each Tier 1 and Tier 2 vendor onboarded or renewed in the period: due diligence record, signed contract and DPA | Calendar 2026 | PDF | Director, IT & Security | Partial - 3 of 5 subprocessor DPAs; no due diligence records (G-14) |
| E-39 | VND-03 | Current SOC 2 reports (and bridge letters) for Microsoft Azure, GitHub, Zendesk, Twilio SendGrid and Atlassian, with Quillfield's review memo and CUEC mapping | Most recent reports | PDF | Director, IT & Security | Not available (G-14) |

## Confidentiality (C1)

| Req | Controls | Request | As of / period | Format and source | Provided by | Dry-run status |
| --- | --- | --- | --- | --- | --- | --- |
| E-40 | CONF-01, CONF-04 | Approved data classification standard; Purview sensitivity label and DLP policy configuration (including mode) and DLP incident report | As of date | PDF; screenshots | Director, IT & Security | Provided, exceptions noted (G-15) |
| E-41 | CONF-02 | List of customers terminated in the last 24 months with termination dates; deletion ticket, verification query and confirmation letter for each | Oct 2024 - Sep 2026 | CRM export; Jira; letters | VP Engineering | Provided, exceptions noted (G-15) |
| E-42 | CONF-03 | Procedure for refreshing non-production data; masking script or synthetic data approach; list of accounts with access to the staging database | As of date | Pipeline file; SQL login list | VP Engineering | Provided, exceptions noted (G-15) |
| E-43 | CONF-04 | SharePoint and OneDrive external sharing settings; report of active anonymous ("Anyone") links; Azure Policy compliance for Storage public access | As of date | SharePoint admin report; Azure Policy | IT Administrator | Provided, exceptions noted (G-15) |

## Dry-run result

| Status | Count |
| --- | ---: |
| Provided | 7 |
| Provided, exceptions noted | 22 |
| Partial | 10 |
| Not available | 4 |
| **Total requests** | **43** |

43 requests cover all 40 controls in the matrix. The 4 "Not available" items (E-08 risk assessment, E-10 control self-assessment, E-17 user access reviews, E-39 vendor SOC report reviews) are evidence an auditor would expect to see early, and each matches a Missing control in the matrix. Only 7 of 43 requests came back clean, which is consistent with the 49% readiness score.
