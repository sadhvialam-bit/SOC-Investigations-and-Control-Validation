# Vendor Risk Management Policy

**Quillfield Systems Inc. (fictional)** - Policy ID: POL-VRM - Version 1.0 (pending approval) - Owner: Director, IT & Security (with Controller)

> Simulated policy written for a learning and portfolio project. Quillfield and the people named below are fictional.

## 1. Purpose

To identify and manage security and confidentiality risks from vendors, subprocessors and subservice organizations, from selection through offboarding, so that Quillfield can meet its commitments to customers.

## 2. Scope

All third parties that access Quillfield systems, process Quillfield or customer data, or provide services the AP platform depends on, whether paid through accounts payable or a corporate card. Includes software, cloud and professional services vendors and contractors engaged through a firm.

## 3. Roles and responsibilities

| Role | Responsibility |
| --- | --- |
| Director, IT & Security | Owns this policy; performs or approves security due diligence; reviews SOC reports and maps CUECs |
| Controller | Maintains the vendor master in NetSuite; enforces the security tier step before a vendor is activated for payment; manages contract templates with counsel |
| Business owner (requester) | Names the vendor's purpose, data and access; owns the relationship and the annual review |
| AP team | Does not activate a new vendor or pay a new SaaS tool without a security tier |
| All staff | Do not buy software on a corporate card without a security tier (the card policy refers to this policy) |

## 4. Vendor tiers

| Tier | Criteria | Examples (current) |
| --- | --- | --- |
| Tier 1 - Critical | Stores or processes customer data, or has access to production; or the platform cannot run without it | Microsoft Azure, GitHub, Zendesk, Twilio SendGrid, Atlassian (customer data appears in tickets), offshore QA firm |
| Tier 2 - Sensitive | Accesses Quillfield confidential or employee data, but not customer data or production | BambooHR, NetSuite, payroll provider |
| Tier 3 - Low | No access to Quillfield systems or non-public data | Office supplies, event venues |

Where a vendor's tier is unclear, the higher tier applies.

## 5. Policy statements

### 5.1 Onboarding

1. Every new vendor is assigned a tier by the business owner and confirmed by the Director, IT & Security before contract signature.
2. The tier is a required field when creating a vendor in NetSuite. AP does not activate a Tier 1 or Tier 2 vendor until the due diligence record is attached.
3. Due diligence by tier:

| Tier | Minimum due diligence | Approver |
| --- | --- | --- |
| Tier 1 | SOC 2 Type II report (or ISO/IEC 27001 certificate with Statement of Applicability) reviewed in a memo; security questionnaire for gaps; check of data location | Director, IT & Security and CTO |
| Tier 2 | SOC 2 report or security questionnaire; MFA and SSO support confirmed | Director, IT & Security |
| Tier 3 | None beyond standard procurement | Business owner |

### 5.2 Contract requirements

Tier 1 and 2 contracts must include confidentiality obligations, security requirements proportionate to the service, notification of security incidents affecting Quillfield data within 72 hours, Quillfield's right to receive audit reports, restrictions on subcontracting, and return or deletion of data at the end of the contract. Vendors that process personal information on Quillfield's behalf must sign a DPA. Subprocessors are listed on the public trust page and customers are notified of additions as the MSA requires.

### 5.3 Ongoing monitoring

1. **Annually** for Tier 1 vendors and subservice organizations: obtain the current SOC 2 report and any bridge letter; record the opinion, the period covered, exceptions and their relevance, and the complementary user entity controls (CUECs); map each relevant CUEC to the Quillfield control that addresses it.
2. **Every two years** for Tier 2: refresh the SOC report or questionnaire.
3. Material changes (a new service, new data types, a vendor breach, a qualified SOC opinion) trigger a review outside the cycle.
4. The vendor inventory is reconciled to the NetSuite active vendor master and corporate card spend each quarter by the Controller. Vendors found without a tier are reviewed within 30 days.

### 5.4 Vendor master data

Changes to a vendor's banking details in NetSuite are verified by a callback to a known contact (not the contact details in the change request) and approved by a second person in finance. This protects Quillfield's own payments and mirrors the dual-approval control required for customer payee data in the AP platform.

### 5.5 Offboarding

When a contract ends, the business owner confirms that vendor access to Quillfield systems is removed (Access Control Policy, section 4.3), obtains written confirmation that Quillfield data has been returned or deleted, and the Controller deactivates the vendor in NetSuite.

## 6. Exceptions

A Tier 1 or 2 vendor without a SOC report or complete due diligence may be approved only by the CTO, with a documented risk acceptance, compensating controls (for example limited data or access) and a review date no more than 6 months later. Exceptions are recorded in the risk register.

## 7. Review cadence

Reviewed at least annually. The vendor inventory and tiering are reported at the quarterly leadership security review.

## 8. Related controls

VND-01 to VND-03, AC-08 and CONF-03 in the [control matrix](../control-matrix.md). TSC CC9.2, C1.1, CC6.4 (carve-out reliance). ISO/IEC 27001:2022 A.5.19-A.5.23. NIST CSF 2.0 GV.SC.

## 9. Version and approval

| Version | Date | Author / reviewer | Change |
| --- | --- | --- | --- |
| 0.1 | 2026-10-13 | GRC Analyst (assessor) | First draft from readiness assessment |
| 0.2 | 2026-10-16 | Hannah Leblanc, Controller | Review; added NetSuite activation step and vendor bank detail controls |
| 1.0 | Target 2026-11-06 | - | For approval |

| Approver | Role | Decision | Date |
| --- | --- | --- | --- |
| Priya Raman | Chief Technology Officer | Pending | |
| Elena Kowalczyk | Chief Executive Officer | Pending | |
