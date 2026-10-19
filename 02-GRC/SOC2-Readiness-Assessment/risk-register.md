# Risk register - Quillfield Systems Inc. (fictional)

> Simulated scenario for a learning and portfolio project. No real company, client or audit.

Same data as [`risk-register.xlsx`](risk-register.xlsx), where scores and ratings are live formulas. Control IDs refer to [`control-matrix.md`](control-matrix.md); gap IDs refer to [`gap-assessment.md`](gap-assessment.md).

## Scoring method

- **Likelihood (L), 1-5:** 1 Rare (less than once in 5 years) - 2 Unlikely - 3 Possible (once in 1-3 years) - 4 Likely (about once a year) - 5 Almost certain (already happening, or several times a year).
- **Impact (I), 1-5:** 1 Minimal - 2 Minor (internal only) - 3 Moderate (one customer affected or a contract breach) - 4 Major (several customers, regulator notification, or a SOC 2 exception) - 5 Severe (customer financial loss, lost enterprise deal, or widespread data exposure).
- **Score = L x I.** Bands: 1-4 Low, 5-9 Medium, 10-15 High, 16-25 Critical.
- **Inherent:** before any controls. **Current residual:** with controls as they operate today (per the control matrix). **Target residual:** after the treatment plan is complete.
- Risk appetite (proposed, for leadership to confirm): no Critical or High residual risk without a dated treatment plan and a named owner; target residual of Medium or lower before the Type I as-of date.

## Register

| ID | Risk | Controls | Gaps | Inherent (LxI) | Current residual (LxI) | Treatment and plan | Owner | Target date | Target residual (LxI) |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| R-01 | Leaver, contractor or generic accounts stay active and are used to access customer data or systems without authorization. | AC-01; AC-03; AC-04; AC-05 | G-03; G-04; G-05 | 16 Critical (4x4) | 12 High (3x4) | **Mitigate.** Add contractors to BambooHR with end dates; automate disable via BambooHR-Entra provisioning; assign owners to or remove generic accounts; first quarterly UAR in Q4 2026. | IT Administrator | 2026-12-23 | 8 Medium (2x4) |
| R-02 | Phishing or credential theft leads to account takeover, helped by MFA exclusions and no phishing-resistant MFA for admins (a mailbox compromise already occurred in May 2026). | AC-02; HR-02; OPS-03 | G-02; G-06 | 20 Critical (5x4) | 16 Critical (4x4) | **Mitigate.** Empty CA-Exclusions except break-glass; move service accounts to workload identities; require phishing-resistant MFA for admin roles; enrol contractors in training. | Director, IT & Security | 2026-11-25 | 8 Medium (2x4) |
| R-03 | Standing privileged access in Entra ID or the production subscription is misused or compromised, allowing tenant-wide or production-wide changes. | AC-05; AC-06 | G-03; G-06 | 20 Critical (4x5) | 15 High (3x5) | **Mitigate.** Onboard Global Admin, Privileged Role Admin and Azure Owner/Contributor to PIM with approval; reduce Global Admins to 4; rotate and own service principal secrets. | Director, IT & Security | 2026-12-18 | 5 Medium (1x5) |
| R-04 | A fraudulent or mistaken edit to a customer's payee bank details in the internal admin console redirects customer payments to the wrong account. | AC-07; OPS-03 | G-07 | 20 Critical (4x5) | 15 High (3x5) | **Mitigate.** Require second-person approval for bank detail edits in the admin console; restrict the permission to a named group; Sentinel rule and weekly review of the edit log until dual approval ships. | VP Engineering | 2027-01-22 | 5 Medium (1x5) |
| R-05 | An unreviewed or unauthorized change reaches production (infrastructure repo without branch protection, direct portal changes, self-approved deployments) and causes an outage or weakens security. | CHG-01; CHG-02; CHG-03; AC-07 | G-13; G-07 | 16 Critical (4x4) | 12 High (3x4) | **Mitigate.** Apply the standard ruleset to platform-infra; remove admin bypass; enable prevent self-review; move engineers to PIM-eligible access; monthly review of non-pipeline write operations. | DevOps Lead | 2026-12-23 | 8 Medium (2x4) |
| R-06 | A known critical vulnerability in internet-facing or production components is exploited before it is fixed. | OPS-01; MON-02; CHG-04; AC-10 | G-09 | 20 Critical (4x5) | 15 High (3x5) | **Mitigate.** Approve remediation SLAs and an exception process; clear criticals older than 30 days; fix and retest the open pen test high finding; monthly ageing report to leadership. | Security Engineer | 2027-01-22 | 10 High (2x5) |
| R-07 | An intrusion goes undetected or is detected late because key logs are missing, retention is 90 days, and alerts are triaged slowly with no notes. | OPS-02; OPS-03 | G-10 | 16 Critical (4x4) | 12 High (3x4) | **Mitigate.** Connect GitHub, AKS and Key Vault logs; set 12-month retention (archive tier); define triage SLA and closure reason codes; add after-hours paging for high severity. | Security Engineer | 2027-01-22 | 8 Medium (2x4) |
| R-08 | A security incident is handled poorly and Quillfield misses the 72-hour customer notice in the MSA or its PIPEDA breach reporting and record-keeping obligations. | OPS-04 | G-11 | 15 High (3x5) | 12 High (3x4) | **Mitigate.** Approve IR plan with a PIPEDA breach assessment step and breach record log; run a tabletop; complete a retrospective review of the May 2026 incident. | Director, IT & Security | 2026-12-18 | 8 Medium (2x4) |
| R-09 | Customer data is lost or the service is down for an extended period because backups have never been restored and there is no DR plan. | OPS-05; BCP-01 | G-12 | 15 High (3x5) | 12 High (3x4) | **Mitigate.** Set PITR to 35 days and monthly LTR; enable Blob versioning; perform and document a restore test; write a DR runbook with RTO/RPO and test it. | CTO | 2027-01-22 | 8 Medium (2x4) |
| R-10 | A vendor or subprocessor breach exposes Quillfield or customer data, with no due diligence done and weak contractual remedies. | VND-01; VND-02; VND-03 | G-14 | 15 High (3x5) | 15 High (3x5) | **Mitigate.** Tier all vendors; collect and review SOC 2 reports for Tier 1; file or sign DPAs with Atlassian and the QA firm; add a security tier field as a required step for new vendors in NetSuite. | Controller | 2027-01-22 | 8 Medium (2x4) |
| R-11 | Customer data is exposed from staging, which holds unmasked production copies and is accessed by an offshore contractor through a shared login. | CONF-03; VND-02; AC-05 | G-15; G-14 | 20 Critical (4x5) | 20 Critical (4x5) | **Mitigate.** Stop production-to-staging refreshes now; purge existing copies; build masked or synthetic data set; replace shared SQL login with named Entra accounts. | VP Engineering | 2026-11-25 | 5 Medium (1x5) |
| R-12 | Customer data is kept after contract termination, breaching the MSA and the PIPEDA limiting-retention principle. | CONF-02 | G-15 | 15 High (5x3) | 15 High (5x3) | **Mitigate.** Write a deletion runbook; delete the 4 churned customers' data after legal confirms no hold; add a quarterly check of churned customers. | VP Engineering | 2027-01-22 | 3 Low (1x3) |
| R-13 | Confidential data leaks through anonymous sharing links, unlabelled documents or unmanaged contractor devices. | CONF-01; CONF-04; AC-12; RISK-02 | G-15; G-08 | 16 Critical (4x4) | 12 High (3x4) | **Mitigate.** Disable 'Anyone' links and expire existing ones; publish sensitivity labels; move DLP to enforce mode; require compliant devices or app protection for contractors. | IT Administrator | 2027-01-22 | 6 Medium (2x3) |
| R-14 | Malware or ransomware on an endpoint spreads to corporate files or developer credentials. | AC-12; OPS-01; OPS-05 | G-08; G-09 | 16 Critical (4x4) | 8 Medium (2x4) | **Mitigate.** Onboard the 7 macOS laptops to Defender; enforce patch compliance; cyber insurance partly transfers financial impact. | IT Administrator | 2026-11-25 | 6 Medium (2x3) |
| R-15 | The SOC 2 Type I is delayed or qualified because controls have no owner oversight, policies are unapproved and there is no risk assessment, putting the enterprise contract at risk. | GOV-01; GOV-03; RISK-01; MON-01 | G-01 | 16 Critical (4x4) | 16 Critical (4x4) | **Mitigate.** Approve policies; start quarterly leadership security review; accept this risk register; run quarterly control self-assessment; readiness re-check in February 2027. | CEO | 2027-02-26 | 8 Medium (2x4) |

## Current residual heat map

Count of risks by current likelihood and impact (risk IDs in brackets).

| Likelihood \ Impact | 1 | 2 | 3 | 4 | 5 |
| --- | --- | --- | --- | --- | --- |
| **5** | - | - | 1 (R-12) | - | - |
| **4** | - | - | - | 2 (R-02, R-15) | 1 (R-11) |
| **3** | - | - | - | 6 (R-01, R-05, R-07, R-08, R-09, R-13) | 4 (R-03, R-04, R-06, R-10) |
| **2** | - | - | - | 1 (R-14) | - |
| **1** | - | - | - | - | - |

| Rating | Inherent | Current residual | Target residual |
| --- | ---: | ---: | ---: |
| Critical | 11 | 3 | 0 |
| High | 4 | 11 | 1 |
| Medium | 0 | 1 | 13 |
| Low | 0 | 0 | 1 |

## Notes

- R-11 and R-12 are rated with likelihood 5 or 4 at current state because the condition already exists (unmasked production data in staging; churned customers' data retained). They are the clearest examples of risk that is present today, not hypothetical.
- R-14 is already Medium at current state because Defender for Endpoint and Intune cover most devices; it stays on the register because of the contractor and macOS gaps.
- Target residual scores assume the treatment plans in the 30/60/90-day roadmap in the [README](README.md#remediation-roadmap) are completed on time. They should be re-scored at the February 2027 readiness re-check, not assumed.
- R-06 stays High at target (2x5) because a breach of the payment-file service would still be severe. Leadership should either accept that explicitly or fund more (for example WAF virtual patching for internet-facing findings while fixes are pending).
- The register is a first draft prepared by the assessor. Under RISK-01, leadership must review, challenge and accept it before it counts as the company's risk assessment.
