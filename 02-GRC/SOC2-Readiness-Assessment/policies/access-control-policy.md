# Access Control Policy

**Quillfield Systems Inc. (fictional)** - Policy ID: POL-AC - Version 1.0 (pending approval) - Owner: Director, IT & Security

> Simulated policy written for a learning and portfolio project. Quillfield and the people named below are fictional.

## 1. Purpose

To make sure that only authorized people and systems can access Quillfield information and the Quillfield AP platform, with no more access than their role needs, and that access is removed promptly when it is no longer needed.

## 2. Scope

All employees, contractors and third parties with access to Quillfield systems, and all non-human identities (service principals, managed identities, service accounts). In-scope systems: Microsoft Entra ID, Microsoft 365, Azure subscriptions (production, staging, development), Azure SQL, GitHub Enterprise Cloud, Jira and Confluence, Zendesk, the internal admin console, and any other system that stores or processes customer data.

## 3. Roles and responsibilities

| Role | Responsibility |
| --- | --- |
| Director, IT & Security | Owns this policy; approves privileged access; coordinates user access reviews; approves exceptions |
| IT Administrator | Provisions and removes access; maintains Entra groups and the generic account register |
| System owner (named per system) | Approves access to their system; certifies users in each access review |
| Manager | Requests and approves access for direct reports; informs People Operations of role changes |
| People Operations Manager | Records hires, role changes and terminations (employees and contractors) in BambooHR on or before the effective date |
| All users | Protect their credentials; do not share accounts; report suspected misuse to security@ |

## 4. Policy statements

### 4.1 Accounts and authentication

1. Every user has a unique named account in Entra ID. Shared accounts are not allowed. A generic account (for example a shared mailbox) must have sign-in disabled, or be listed in the generic account register with a named owner and a business reason.
2. In-scope applications must use Entra ID single sign-on where the application supports it.
3. MFA is required for all users on all cloud applications, enforced through Conditional Access. Administrator roles require phishing-resistant MFA (FIDO2 security key or Windows Hello for Business).
4. The only accounts excluded from MFA policies are two emergency ("break-glass") accounts. Their credentials are stored offline, and any sign-in raises a Sentinel alert that the Director, IT & Security reviews.
5. Access to Microsoft 365 and the Azure portal requires an Intune-compliant device or, for contractors, app protection or session controls that block downloads to unmanaged devices.

### 4.2 Granting and changing access

1. Access is requested through Jira Service Management and approved by the user's manager. Privileged roles also need approval from the system owner. IT does not grant access from chat or email requests.
2. Access is granted through role-based Entra groups or access packages, not by direct assignment, wherever the system supports it.
3. When a user changes role, access not needed for the new role is removed within 5 business days of the change date.

### 4.3 Removing access

1. On termination, the Entra account is disabled within 1 business day of the termination date (immediately for involuntary terminations). Sessions are revoked at the same time.
2. Accounts in non-SSO applications and GitHub organization membership are removed on the same day.
3. Contractors are recorded in BambooHR with an end date, and the same process applies to them.

### 4.4 Privileged access

1. Privileged roles (Global Administrator, Privileged Role Administrator, Security Administrator, and Owner, Contributor or User Access Administrator on the production subscription) are eligible-only through Privileged Identity Management. Activation requires a justification, approval for Global Administrator and production Owner, and lasts no more than 8 hours.
2. No more than 4 Global Administrators, plus the two break-glass accounts.
3. Administrators use a separate admin account for privileged work.

### 4.5 Non-human identities

1. Workloads use managed identities or workload identity federation (for example, GitHub Actions OIDC) instead of secrets wherever possible.
2. Where a client secret or certificate is required, it is stored in Azure Key Vault, expires within 12 months and has a named owner.
3. User accounts must not be used as service accounts.

### 4.6 Segregation of duties

The Director, IT & Security and VP Engineering maintain an SoD matrix. At minimum, the following conflicts are prevented by system configuration or, where that is not possible, mitigated by a documented review:

| Conflict | Required control |
| --- | --- |
| Requesting and approving the same access | Approver must be a different person (JSM workflow) |
| Authoring and approving the same code change | Branch rules require a reviewer other than the author |
| Triggering and approving the same production deployment | "Prevent self-review" on the production environment |
| Editing a customer's payee bank details and approving the edit | Dual approval in the admin console; until delivered, weekly review of all edits by the Head of Customer Support |
| Administering Entra ID and reviewing Entra administrator access | Reviewer for Entra privileged roles is the CTO |

## 5. User access reviews

1. **Frequency:** quarterly, completed within 30 days of quarter end.
2. **Systems:** Entra privileged roles, Azure RBAC on the production subscription, GitHub organization and teams, Azure SQL logins, Zendesk, internal admin console, and any system added to scope.
3. **Population:** IT extracts the user listing from each system and keeps evidence of the extraction (report or query, parameters, date, person). IT reconciles the Entra user count to BambooHR employees and contractors and explains any difference.
4. **Review:** the system owner, not IT, certifies each user and access level as keep, change or remove. A reviewer does not certify their own access; their manager does.
5. **Follow-up:** IT completes removals and changes within 5 business days and links the closed tickets to the review.
6. **Retention:** the population, reviewer sign-off and tickets are kept for at least 3 years in the compliance SharePoint library.
7. **Escalation:** a review not completed within 30 days of quarter end is reported to the CTO and recorded as a control exception.

## 6. Exceptions

Exceptions must be requested in Jira, state the business reason, the risk and any compensating control, and be approved by the Director, IT & Security (and the CTO for any exception to sections 4.1.3, 4.1.4 or 4.4). Exceptions expire after 6 months at most and are listed in the exception register, which is reviewed at each quarterly access review.

## 7. Enforcement

Violations may result in removal of access and disciplinary action under the Employee Handbook, up to and including termination, or termination of contract for third parties.

## 8. Review cadence

This policy is reviewed at least annually, and after any significant change to identity systems or a related security incident.

## 9. Related controls

AC-01 to AC-07, AC-12 in the [control matrix](../control-matrix.md). TSC CC6.1, CC6.2, CC6.3, CC5.1. ISO/IEC 27001:2022 A.5.3, A.5.15-A.5.18, A.8.2, A.8.5.

## 10. Version and approval

| Version | Date | Author / reviewer | Change |
| --- | --- | --- | --- |
| 0.1 | 2026-10-09 | GRC Analyst (assessor) | First draft from readiness assessment |
| 0.2 | 2026-10-16 | Marc Gauthier, Director, IT & Security | Review; added break-glass and contractor device rules |
| 1.0 | Target 2026-11-06 | - | For approval |

| Approver | Role | Decision | Date |
| --- | --- | --- | --- |
| Priya Raman | Chief Technology Officer | Pending | |
| Elena Kowalczyk | Chief Executive Officer | Pending | |
