# 🚀 Intune DSCP QoS Automation for Microsoft Teams (Demo Version)

This project automates the deployment of Microsoft Teams DSCP (Quality of Service) policies via **Microsoft Intune** and **Microsoft Graph** — specifically for **Windows 10/11 Enterprise** environments.

✅ No manual Intune portal setup  
✅ Fully automated with PowerShell + Microsoft Graph  
✅ Designed for infrastructure-as-code and CI/CD integration

---

## 🎯 Problem Solved

Microsoft Teams requires DSCP tagging for optimal call quality. Intune supports DSCP tagging via OMA-URI — but:
- It's **complex to configure manually**
- It’s **not supported** on Windows 10/11 **Business or Pro**

This repo automates policy creation for **Enterprise** devices using Microsoft Graph, and is structured to support CI/CD workflows (like GitHub Actions or Azure DevOps).

---

## 📦 What’s Inside

| File | Purpose |
|------|---------|
| `scripts/enterprise/create-intune-profile.ps1` | Deploys DSCP OMA-URI profile to Intune |
| `README.md` | Documentation (this file) |

> ⚠️ All sensitive credentials are redacted. Secrets are stored as environment variables in your pipeline.

---

## 🔧 What the Script Does

- Connects to Microsoft Graph via App Registration
- Deletes existing DSCP profiles by name (to avoid duplicates)
- Re-creates the profile with updated OMA-URI QoS values:
  - **Audio**: DSCP 46
  - **Video**: DSCP 34
  - **Screenshare**: DSCP 18
  - **Signaling**: DSCP 40
- Assigns the profile to an Azure AD group

---

## 📂 Repo Setup

1. Clone this repo  
2. Store your secrets in GitHub Actions or your CI pipeline:
   - `TENANT_ID`
   - `CLIENT_ID`
   - `CLIENT_SECRET`
3. Run the script manually or trigger it via GitHub Actions

---

## 💡 Designed By

**Edgar Avellan**  
Microsoft Teams & Security Administrator  
*GitHub Actions | Intune | Microsoft Graph | PowerShell*  

---

## 🌐 References

- [Microsoft Teams QoS via OMA-URI](https://learn.microsoft.com/en-us/microsoftteams/qos-in-teams)
- [Microsoft Graph API for Intune](https://learn.microsoft.com/en-us/graph/api/resources/intune-graph-overview)

---

> 🔒 Want the full version with dynamic OS filtering, PowerShell script deployment for Windows Business, and GitHub CI/CD integration? [Connect with me directly](https://www.linkedin.com/in/edgaravellan) to discuss access.
