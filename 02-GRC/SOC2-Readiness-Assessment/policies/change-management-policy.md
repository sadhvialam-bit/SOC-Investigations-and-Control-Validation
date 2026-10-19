# Change Management Policy

**Quillfield Systems Inc. (fictional)** - Policy ID: POL-CM - Version 1.0 (pending approval) - Owner: VP Engineering

> Simulated policy written for a learning and portfolio project. Quillfield and the people named below are fictional.

## 1. Purpose

To make sure that changes to the Quillfield AP platform and its supporting infrastructure are authorized, reviewed, tested and traceable, so that changes do not cause outages, weaken security or affect customer data unintentionally.

## 2. Scope

All changes to production, including application code, infrastructure as code (Terraform), configuration of Azure resources, database schema and data fixes, GitHub Actions workflows, and security-relevant configuration in Entra ID (for example Conditional Access policies). Development and staging changes are out of scope except where they alter the path to production.

## 3. Roles and responsibilities

| Role | Responsibility |
| --- | --- |
| VP Engineering | Owns this policy; approves emergency changes retrospectively; reviews the monthly out-of-band change report |
| DevOps Lead | Maintains branch rules, pipeline and environment protections; produces the out-of-band change report |
| Change author | Raises the Jira ticket and PR, describes testing and rollback |
| Reviewer | A different engineer who reviews and approves the PR |
| Release approver | Named engineers who approve production deployments; cannot approve their own run |
| Director, IT & Security | Reviews changes tagged as security-relevant; approves changes to identity and security tooling |

## 4. Change types

| Type | Examples | Approval |
| --- | --- | --- |
| Standard | Pre-approved, low-risk, repeatable changes on the standard change list (for example dependency patch bumps that pass all checks, scaling within defined limits) | PR review; no separate ticket approval |
| Normal | All other changes | Jira ticket, PR review by someone other than the author, release approver for deployment |
| Emergency | Changes needed to restore service or fix an actively exploited vulnerability | May deploy with one reviewer available at the time; retrospective approval by VP Engineering within 2 business days |

The DevOps Lead keeps the standard change list. The VP Engineering approves additions to it.

## 5. Policy statements

1. **Traceability.** Every normal and emergency change has a Jira ticket. The PR title includes the Jira key, enforced by a required status check.
2. **Peer review.** The default branch of every production repository (including `platform-infra`) is protected by a GitHub ruleset that requires a pull request, at least one approval from someone other than the author, resolution of review comments, and passing status checks. No user or team can bypass the ruleset except one monitored break-glass owner account.
3. **Testing.** Required checks include unit tests, CodeQL code scanning and dependency review. The PR description states how the change was tested and how it would be rolled back. Changes that touch payee bank details, payment file generation or authentication also need a reviewer from the owning team.
4. **Deployment.** Deployments to production run only through GitHub Actions using OIDC federation. The "production" environment requires approval by a release approver, with "prevent self-review" enabled.
5. **No direct changes.** Engineers do not hold standing write access to production. Access activated through PIM for troubleshooting is logged, and any configuration change made that way is captured in Terraform or a follow-up PR within 2 business days.
6. **Out-of-band detection.** Each month the DevOps Lead runs the saved KQL query of Azure Activity write operations in production made by identities other than the pipeline, and the VP Engineering reviews each one against a ticket. Unexplained changes are treated as security incidents.
7. **Data fixes.** Direct data changes in production databases need a Jira ticket, a second-person review of the script and are run through a logged, PIM-activated session.
8. **Identity and security configuration.** Changes to Conditional Access, PIM settings, Sentinel analytics rules and Defender policies are recorded in a Jira ticket and approved by the Director, IT & Security.
9. **Segregation of duties.** Author, reviewer and release approver are different people for normal changes. See the Access Control Policy, section 4.6.
10. **Records.** GitHub, Jira and Azure Activity records of changes are kept for at least 12 months in their source systems or in Sentinel.

## 6. Exceptions

Exceptions to this policy (for example, a repository that cannot yet meet the ruleset) are requested in Jira, approved by the VP Engineering and the Director, IT & Security, and expire after 90 days at most. Emergency changes are not exceptions; they follow section 4.

## 7. Review cadence

Reviewed at least annually and after any change-related Sev 1 or Sev 2 incident. The DevOps Lead checks ruleset and environment settings on all production repositories quarterly and records the result.

## 8. Related controls

CHG-01 to CHG-04 and AC-07 in the [control matrix](../control-matrix.md). TSC CC8.1, CC6.1, CC5.1. ISO/IEC 27001:2022 A.8.25, A.8.31, A.8.32. NIST CSF 2.0 PR.PS.

## 9. Version and approval

| Version | Date | Author / reviewer | Change |
| --- | --- | --- | --- |
| 0.1 | 2026-10-12 | GRC Analyst (assessor) | First draft from readiness assessment |
| 0.2 | 2026-10-16 | Daniel Osei, VP Engineering | Review; added data fixes and standard change list |
| 1.0 | Target 2026-11-06 | - | For approval |

| Approver | Role | Decision | Date |
| --- | --- | --- | --- |
| Priya Raman | Chief Technology Officer | Pending | |
| Marc Gauthier | Director, IT & Security | Pending | |
