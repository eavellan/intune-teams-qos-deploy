<#
.SYNOPSIS
    Applies Microsoft Teams DSCP (QoS) tagging for Audio, Video, Screen Sharing, and Signaling on Windows 10/11 Business editions.

.DESCRIPTION
    This script uses New-NetQosPolicy to configure DSCP markings on ms-teams.exe.
    It is intended for deployment via Intune Device Scripts to environments where OMA-URI is not supported (e.g., Windows 11 Business).

.NOTES
    Author: Edgar Avellan
    Version: 1.0
    Target: Windows 10/11 Business
#>

# Set Teams executable path
$teamsPath = "C:\Program Files (x86)\Microsoft\Teams\current\Teams.exe"

# Exit if Teams is not installed
if (-not (Test-Path $teamsPath)) {
    Write-Output "❌ Teams executable not found at $teamsPath. Exiting."
    exit 1
}

# Function to safely remove existing policies
function Remove-QosIfExists {
    param([string]$name)
    if (Get-NetQosPolicy -Name $name -ErrorAction SilentlyContinue) {
        Remove-NetQosPolicy -Name $name -Confirm:$false
        Write-Output "🔁 Removed existing policy: $name"
    }
}

# Define QoS policies
$qosPolicies = @(
    @{ Name = "TeamsAudio";        DSCP = 46; Ports = "50000-50019" },
    @{ Name = "TeamsVideo";        DSCP = 34; Ports = "50020-50039" },
    @{ Name = "TeamsScreenshare";  DSCP = 18; Ports = "50040-50059" },
    @{ Name = "TeamsSignaling";    DSCP = 40; Ports = "50070-50089" }
)

foreach ($policy in $qosPolicies) {
    Remove-QosIfExists -name $policy.Name

    New-NetQosPolicy `
        -Name         $policy.Name `
        -AppPathNameMatchCondition $teamsPath `
        -IPProtocolMatchCondition UDP `
        -DSCPAction   $policy.DSCP `
        -SourcePortRange $policy.Ports `
        -PolicyStore  ActiveStore

    Write-Output "✅ Created DSCP policy: $($policy.Name) (DSCP $($policy.DSCP), Ports $($policy.Ports))"
}

Write-Output "🎉 Teams QoS DSCP policies applied successfully."
exit 0

