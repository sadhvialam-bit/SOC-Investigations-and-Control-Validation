# STIG Implementation

Windows 11 remediation scripts. The STIG ID and description in each row are taken from that script's header.

| Script | STIG ID | What it remediates |
| --- | --- | --- |
| [WN11-00-000175.ps1](WN11-00-000175.ps1) | WN11-00-000175 | Disables the Secondary Logon service to prevent alternate credential exposure. |
| [WN11-CC-000010.ps1](WN11-CC-000010.ps1) | WN11-CC-000010 | Disables the display of slide shows on the lock screen to prevent sensitive data exposure. |
| [WN11-CC-000040.ps1](WN11-CC-000040.ps1) | WN11-CC-000040 | Disables insecure guest logons to an SMB server to prevent unauthenticated access. |
| [WN11-CC-000190.ps1](WN11-CC-000190.ps1) | WN11-CC-000190 | Disables Autoplay for all drives to prevent the automatic execution of malicious code from media. |
| [WN11-CC-000205.ps1](WN11-CC-000205.ps1) | WN11-CC-000205 | Ensures Windows Telemetry is not configured to Full to limit data collection. |
| [WN11-CC-000270.ps1](WN11-CC-000270.ps1) | WN11-CC-000270 | Prevents passwords from being saved in the Remote Desktop Client to protect credentials. |
| [WN11-SO-000025.ps1](WN11-SO-000025.ps1) | WN11-SO-000025 | Renames the built-in guest account to mitigate unauthorized access. |
| [WN11-SO-000100.ps1](WN11-SO-000100.ps1) | WN11-SO-000100 | Enforces SMB packet signing for the client to prevent man-in-the-middle attacks. |
| [WN11-SO-000120.ps1](WN11-SO-000120.ps1) | WN11-SO-000120 | Enforces SMB packet signing for the server to prevent man-in-the-middle attacks. |
| [WN11-SO-000255.ps1](WN11-SO-000255.ps1) | WN11-SO-000255 | Automatically denies elevation requests for standard users to enforce UAC requirements. |
