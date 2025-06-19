# 🖥️ Microsoft Teams DSCP QoS for Windows 10/11 Business

This script configures Microsoft Teams DSCP (Quality of Service) tagging for **Windows 10/11 Business or Pro** editions using local PowerShell (`New-NetQosPolicy`). It is designed to be deployed via **Microsoft Intune Device Scripts**.

---

## ❓ Why This Script Exists

Intune’s OMA-URI-based DSCP tagging only works on **Windows Enterprise/Education** editions.  
On **Business** or **Pro**, those policies silently fail.

This script solves that limitation by applying QoS settings directly through native PowerShell, ensuring Teams traffic is correctly prioritized across your network.

---

## 📂 Script Path
scripts/business/Set-TeamsQoS.ps1

---

## ⚙️ What It Does

Applies DSCP tagging to Microsoft Teams media workloads:

| Media Type    | DSCP Value | Source Port Range |
|---------------|------------|-------------------|
| Audio         | 46         | 50000–50019       |
| Video         | 34         | 50020–50039       |
| Screenshare   | 18         | 50040–50059       |
| Signaling     | 40         | 50070–50089       |

All traffic is matched against the standard Teams path:
C:\Program Files (x86)\Microsoft\Teams\current\Teams.exe


Before applying, any existing QoS policies with matching names are removed to prevent duplication.

---

## 🚀 Deployment via Intune

> 💡 This script is intended for use in **Microsoft Intune** under **Device Scripts**, not Win32 apps.

### 🔄 Steps:

1. Go to the [Intune Admin Center](https://endpoint.microsoft.com)
2. Navigate to: `Devices > Scripts > Add`
3. Upload `Set-TeamsQoS.ps1`
4. Assign the script to a dynamic Azure AD group (filtering for Windows 10/11 Business editions)
5. Monitor results via `Devices > Script Status`

---

## ✅ Requirements

- Windows 10/11 Business or Pro
- PowerShell 5.1+
- Local administrator privileges (script runs in SYSTEM context via Intune)
- Microsoft Teams installed in default location

---

## 🧠 Author

**Edgar Avellan**  
Microsoft Teams & Endpoint Automation | Intune | Microsoft Graph | GitHub Actions  

🔗 [LinkedIn](https://linkedin.com/in/edgaravellan)  
🗂️ Main Project Repo: [intune-teams-qos-deploy](https://github.com/eavellan/intune-teams-qos-deploy)

---

## 🌐 References

- [Microsoft Docs – QoS in Teams](https://learn.microsoft.com/en-us/microsoftteams/qos-in-teams#using-powershell-to-set-dscp-values)
- [Microsoft Docs – Intune Device Scripts](https://learn.microsoft.com/en-us/mem/intune/apps/intune-management-extension)

---

> 🛠 This script is part of a larger automation suite that also supports Windows Enterprise deployments via Microsoft Graph API and OMA-URI profiles. View the full project [here](https://github.com/eavellan/intune-teams-qos-deploy).






