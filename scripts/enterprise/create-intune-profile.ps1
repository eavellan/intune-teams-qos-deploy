# Redacted Demo: DSCP OMA-URI Policy Deployment via Microsoft Graph + PowerShell
# Author: Edgar Avellan
# Note: This is a demo version with placeholder secrets and AAD group names

# Load secrets from GitHub Actions (stored as encrypted secrets)
$tenantId     = $env:TENANT_ID     # e.g. "your-tenant-id-guid"
$clientId     = $env:CLIENT_ID     # e.g. "your-client-id-guid"
$clientSecret = $env:CLIENT_SECRET # e.g. "your-client-secret"

# Create credential object
$secureSecret = ConvertTo-SecureString $clientSecret -AsPlainText -Force
$credential   = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $clientId, $secureSecret

# Authenticate with Microsoft Graph
Connect-MgGraph -TenantId $tenantId -Credential $credential
Write-Host "`n✅ Connected to Microsoft Graph"

# Configuration profile name
$profileName = "Teams DSCP Marking Profile (Demo)"

# Delete existing profile with same name to avoid duplicates
$existing = Get-MgDeviceManagementDeviceConfiguration -Filter "displayName eq '$profileName'"
if ($existing) {
    Write-Host "🧹 Deleting existing profile ID $($existing.Id)..."
    Remove-MgDeviceManagementDeviceConfiguration -DeviceConfigurationId $existing.Id -Confirm:$false
}

# Lookup target AAD group by name (placeholder value)
$groupName = "Teams Device Group (Demo)"
$group     = Get-MgGroup -Filter "displayName eq '$groupName'"
if (-not $group) {
    Write-Error "❌ Azure AD group '$groupName' not found."
    exit 1
}
$groupId = $group.Id

Write-Host "✅ Target group resolved: $groupName ($groupId)"

# Define the Teams executable path and DSCP values
$teamsExePath = "C:\Program Files (x86)\Microsoft\Teams\current\Teams.exe"

$omaSettings = @(
    @{ OmaUri = "./Device/Vendor/MSFT/NetworkQoSPolicy/TeamsAudio/AppPathNameMatchCondition";       DataType = "String";  Value = $teamsExePath },
    @{ OmaUri = "./Device/Vendor/MSFT/NetworkQoSPolicy/TeamsAudio/DSCPAction";                      DataType = "Integer"; Value = 46 },
    @{ OmaUri = "./Device/Vendor/MSFT/NetworkQoSPolicy/TeamsAudio/SourcePortMatchCondition";        DataType = "String";  Value = "50000-50019" },

    @{ OmaUri = "./Device/Vendor/MSFT/NetworkQoSPolicy/TeamsVideo/AppPathNameMatchCondition";       DataType = "String";  Value = $teamsExePath },
    @{ OmaUri = "./Device/Vendor/MSFT/NetworkQoSPolicy/TeamsVideo/DSCPAction";                      DataType = "Integer"; Value = 34 },
    @{ OmaUri = "./Device/Vendor/MSFT/NetworkQoSPolicy/TeamsVideo/SourcePortMatchCondition";        DataType = "String";  Value = "50020-50039" },

    @{ OmaUri = "./Device/Vendor/MSFT/NetworkQoSPolicy/TeamsScreenshare/AppPathNameMatchCondition"; DataType = "String";  Value = $teamsExePath },
    @{ OmaUri = "./Device/Vendor/MSFT/NetworkQoSPolicy/TeamsScreenshare/DSCPAction";                DataType = "Integer"; Value = 18 },
    @{ OmaUri = "./Device/Vendor/MSFT/NetworkQoSPolicy/TeamsScreenshare/SourcePortMatchCondition";  DataType = "String";  Value = "50040-50059" },

    @{ OmaUri = "./Device/Vendor/MSFT/NetworkQoSPolicy/TeamsCMSignaling/AppPathNameMatchCondition"; DataType = "String";  Value = $teamsExePath },
    @{ OmaUri = "./Device/Vendor/MSFT/NetworkQoSPolicy/TeamsCMSignaling/DSCPAction";                DataType = "Integer"; Value = 40 },
    @{ OmaUri = "./Device/Vendor/MSFT/NetworkQoSPolicy/TeamsCMSignaling/SourcePortMatchCondition";  DataType = "String";  Value = "50070-50089" }
)

# Build configuration profile
$profile = @{
    "@odata.type" = "#microsoft.graph.windows10CustomConfiguration"
    displayName   = $profileName
    description   = "Demo: Teams QoS DSCP policy using OMA-URI"
    omaSettings   = @()
}

foreach ($setting in $omaSettings) {
    $odataType = switch ($setting.DataType) {
        "String"  { "#microsoft.graph.omaSettingString" }
        "Integer" { "#microsoft.graph.omaSettingInteger" }
        default   { throw "❌ Invalid setting type: $($setting.DataType)" }
    }

    $profile.omaSettings += @{
        "@odata.type" = $odataType
        displayName   = $setting.OmaUri.Split("/")[-1]
        description   = "DSCP setting for Teams media"
        omaUri        = $setting.OmaUri
        value         = $setting.Value
    }
}

# Create new configuration profile
Write-Host "`n🚀 Creating Intune profile..."
$createdProfile = New-MgDeviceManagementDeviceConfiguration -BodyParameter $profile
Write-Host "✅ Created: $($createdProfile.displayName) (ID: $($createdProfile.Id))"

# Assign profile to group
Write-Host "🔁 Assigning to group..."
$assignment = @{
    target = @{
        "@odata.type" = "#microsoft.graph.groupAssignmentTarget"
        groupId       = $groupId
    }
}
New-MgDeviceManagementDeviceConfigurationAssignment -DeviceConfigurationId $createdProfile.Id -BodyParameter $assignment
Write-Host "🎉 Intune DSCP deployment complete!"
