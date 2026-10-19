# Gap assessment - Quillfield Systems Inc. (fictional)

> **Simulated scenario.** Quillfield Systems Inc., its people, systems, numbers and evidence are invented for a self-directed learning and portfolio project. No real company, client, audit or evidence is represented. "Reviewed" below means reviewed in the simulation.

| | |
| --- | --- |
| Assessment type | SOC 2 Type I readiness (pre-audit gap assessment) |
| Criteria | AICPA 2017 Trust Services Criteria: Security (CC1-CC9) and Confidentiality (C1.1-C1.2) |
| Fieldwork (simulated) | September 28 - October 16, 2026 |
| Status as of | October 16, 2026 |
| Target Type I "as of" date | March 31, 2027 |
| Related files | [Control matrix](control-matrix.md) - [Risk register](risk-register.md) - [Evidence request list](evidence-request-list.md) |

## 1. How to read this document

Each gap uses the standard audit finding format:

- **Criteria** - what the control should do (TSC reference and the Quillfield control in the matrix).
- **Condition** - what the evidence showed.
- **Cause** - why the gap exists. Fixing the cause matters more than fixing the one instance.
- **Effect** - the risk it creates and how an auditor would likely see it.
- **Recommendation** - the fix, with owner and target date (matching the [roadmap](README.md#remediation-roadmap)).

Priority: **High** = likely to stop a clean Type I opinion or exposes customer data now; **Medium** = needs fixing before the as-of date but there is a partial control in place.

Evidence IDs (E-xx) refer to the [evidence request list](evidence-request-list.md). File names are simulated.

## 2. Gap summary

| Gap | Title | Controls | Risks | Priority | Target |
| --- | --- | --- | --- | --- | --- |
| [G-01](#g-01-governance-risk-assessment-and-monitoring-are-not-formalized) | Governance, risk assessment and monitoring not formalized | GOV-01, GOV-03, RISK-01, MON-01 | R-15 | High | 2027-01-22 |
| [G-02](#g-02-security-awareness-training-does-not-reach-everyone) | Security awareness training does not reach everyone | HR-02 | R-02 | Medium | 2026-12-23 |
| [G-03](#g-03-no-user-access-reviews) | No user access reviews | AC-05 | R-01, R-03, R-11 | High | 2026-12-18 |
| [G-04](#g-04-leavers-contractors-and-generic-accounts-remain-active) | Leavers, contractors and generic accounts remain active | AC-01, AC-04 | R-01 | High | 2026-12-23 |
| [G-05](#g-05-access-approvals-are-not-consistently-documented) | Access approvals not consistently documented | AC-03 | R-01 | Medium | 2026-12-23 |
| [G-06](#g-06-mfa-exclusions-and-standing-privileged-access) | MFA exclusions and standing privileged access | AC-02, AC-06 | R-02, R-03 | High | 2026-12-18 |
| [G-07](#g-07-segregation-of-duties-is-not-defined-or-enforced) | Segregation of duties not defined or enforced | AC-07 | R-04, R-05 | High | 2027-01-22 |
| [G-08](#g-08-incomplete-saas-inventory-and-unmanaged-contractor-devices) | Incomplete SaaS inventory and unmanaged contractor devices | RISK-02, AC-12 | R-13, R-14 | Medium | 2027-01-22 |
| [G-09](#g-09-vulnerabilities-are-found-but-not-fixed-on-time) | Vulnerabilities found but not fixed on time | OPS-01, MON-02 | R-06 | High | 2027-01-22 |
| [G-10](#g-10-logging-gaps-and-slow-alert-triage) | Logging gaps and slow alert triage | OPS-02, OPS-03 | R-04, R-07 | Medium | 2027-01-22 |
| [G-11](#g-11-incident-response-plan-is-untested-and-misses-pipeda-steps) | IR plan untested and misses PIPEDA steps | OPS-04 | R-08 | Medium | 2026-12-18 |
| [G-12](#g-12-backups-never-restored-no-bcdr-plan) | Backups never restored; no BC/DR plan | OPS-05, BCP-01 | R-09 | Medium | 2027-01-22 |
| [G-13](#g-13-changes-can-reach-production-without-review) | Changes can reach production without review | CHG-01, CHG-02, CHG-03 | R-05 | High | 2026-12-23 |
| [G-14](#g-14-no-vendor-risk-management-process) | No vendor risk management process | VND-01, VND-02, VND-03 | R-10, R-11 | High | 2027-01-22 |
| [G-15](#g-15-customer-data-lifecycle-is-not-controlled) | Customer data lifecycle not controlled | CONF-01, CONF-02, CONF-03, CONF-04 | R-11, R-12, R-13 | High | 2027-01-22 |

Every control rated Partial or Missing in the [control matrix](control-matrix.md) maps to one of these 15 gaps.

## 3. What is working

Worth stating, because a readiness report that only lists problems is less useful to the people who have to fix things:

- **Cloud architecture is sound.** Private endpoints, default-deny NSGs, Front Door WAF and encryption with customer-managed keys (AC-10, AC-11). The open RDP port on a staging jump host was closed during fieldwork.
- **Deployment pipeline design is good.** GitHub Actions deploys with OIDC federation (no stored cloud secrets), and code scanning, Dependabot and secret scanning are on for all production repos (CHG-03 design, CHG-04).
- **The security tooling is already licensed.** Entra ID P2 (PIM), Sentinel, Defender XDR, Defender for Cloud, Purview and Tenable are all in place. Most gaps are about configuring, using and evidencing these tools, not buying new ones.
- **HR controls at hire work.** 10 of 10 sampled hires had background checks and signed agreements before their start date (GOV-02, HR-01).

## 4. Gaps by domain

### Control environment, risk assessment and monitoring (CC1-CC5)

#### G-01 Governance, risk assessment and monitoring are not formalized

**Priority:** High - **Controls:** GOV-01, GOV-03, RISK-01, MON-01 - **Risk:** R-15 - **Owner:** CTO, with Director, IT & Security

- **Criteria:** CC1.2 and CC2.2 (oversight and internal communication), CC3.1-CC3.4 (risk assessment, including fraud and change), CC4.1-CC4.2 (monitoring and communicating deficiencies), CC5.3 (policies and procedures).
- **Condition:** 14 security policies exist in Confluence as 2024 template drafts. 3 were approved by the CTO in March 2024; 11 were never approved; none have been reviewed since. Leadership meeting minutes for Q2-Q3 2026 contain no security agenda items, and the June 2026 board pack mentions SOC 2 only as a sales milestone. There is no risk assessment, risk register or control self-assessment.
- **Evidence reviewed (simulated):** `confluence_policy_space_export_2026-09-29.pdf` (E-02), `leadership_minutes_Q2-Q3_2026.pdf` and `board_pack_2026-06.pdf` (E-04); no response for E-08 and E-10.
- **Cause:** Security has been owned by a two-person team (Director, IT & Security and one Security Engineer) focused on operations. Nobody owns compliance, and leadership has treated SOC 2 as a sales deliverable rather than an operating commitment.
- **Effect:** CC1-CC5 are tested largely through documents and minutes. Without approved policies, a dated risk assessment and evidence of oversight, the auditor has nothing to test for these criteria, and the system description's claims about governance would not be supported.
- **Recommendation:**
  1. Approve the core policies first (access control, change management, vendor risk; drafts in [`policies/`](policies/)), then the remaining set, each with a named owner and annual review date.
  2. Add a 30-minute quarterly security and compliance item to the leadership meeting, with minutes and an action log. First session in December 2026, using this report and the risk register.
  3. Run a half-day risk workshop with the CTO, VP Engineering, Controller and Director, IT & Security to challenge and accept the [draft risk register](risk-register.md). Include fraud risk explicitly (see G-07).
  4. Track every gap in this report in one Jira project, and run the first quarterly control self-assessment in January 2027.

#### G-02 Security awareness training does not reach everyone

**Priority:** Medium - **Control:** HR-02 - **Risk:** R-02 - **Owner:** Security Engineer

- **Criteria:** CC1.4 and CC2.2.
- **Condition:** 2026 annual training completion is 71% (96 of 135 workforce members). The 14 contractors are not enrolled in the training platform. The August 2026 phishing simulation had a 14% click rate. Nobody follows up on non-completion.
- **Evidence reviewed (simulated):** `training_completion_2026-09-30.csv`, `phishing_campaign_2026-08.pdf` (E-07).
- **Cause:** Training is assigned from the HR system, and contractors are not in it (the same cause as part of G-04).
- **Effect:** An auditor would expect training evidence for all in-scope personnel. The May 2026 mailbox compromise started with a phishing email.
- **Recommendation:** Enrol contractors through the contractor roster created under G-04; set a 30-day completion deadline with manager escalation at day 15; report completion at the quarterly leadership review.

### Logical and physical access (CC6)

#### G-03 No user access reviews

**Priority:** High - **Control:** AC-05 - **Risks:** R-01, R-03, R-11 - **Owner:** Director, IT & Security (coordinator); system owners (reviewers)

- **Criteria:** CC6.2 and CC6.3 (authorizing, modifying and removing access; least privilege).
- **Condition:** No user access review was performed in 2026 for any in-scope system. The only prior review (Azure RBAC, November 2025) is a spreadsheet with no reviewer name, no date of sign-off and no evidence that the four changes it lists were made.
- **Evidence reviewed (simulated):** `azure_rbac_review_2025-11.xlsx` (E-17); no review evidence for Entra roles, GitHub, Azure SQL, Zendesk or the admin console.
- **Cause:** No control owner, no calendar, and no defined method. The team saw the review as a one-off clean-up rather than a recurring control.
- **Effect:** This is one of the controls auditors test most closely. Many of the conditions in G-04 and G-06 (leavers still enabled, standing privileged access, former contractors) would have been caught by a working review.
- **Recommendation:** Perform the first quarterly review in Q4 2026 and the second in Q1 2027 so that a completed cycle exists before the as-of date. Each review should include:
  1. A system-generated listing for each system, saved with the extraction date, the query or export path and who ran it (this is what makes the population complete and accurate).
  2. A completeness check against the source: for example, the Entra user count reconciled to BambooHR plus the contractor roster.
  3. Certification by the system owner, not by IT, of each user's access level: keep, change or remove.
  4. Removal tickets closed within 5 business days, with the closed ticket attached to the review.
  5. Sign-off and retention in a single folder per quarter.

  The [Access Control Policy](policies/access-control-policy.md#5-user-access-reviews) sets out the procedure.

#### G-04 Leavers, contractors and generic accounts remain active

**Priority:** High - **Controls:** AC-01, AC-04 - **Risk:** R-01 - **Owner:** IT Administrator

- **Criteria:** CC6.1 (unique identification) and CC6.2 (removing access when no longer authorized).
- **Condition:**
  - The Entra ID export as of October 2, 2026 has 156 enabled user accounts. 135 matched an active employee or contractor. The other 21 were: 2 terminated employees, 6 former contractors, 9 generic accounts (for example `support@`, `finance-ap@`, `training01`) with sign-in enabled and no owner, and 4 user accounts used as service accounts.
  - Of 14 employee leavers between April 1 and September 30, 2026, 11 were disabled within 1 business day, 1 after 4 days, and 2 were still enabled on October 2 (37 and 58 days after termination). Sentinel `SigninLogs` show no successful sign-ins after the termination date for either account.
  - One leaver remained a member of the GitHub organization for 23 days after termination.
  - The Zendesk admin account uses a local login shared by 3 support leads.
- **Evidence reviewed (simulated):** `entra_users_enabled_2026-10-02.csv`, `bamboohr_active_2026-09-30.csv`, `contractor_tracker_2026-09.xlsx` (E-12); `bamboohr_terminations_2026-04_09.csv`, `entra_audit_disable_events.csv`, `github_org_audit_log_export.csv` (E-16); `zendesk_admin_settings.png` (E-13).
- **Cause:** Offboarding depends on IT reading a BambooHR email notification and acting by hand. Contractors are tracked by hiring managers in a spreadsheet and never enter BambooHR, so nothing triggers their removal. GitHub organization membership is not tied to Entra group membership.
- **Effect:** Orphaned accounts are a common and serious audit exception. Even with no sign-ins, the auditor would report the control as not operating, and two leavers with live accounts at the as-of date would be an exception in a Type I.
- **Recommendation:** Disable the 8 former-worker accounts now. Assign an owner to each generic account or disable it; convert the 4 user accounts used as service accounts to managed identities or service principals (see G-06). Add contractors to BambooHR with an end date. Turn on BambooHR-to-Entra provisioning so that termination disables the account automatically. Manage GitHub organization membership through an Entra group (SCIM or team sync). Move Zendesk admin to SSO with named accounts.

#### G-05 Access approvals are not consistently documented

**Priority:** Medium - **Control:** AC-03 - **Risk:** R-01 - **Owner:** IT Administrator

- **Criteria:** CC6.2 and CC6.3.
- **Condition:** Of 25 access grants sampled from the Entra and GitHub audit logs (April-September 2026), 16 had a Jira Service Management ticket with manager approval, 6 were approved in Teams chat only, and 3 had no approval evidence. Two of the three were Contributor grants on the production subscription.
- **Evidence reviewed (simulated):** `access_grants_population_2026-04_09.csv`, `jsm_access_requests_sample.pdf`, Teams screenshots (E-15).
- **Cause:** The ticket form is optional; engineers ask in chat to save time, and IT grants access directly from the chat request.
- **Effect:** A chat message is hard to retrieve, rarely says what level of access was approved, and does not prove the approver had authority. The auditor would count these as exceptions.
- **Recommendation:** Make the JSM form the only path (IT does not act on chat requests). Add a required "access level" field and an automatic system-owner approval step for privileged roles. Where possible, grant access through Entra access packages so that the approval is recorded by the system.

#### G-06 MFA exclusions and standing privileged access

**Priority:** High - **Controls:** AC-02, AC-06 - **Risks:** R-02, R-03 - **Owner:** Director, IT & Security

- **Criteria:** CC6.1 (authentication and restricting privileged access) and CC6.3 (least privilege).
- **Condition:**
  - Conditional Access policy "Require MFA - all users" excludes group `CA-Exclusions`, which has 7 members: 2 break-glass accounts (acceptable, but no alert on their use), 4 user accounts used as service accounts, and the CFO, excluded since a 2024 travel issue and never re-added.
  - No phishing-resistant MFA requirement for administrator roles.
  - PIM is licensed (Entra ID P2) but not used. There are 5 permanent Global Administrators plus 2 break-glass accounts. On the production subscription, 4 Owners and 7 Contributors have standing access.
  - Of 31 app registrations, 12 use client secrets: 5 are valid for more than 12 months, 2 have expired but were never removed, and 4 have no owner.
- **Evidence reviewed (simulated):** `ca_policies_export_2026-10-01.json`, `ca_exclusions_members.csv` (E-14); `entra_role_assignments.csv`, `pim_settings.png`, `azure_rbac_prod_sub.csv` (E-18); `app_registrations_credentials.csv` (E-19).
- **Cause:** Exclusions were added to fix urgent problems and there is no process to review them. PIM was not rolled out because of concern that it would slow down on-call engineers.
- **Effect:** A privileged account without MFA, or with permanent Global Admin, is one of the shortest paths to a full tenant compromise. The CFO exclusion is especially sensitive given the payment-related nature of the product.
- **Recommendation:** Remove the CFO and the 4 user-based service accounts from the exclusion group (keep only the two break-glass accounts, monitored by a Sentinel alert). Require phishing-resistant MFA (FIDO2 or Windows Hello for Business) for admin roles through an authentication strength policy. Onboard Global Administrator, Privileged Role Administrator and Azure Owner/Contributor on production to PIM with approval and an 8-hour maximum activation; on-call engineers get eligible assignments, which addresses the speed concern. Reduce Global Admins to 4 or fewer. Rotate or remove client secrets, set a 12-month maximum and assign an owner to each app.

#### G-07 Segregation of duties is not defined or enforced

**Priority:** High - **Control:** AC-07 - **Risks:** R-04, R-05 - **Owner:** VP Engineering

- **Criteria:** CC5.1 (control activities, including segregation of duties) and CC6.3; also relevant to CC3.3 (fraud risk).
- **Condition:**
  - There is no SoD matrix.
  - In the internal admin console, the "Tier 2 support" role (8 people) can edit a customer's payee bank account details on the customer's behalf. No second approval is required. Edits are written to the application's audit table, but nobody reviews that table. 63 bank-detail edits were made by support staff between July and September 2026.
  - The GitHub "production" environment requires one approval, but "prevent self-review" is not enabled. 3 of 25 sampled deployments were approved by the person who triggered them.
- **Evidence reviewed (simulated):** `admin_console_roles.xlsx`, `payee_bank_edit_log_2026-Q3.csv` (E-20); `github_env_production_settings.png`, `deployments_sample_2026-Q3.csv` (E-21).
- **Cause:** The admin console was built for fast customer support, and the risk was never assessed because no risk assessment exists (G-01). The deployment setting was simply missed.
- **Effect:** Payee bank details are the data a payment-redirection fraud targets. A single support user, or a compromised support account, could change where a customer's supplier payments go. Enterprise customers' own auditors are likely to ask about it. The principle is the same as for vendor master-data controls in an accounts payable function: whoever can change bank details should not be able to do it alone.
- **Recommendation:**
  1. **Interim (30 days):** the Head of Customer Support reviews the weekly bank-detail edit report and confirms each edit against the customer ticket; a Sentinel rule alerts on any edit not linked to a ticket. Limit the permission to a named group of 3.
  2. **Permanent (90 days):** build dual approval into the admin console (one user requests, a different user approves, with the customer's confirmation attached).
  3. Enable "prevent self-review" on the production environment (also part of G-13).
  4. Write the SoD matrix covering code, deployment, access administration and the admin console, and check it during each quarterly access review.

#### G-08 Incomplete SaaS inventory and unmanaged contractor devices

**Priority:** Medium - **Controls:** RISK-02, AC-12 - **Risks:** R-13, R-14 - **Owner:** IT Administrator

- **Criteria:** CC2.1, CC3.2 and CC6.1 (asset inventory), CC6.7 and CC6.8 (endpoints and malware).
- **Condition:** Defender for Cloud Apps discovery shows 74 SaaS applications in use; 19 are sanctioned and tracked. Customer data stores in Azure have no owner or classification tags. Of 128 Intune devices, 9 are non-compliant (OS updates older than 30 days) and 7 macOS developer laptops are not onboarded to Defender for Endpoint. The 14 contractors are excluded from the compliant-device Conditional Access policy and reach M365 in a browser from unmanaged devices.
- **Evidence reviewed (simulated):** `mdca_discovered_apps_2026-09.csv`, `azure_resource_graph_export.csv` (E-09); `intune_compliance_2026-10-01.csv`, `defender_device_inventory.csv` (E-26).
- **Cause:** The macOS onboarding package was never deployed. Contractors were excluded when the device policy launched and nobody set an end date for the exception.
- **Effect:** Gaps in inventory mean gaps in scope for every other control. Unmanaged contractor devices can download customer implementation files with no encryption or malware protection.
- **Recommendation:** Onboard the 7 macOS devices; enforce the 30-day patch rule. For contractors, apply app protection policies or require Defender for Cloud Apps session controls (block downloads on unmanaged devices). Create the SaaS register from the discovery report and tag customer data stores with owner and classification.

### System operations (CC7)

#### G-09 Vulnerabilities are found but not fixed on time

**Priority:** High - **Controls:** OPS-01, MON-02 - **Risk:** R-06 - **Owner:** Security Engineer

- **Criteria:** CC7.1 (detecting vulnerabilities and configuration changes) and CC4.1.
- **Condition:** Tenable shows 27 critical and 64 high findings open; 18 criticals are older than 30 days and the oldest is 112 days. Defender for Cloud secure score is 58%. No remediation SLA or exception process is written down. From the February 2026 penetration test, one high finding (stored XSS in the payee notes field) has been open about 240 days with no retest booked. 11 high Dependabot alerts are older than 60 days.
- **Evidence reviewed (simulated):** `tenable_vuln_ageing_2026-10-05.csv`, `defender_secure_score_history.png` (E-27); `pentest_report_2026-02.pdf`, `jira_pentest_findings.csv` (E-11).
- **Cause:** Scanning is owned by security and fixing is owned by engineering, with no agreed SLA connecting them. Findings compete with product work, and there is no escalation when they age.
- **Effect:** Auditors look for evidence that findings are tracked and resolved, not just detected. Ageing criticals on internet-facing components are a real exposure.
- **Recommendation:** Approve SLAs (critical 15 days, high 30 days, medium 90 days) and an exception form signed by the VP Engineering. Clear criticals older than 30 days. Fix and retest the XSS finding. Send a monthly ageing report to the leadership review (G-01). Bring Dependabot alerts under the same SLA.

#### G-10 Logging gaps and slow alert triage

**Priority:** Medium - **Controls:** OPS-02, OPS-03 - **Risks:** R-04, R-07 - **Owner:** Security Engineer

- **Criteria:** CC7.2 (monitoring for anomalies) and CC7.3 (evaluating security events).
- **Condition:** Sentinel receives Entra ID, Azure Activity, Defender XDR, Defender for Cloud and M365 logs, but not the GitHub audit log, AKS control plane logs or Key Vault diagnostics. Workspace retention is 90 days, while the draft enterprise MSA requires 12 months. From July to September 2026, 312 incidents were created: median time to acknowledge was 19 hours, 61% were closed with no comment, and there is no after-hours coverage. No analytics rule covers payee bank-detail edits.
- **Evidence reviewed (simulated):** `sentinel_data_connectors.png`, `law_retention_settings.png` (E-28); `sentinel_incidents_2026-Q3.csv`, `analytics_rules_list.csv` (E-29).
- **Cause:** One Security Engineer covers monitoring alongside other work. Most analytics rules are defaults that generate noise, so incidents get closed in bulk.
- **Effect:** Without notes, the auditor cannot tell whether an incident was investigated or just closed. Missing GitHub and Key Vault logs leave blind spots in change and secret access.
- **Recommendation:** Connect the missing sources; set 12-month retention using the Log Analytics long-term retention (archive) tier to control cost. Require a closure reason and a one-line note on every incident. Tune or disable the noisiest default rules. Define a 4-business-hour triage target for high severity and decide on after-hours cover (on-call rota or an MDR provider). Add a rule for bank-detail edits (G-07).

#### G-11 Incident response plan is untested and misses PIPEDA steps

**Priority:** Medium - **Control:** OPS-04 - **Risk:** R-08 - **Owner:** Director, IT & Security

- **Criteria:** CC7.3, CC7.4 and CC7.5.
- **Condition:** The IR plan (v0.3, Confluence, 2025) is unapproved and has never been tested. It has no step for deciding whether an incident is a breach of security safeguards under PIPEDA, no breach record log, and does not reflect the 72-hour customer notification in the MSA. The May 2026 mailbox compromise of an account executive (phishing; mailbox rules forwarding to an external address for 2 days) was contained by resetting the password and revoking sessions, but there is no post-incident review and no documented assessment of whether personal information was exposed.
- **Evidence reviewed (simulated):** `ir_plan_v0.3.pdf`, `incident_INC-2026-014_timeline.pdf` (E-30).
- **Cause:** The plan was written once and not owned afterwards. The incident was handled well technically, but nobody stepped back to document and learn from it.
- **Effect:** The auditor would see an unapproved plan and a real incident with no closure record. Under PIPEDA, organizations must keep a record of every breach of security safeguards involving personal information (24 months) and report to the Privacy Commissioner and notify individuals where there is a real risk of significant harm.
- **Recommendation:** Update and approve the plan, adding severity definitions, a privacy breach assessment step with Controller and counsel, the breach record log, and customer notification templates. Run a tabletop in December 2026 using a scenario based on the May incident. Complete a retrospective post-incident review of INC-2026-014, including the privacy assessment.

#### G-12 Backups never restored; no BC/DR plan

**Priority:** Medium - **Controls:** OPS-05, BCP-01 - **Risk:** R-09 - **Owner:** CTO, with DevOps Lead

- **Criteria:** CC7.5 (recovery from incidents) and CC9.1 (mitigating business disruption).
- **Condition:** Azure SQL point-in-time restore is at the 7-day default; no long-term retention; geo-redundant backup storage is on. Blob soft delete is 7 days and versioning is off. No restore test has ever been documented. There is no BC/DR plan, RTO or RPO. Cyber insurance is in place (renewed June 2026).
- **Evidence reviewed (simulated):** `azure_sql_backup_policy.png`, `storage_data_protection.png` (E-31); `cyber_insurance_certificate_2026.pdf` (E-36).
- **Cause:** Backups were left at platform defaults, and the team assumed that Azure handles recovery.
- **Effect:** An untested backup is an assumption, not a control. A ransomware or deletion event discovered after 7 days could not be recovered from Azure SQL backups.
- **Recommendation:** Set PITR to 35 days with monthly LTR for 12 months; enable Blob versioning. Restore a production database copy into an isolated subscription, check row counts against production, time it, and record the result. Write a short DR runbook (Terraform rebuild into Canada East plus geo-restore) with an RTO and RPO agreed by the CTO, and test it once before the as-of date.

### Change management (CC8)

#### G-13 Changes can reach production without review

**Priority:** High - **Controls:** CHG-01, CHG-02, CHG-03 - **Risk:** R-05 - **Owner:** DevOps Lead, with VP Engineering

- **Criteria:** CC8.1 (changes are authorized, designed, developed, configured, documented, tested, approved and implemented).
- **Condition:**
  - **Sample:** 25 pull requests merged to the default branch of the three production repositories between July and September 2026, picked from the full population of 412 merged PRs. 22 had an approving review by someone other than the author. The 3 without review were all in `platform-infra`, the Terraform repository for production, which has no branch protection. 19 of 25 (76%) linked to a Jira ticket.
  - 4 GitHub organization owners can bypass rulesets.
  - No emergency change category exists; hotfixes go through the same path, sometimes without review.
  - Azure Activity logs for the production resource group show 41 write operations by named users outside the pipeline in the last 30 days (App Service settings, NSG rule edits, AKS node pool scaling). None were reviewed.
- **Evidence reviewed (simulated):** `merged_prs_population_2026-Q3.csv`, `pr_sample_25.xlsx` (E-32); `github_rulesets_export.json` (E-33); `azure_activity_prod_writes_30d.csv` (E-34).
- **Cause:** `platform-infra` was set up by one engineer before the rulesets were standardized. Engineers keep standing Contributor rights (G-06), so making a quick fix in the portal is easier than going through the pipeline.
- **Effect:** CC8.1 is tested on the full change population. Unreviewed infrastructure changes and changes made outside the pipeline are exceptions, and the portal changes cannot be tied to any approval.
- **Recommendation:** Apply the standard ruleset to `platform-infra`; remove bypass for org owners (keep one break-glass owner, monitored). Enable "prevent self-review". Require a Jira key in the PR title through a status check. Add an emergency change label with retrospective approval within 2 business days. Once PIM is in place (G-06), send a monthly report of non-pipeline writes to the VP Engineering for review. The [Change Management Policy](policies/change-management-policy.md) sets out the rules.

### Risk mitigation and vendors (CC9)

#### G-14 No vendor risk management process

**Priority:** High - **Controls:** VND-01, VND-02, VND-03 - **Risks:** R-10, R-11 - **Owner:** Controller, with Director, IT & Security

- **Criteria:** CC9.2 (assessing and managing risks from vendors and business partners); C1.1 for confidentiality commitments passed on to vendors.
- **Condition:**
  - The NetSuite AP vendor master has 214 active vendors. With the Controller, the assessment identified 23 that have access to Quillfield systems or data. There is no security tier, owner or review date for any of them.
  - New vendors are created in NetSuite by AP from a vendor setup form with banking details, but there is no security review step. Four SaaS tools are paid on corporate cards and never appear in the vendor master.
  - The public trust page lists 5 subprocessors. DPAs are on file for 3 (Microsoft, Zendesk, Twilio SendGrid). Atlassian's online terms were accepted but not filed. The offshore QA firm has an MSA with an NDA but no data protection, breach notification or deletion terms, and its 6 testers can access staging, which holds unmasked production data (G-15).
  - No SOC 2 reports from vendors are on file, including Microsoft Azure and GitHub, which the system description would treat as carved-out subservice organizations.
- **Evidence reviewed (simulated):** `netsuite_vendor_master_active_2026-09-30.csv`, `corporate_card_saas_spend_2026.xlsx` (E-37); `subprocessor_list_trust_page.png`, `dpa_folder_listing.png`, `qa_firm_msa_2025.pdf` (E-38); no response for E-39.
- **Cause:** Vendor onboarding is treated as a finance process (getting the vendor paid) rather than a risk process. Security is not part of it.
- **Effect:** For a carve-out, the auditor will expect Quillfield to monitor its subservice organizations, usually by reviewing their SOC reports and the complementary user entity controls (CUECs) they assume Quillfield operates. The QA firm is the most immediate exposure.
- **Recommendation:**
  1. Tier the 23 vendors (plus the 4 card-paid tools) using the criteria in the [Vendor Risk Management Policy](policies/vendor-risk-management-policy.md).
  2. Obtain current SOC 2 reports for Microsoft Azure, GitHub, Zendesk, Twilio SendGrid and Atlassian (most are available through each vendor's trust portal). Write a one-page review memo per report: opinion, period, exceptions, relevant CUECs and the Quillfield control that covers each CUEC.
  3. File the Atlassian DPA; amend the QA firm contract to add data protection, breach notification within 72 hours, and return/deletion terms (or remove their access).
  4. Make "security tier" a required field in NetSuite vendor creation, so that a Tier 1 or 2 vendor cannot be activated for payment without a completed review. This reuses an existing finance control point instead of building a new process.

### Confidentiality (C1)

#### G-15 Customer data lifecycle is not controlled

**Priority:** High - **Controls:** CONF-01, CONF-02, CONF-03, CONF-04 - **Risks:** R-11, R-12, R-13 - **Owner:** VP Engineering (CONF-02, CONF-03); IT Administrator (CONF-04); Director, IT & Security (CONF-01)

- **Criteria:** C1.1 (identifying and maintaining confidential information) and C1.2 (disposing of confidential information).
- **Condition:**
  - **Non-production:** the staging database is refreshed monthly from a production backup with no masking. It holds customer invoices and payee bank details. Staging uses a shared SQL login, and the 6 offshore QA testers have access to it.
  - **Retention:** 4 customers who terminated in 2024-2025 still have all their data in the production database. The MSA commits to deletion within 90 days of termination. No deletion runbook exists.
  - **Sharing:** the M365 tenant allows "Anyone" links. There are 340 active anonymous links, 27 of them in customer implementation folders. Purview DLP policies are in test mode only.
  - **Classification:** a 2024 draft standard exists but is not approved; Purview sensitivity labels are configured but not published.
- **Evidence reviewed (simulated):** `staging_refresh_pipeline.yml`, `staging_sql_logins.csv` (E-42); `customer_terminations_2024-2026.csv`, `prod_tenant_row_counts.csv` (E-41); `spo_sharing_settings.png`, `anonymous_links_report_2026-10-01.csv`, `purview_dlp_policies.png` (E-40, E-43).
- **Cause:** Engineering needed realistic data to reproduce customer issues and nobody built a masked alternative. Customer offboarding ends when billing stops; there is no technical step after that.
- **Effect:** These are the conditions most likely to cause exceptions in the Confidentiality criteria, and they are also live exposures: the staging copy multiplies the number of people who can see customer bank data, and retained data breaks a contract commitment and PIPEDA's limiting-retention principle (to the extent the data includes personal information, for example sole-proprietor suppliers).
- **Recommendation:**
  1. Stop the production-to-staging refresh this week and purge existing copies (30 days). Replace the shared SQL login with named Entra accounts.
  2. Build a masked or synthetic data set for staging (90 days).
  3. Write a deletion runbook: confirm no legal hold, delete the tenant's data and blobs, run a verification query, and send the customer a confirmation letter. Apply it to the 4 churned customers and add a quarterly check.
  4. Change sharing to "existing guests" only and expire existing anonymous links; move DLP to enforce mode for bank account and Restricted content; approve the classification standard and publish labels.

## 5. Limitations

- This is a readiness assessment, not an attestation. A CPA firm will form its own view of the system description and the design and implementation of controls as of the Type I date.
- Samples were judgmental (25 items per test) and intended to show whether a control works at all, not to support a conclusion over a period. A Type II would require testing across the review period.
- Availability, Processing Integrity and Privacy criteria were not assessed. Some findings (backups, payee bank details) would matter more if Availability or Processing Integrity were added later.
- Privacy law references (PIPEDA) are included to flag obligations, not as legal advice. Counsel should confirm them, including whether Quebec's Law 25 applies to any customer or employee data.
