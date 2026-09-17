# Executive Audit Report: Endpoint Containment & Control Validation

## 1. Incident Overview & Business Risk
An unauthorized access event occurred on `CORP-AP-WS01`, a critical workstation within the Accounts Payable department. Given the asset's proximity to financial workflows and vendor payment systems, the immediate risk involved potential financial fraud and data exfiltration. 

## 2. Policy Enforcement & SLA Adherence
Per the organization's Incident Response Policy, any asset exhibiting confirmed hands-on-keyboard attack behavior or unauthorized Tor network connections must be immediately isolated from the production network.
* **Detection Source:** Microsoft Defender for Endpoint (EDR)
* **Response Action:** Manual Full Device Isolation
* **Policy Status:** **COMPLIANT**

## 3. Evidence of Control Effectiveness
The following audit artifact validates that the containment control operated effectively, successfully isolating the threat and mitigating the financial risk to the organization.

* <img width="1858" height="977" alt="Screenshot 2026-09-17 160450" src="https://github.com/user-attachments/assets/ed18141c-ccc6-4701-9c89-e587825a457d" />


## 4. Remediation & Recommendations
* Initiate password resets and MFA token revocation for the compromised local admin account.
* Conduct a review of the Accounts Payable network segmentation to ensure endpoints cannot bypass proxy restrictions (e.g., Tor traffic).
