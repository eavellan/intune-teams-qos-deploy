# 🏁 Microsoft Teams DSCP QoS Deployment via Intune

This repo automates the deployment of Microsoft Teams **Quality of Service (QoS)** policies for both:

- **Windows 10/11 Enterprise or Education** via Intune Custom Profiles (OMA-URI + Graph API)
- **Windows 10/11 Business** via native PowerShell and Intune Script deployment

---

## 🔁 Deployment Matrix

| Edition                  | Method                             | Location                                |
|--------------------------|------------------------------------|-----------------------------------------|
| Windows 10/11 Enterprise | OMA-URI via Microsoft Graph        | `scripts/enterprise/create-intune-profile.ps1` |
| Windows 10/11 Business   | PowerShell script via Intune       | `scripts/business/Set-TeamsQoS.ps1`           |

---

## 💡 Why Two Paths?

Microsoft Intune only supports OMA-URI DSCP policies on **Enterprise** or **Education** editions. For **Business**, the DSCP settings must be applied locally via PowerShell.

This repo automates both approaches and demonstrates Infrastructure-as-Code for endpoint configuration.

---

## ✅ What’s Included

### 1. `create-intune-profile.ps1`
- Uses Microsoft Graph API and app-only auth
- Creates a custom Intune configuration profile
- Populates DSCP tags via OMA-URI for:
  - Audio (DSCP 46)
  - Video (DSCP 34)
  - Screensharing (DSCP 18)
  - Signaling (DSCP 40)
- Assigns to the group `SNS Active Users`
- CI/CD ready with GitHub Actions support

### 2. `Set-TeamsQoS.ps1`
- Uses PowerShell’s `New-NetQosPolicy`
- Targets `Teams.exe` with DSCP tags
- Can be uploaded via **Intune > Devices > Scripts**
- Filters devices to **Business** editions dynamically

---

## 🚀 How to Use

### For Enterprise

1. Add GitHub secrets:
   - `TENANT_ID`
   - `CLIENT_ID`
   - `CLIENT_SECRET`
2. Run the GitHub Action: `deploy-enterprise-profile.yml`
3. Done — Intune policy will be created and assigned.

> ⚠️ The OMA-URI policy only works on Enterprise/Education editions.

---

### For Business

1. Upload `Set-TeamsQoS.ps1` in Intune:
   - Go to: `Devices > Scripts > Add`
2. Assign to your Windows 10/11 Business group
3. Monitor script results under `Devices > Script Status`

---

## 🔒 API Permissions Required

To use Microsoft Graph (for Enterprise script), ensure your Azure App Registration has:

- `DeviceManagementConfiguration.ReadWrite.All`
- `Group.Read.All`

With admin consent.

---

## 🌱 Why This Matters

This repo is designed to:

- Replace manual DSCP tagging with automation
- Extend Teams QoS configuration to all Windows editions
- Showcase DevOps and Intune skills using GitHub, Graph, and PowerShell
- Help IT admins bridge the gap between **security**, **networking**, and **device management**

---

## 🙋‍♂️ Author

**Edgar Avellan**  
Microsoft Teams & Security Professional  
*GitHub | Microsoft Graph | Intune | PowerShell | Defender | CI/CD Learner*

---

🧠 Still Exploring
Deeper CI/CD best practices (manual vs. automated triggers)
How this connects with Desired State Configuration (DSC)
Limitations of configuring Teams policies via Intune (many are user-based, not device-based)

🤝 Let’s Connect
Want to learn or build together?
Feel free to connect with me on [LinkedIn](https://www.linkedin.com/in/edgaravellan)
