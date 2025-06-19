---

## 🚀 CI/CD via GitHub Actions

This folder includes a GitHub Actions workflow to automate the deployment of this DSCP Intune profile.

### 🔄 How to Use It

1. Go to your repo: `Settings > Secrets and variables > Actions`
2. Add the following **secrets**:
   - `TENANT_ID`
   - `CLIENT_ID`
   - `CLIENT_SECRET`

3. Go to the **Actions** tab in GitHub
4. Run the `Deploy DSCP QoS (Enterprise Edition)` workflow manually
5. Done ✅

This will securely deploy the DSCP Intune Configuration Profile using app-only Microsoft Graph authentication.

📄 Workflow file: `.github/workflows/intune-profile-enterprise.yml`
