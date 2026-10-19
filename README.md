# Security Operations & IT Control Validation

Portfolio of hands-on SOC investigations and GRC documentation from a Log(N) Pacific cyber range internship (Microsoft Sentinel, Defender XDR, Tenable, STIG remediation).

**Sadhvi Alam** — 10+ years in financial audit and SOX / internal controls, pivoting into cybersecurity. CompTIA Security+, Network+, Cloud+, and A+. BS in Information Technology (WGU); MS in IT starting November 2026.

**Target roles:** GRC and IT audit first; open to junior SOC analyst roles. Open to remote roles.

Connect on [LinkedIn](https://www.linkedin.com/in/sadhvi-alam-2643a430/).

---

## Start here

Three pieces that best show how I work (evidence, frameworks, and business risk):

| Project | Why it matters |
| --- | --- |
| [Formal Control Audit Report](02-GRC/Formal-Control-Audit/Formal_Control_Audit_Report.md) | Post-incident control assessment of an Azure honeypot breach, mapped to NIST CSF 2.0, NIST SP 800-53 Rev. 5, CIS Controls v8, and ISO/IEC 27001:2022 Annex A, with a corrective action plan. |
| [AI Agent Risk Assessment](02-GRC/AI-Agent-Risk-Assessment/) | Indirect prompt-injection test against an autonomous agent in a financial workflow; maps to OWASP LLM01 with governance recommendations (human-in-the-loop, least privilege). |
| [Vulnerability Management (CAB trail)](02-GRC/Vulnerability-Management/) | Full lifecycle: Tenable baseline → stakeholder handoff → emergency CAB change request → post-remediation scan and continuous monitoring schedule. |

Technical companion for the AI assessment: [AI Agent Technical Execution](01-SOC/AI-Agent-Technical-Execution/).

---

## Projects

| Project | Focus | Frameworks / tools | Outcome |
| --- | --- | --- | --- |
| [Formal Control Audit](02-GRC/Formal-Control-Audit/) | GRC | NIST CSF, 800-53, CIS, ISO 27001; Sentinel, Defender, Azure NSG | Control deficiencies, CAP, and framework mapping from a live-fire honeypot incident |
| [AI Agent Risk Assessment](02-GRC/AI-Agent-Risk-Assessment/) | GRC | OWASP Top 10 for LLMs (LLM01) | Validated LLM refusal of injected invoice payload; residual-risk and control guidance |
| [Vulnerability Management](02-GRC/Vulnerability-Management/) | GRC | CVSS / SLA policy; Tenable Nessus; CAB | Critical/High findings driven through policy SLAs to verified remediation |
| [Endpoint Containment Audit](02-GRC/Endpoint-Containment-Audit/) | GRC | IR policy / SLA; Defender isolation | Documented containment control effectiveness on a finance AP workstation |
| [Proactive Threat Hunt (GRC)](02-GRC/Proactive-Threat-Hunt/) | GRC | NIST SP 800-61 framing | Executive risk view of finance endpoint compromise (dwell time, control gaps, remediations) |
| [Cloud Honeypot Capstone](01-SOC/Cloud-Honeypot-Capstone/) | SOC | Sentinel, Defender, Azure, MySQL audit logs | End-to-end IR: detection, forensics, isolation, NSG eradication, recovery |
| [Meridian Web Intrusion](01-SOC/Meridian-Web-Intrusion/) | SOC | KQL; Log Analytics | Reconstructs LFI → credential reuse → SUID priv-esc → persistence → exfiltration (Diamond Model) |
| [Proactive Threat Hunt](01-SOC/Proactive-Threat-Hunt/) | SOC | Defender Advanced Hunting (KQL) | LotL execution, C2 beaconing, persistence, and containment plan for `npt-ws01` |
| [SIEM & EDR Triage](01-SOC/SIEM-and-EDR-Triage/) | SOC | Sentinel / Defender XDR | Hands-on-keyboard triage on an AP endpoint through device isolation |
| [Windows Server Hardening](01-SOC/Windows-Server-Hardening/) | SOC | Tenable; PowerShell STIGs | Hardened Azure Windows Server (patching, IAM, SMB/NLA, legacy auth) with re-scan validation |
| [STIG Implementation](STIG-Implementation/) | SOC | Windows 11 STIGs; PowerShell | Individual remediation scripts (e.g. Secondary Logon, Autoplay, UAC) |

<!-- Placeholder: add a row for Python + AI Automation (log parsing / TI enrichment) once the code and write-up are uploaded. -->

---

## Skills and tools

**SOC:** Microsoft Sentinel, Microsoft Defender XDR, KQL / Advanced Hunting, alert triage, host isolation, threat hunting  
**GRC / audit:** Control validation, risk assessment, vulnerability prioritization, CAB / change governance, post-incident reporting  
**Frameworks referenced in this repo:** NIST CSF 2.0, NIST SP 800-53, CIS Controls, ISO 27001 Annex A, OWASP LLM Top 10, STIGs  
**Other:** Azure (VMs, NSG), Tenable Nessus, PowerShell

---

## Contact

[LinkedIn — Sadhvi Alam](https://www.linkedin.com/in/sadhvi-alam-2643a430/)
