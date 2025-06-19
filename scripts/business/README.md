# 🖥️ DSCP QoS for Windows 10/11 Business

This script configures Microsoft Teams DSCP (QoS) tagging for **Windows 10/11 Business or Pro** editions using PowerShell and `New-NetQosPolicy`.

---

## 🔧 Why This Script Exists

Intune Custom Configuration Profiles (OMA-URI) for DSCP tagging **only apply to Windows Enterprise or Education editions**.

This script provides a **workaround for Business editions**, applying local QoS rules directly through PowerShell — deployable via **Intune Device Scripts**.

---

## 📄 Script File
Set-TeamsQoS.ps1
Path: scripts/business/Set-TeamsQoS.ps1

🎯 What It Configures
Applies DSCP values to Microsoft Teams media workloads using the standard executable path:

C:\Program Files (x86)\Microsoft\Teams\current\Teams.exe
Media Type	DSCP Value	Source Port Range
Audio	46	50000–50019
Video	34	50020–50039
Screen Share	18	50040–50059
Signaling	40	50070–50089

Existing QoS policies with matching names will be removed before applying new ones.

🚀 Deployment via Intune
Log into the Intune Admin Center

Go to: Devices > Scripts > Add

Upload Set-TeamsQoS.ps1

Assign to a dynamic group for Business/Pro editions

Track results under: Devices > Script Status

⚠️ System Requirements
Windows 10/11 Business or Pro

PowerShell 5.1+

Local admin rights (during execution)

Teams installed at standard path

Intune Device Scripts enabled for target devices

🧠 Author
Edgar Avellan
Microsoft Teams & Endpoint Automation
Graph API | Intune | GitHub Actions | PowerShell

🌐 Reference
QoS in Microsoft Teams – Official Docs
