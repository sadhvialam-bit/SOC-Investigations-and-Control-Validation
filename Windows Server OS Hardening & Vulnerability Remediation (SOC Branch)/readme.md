**Objective:** To execute technical Security Technical Implementation Guides (STIGs) and patch management on a vulnerable Windows Server 2025 host, mitigating critical CVSS findings identified by Tenable Nessus.

## 1. Environment & Architecture
* **Target Asset:** `corp-ap-ws01` (Azure VM)
* **OS:** Windows Server 2025
* **Vulnerability Scanner:** Tenable Vulnerability Management (Authenticated Scan)

## 2. Technical Remediation Log

The following hardening measures were executed to resolve specific SLA violations flagged during the baseline discovery scan.

### A. Operating System Updates & Patch Management
* **Vulnerability:** Outdated Windows Defender Antimalware Signatures (High)
* **Execution:** Resumed paused OS updates via Windows Settings and modified Windows Update (AU) registry policies to allow automatic patching.
* **Evidence:**
<img width="1022" height="771" alt="Remediation 1a" src="https://github.com/user-attachments/assets/b48c85f6-532d-425e-9caf-6f24d7d50d10" />

  * [Windows Update Success]
    
<img width="1108" height="348" alt="Remediation 1b" src="https://github.com/user-attachments/assets/d13f6807-18e7-4c0a-bd35-1981af38e73c" />

  * [Registry Key Modification]

### B. IAM Privilege Revocation (OS Secure Config)
* **Vulnerability:** Unauthorized Guest Account in Local Administrators Group
* **Execution:** Executed `net localgroup Administrators Guest /delete` and deactivated the account via `net user Guest /active:no`.
* **Evidence:**

<img width="1110" height="211" alt="Remediation 2" src="https://github.com/user-attachments/assets/bd0642f4-e69f-461a-94d2-693aa16e8b6c" />

  * [Guest Account Removed]

### C. Third-Party Software Removal
* **Vulnerability:** Wireshark 2.2.1 EoL / Multiple CVEs (Critical)
* **Execution:** Executed a silent uninstallation script via PowerShell to permanently remove Wireshark 2.2.1 and WinPcap from the host, confirmed via the Installed Apps GUI.
* **Evidence:**

<img width="1283" height="731" alt="Remediation 3" src="https://github.com/user-attachments/assets/87234573-75a0-4fff-b1c1-868bf1c3d26f" />

  * [PowerShell Uninstall]

<img width="1020" height="604" alt="Remediation 3b" src="https://github.com/user-attachments/assets/29531781-cf87-413c-9d2e-1f2d942ce783" />

  * [GUI Verification]

### D. Enforce Secure Protocols (SMB & NLA)
* **Vulnerability:** SMB Signing Not Required & Terminal Services NLA Disabled (Medium)
* **Execution (SMB):** Enforced SMB signatures using `Set-SmbServerConfiguration -RequireSecuritySignature $true -EnableSecuritySignature $true -Force`.
* **Execution (NLA):** Enforced RDP Network Level Authentication by modifying `HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp` setting `UserAuthentication` to `1`.
* **Evidence:**

<img width="1110" height="247" alt="Remediation 4" src="https://github.com/user-attachments/assets/f0f4b814-f2b1-4f3d-b485-8f2404f4bb15" />

  * [SMB Enforcement]

<img width="1108" height="384" alt="Remediation 5" src="https://github.com/user-attachments/assets/25ada346-e631-404b-a8ad-9b8c35c9f12d" />

  * [NLA Enforcement]

### E. Legacy Protocol Deprecation
* **Vulnerability:** LM/NTLMv1 Authentication Enabled
* **Execution:** Restored secure default authentication by modifying `HKLM\SYSTEM\CurrentControlSet\Control\Lsa` and setting `LmCompatibilityLevel` to `5`.
* **Evidence:**

<img width="1107" height="242" alt="Remediation 6" src="https://github.com/user-attachments/assets/d6577b1d-8eb4-474c-8df1-58b162316c29" />

  * [LAN Manager Auth Restored]

## 3. Final Validation
Post-remediation, the virtual machine was restarted to commit registry and OS changes. A final authenticated Tenable scan was executed, confirming the successful mitigation of all targeted vulnerabilities. 

* **Residual Risk:** 2 Critical (libcurl native to OS, awaiting Microsoft patch), 2 Medium (Expected Self-Signed Certs).
* **Evidence:**

<img width="1377" height="181" alt="Post remediation" src="https://github.com/user-attachments/assets/54fb8702-d07b-4fd6-af77-e3346a89194e" />

  * [Final Dashboard Validation]
