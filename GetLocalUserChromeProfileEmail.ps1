# Updated Jan 22, 2025

#Checking for users logged in within the last 10 days
$username = (Get-LocalUser | Where-Object { $_.LastLogon -ge (Get-Date).AddDays(-10) -and $_.Enabled }).Name

# If no user found, fallback to current logged-in user
if (-not $username) {
    $username = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name.Split("\")[1]
}

$userSID = (Get-LocalUser -Name $username).SID.Value

$userProfilePath = Get-ItemPropertyValue "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\$userSID" ProfileImagePath

# Define the path to the local user's Chrome state path file
$ChromeStatePath = "$userProfilePath\AppData\Local\Google\Chrome\User Data\Local State"

# List of allowed domains
$allowedDomains = @(
    "company.com"
    "otherdomain.com"
)

# Function to extract the domain from an email address
function Get-DomainFromEmail {
    param (
        [string]$email
    )
    if ($email -match '@(.+)$') {
        return $matches[1]
    }
    return $null
}

# Check if the file exists
if (Test-Path $ChromeStatePath) {
    # Read and parse the JSON content
    $localStateContent = Get-Content $ChromeStatePath -Raw | ConvertFrom-Json

    # Navigate to the profile information in the JSON structure
    $profiles = $localStateContent.profile.info_cache.PSObject.Properties | ForEach-Object {
        [PSCustomObject]@{
            ProfileName = $_.Name
            ActiveTime  = $_.Value.active_time
            UserName    = $_.Value.user_name
        }
    }

    # Filter profiles with a valid email domain
    $profilesWithAllowedDomain = $profiles | Where-Object {
        $domain = Get-DomainFromEmail $_.UserName
        $domain -and ($allowedDomains -contains $domain)
    }

    # Sort the profiles by ActiveTime in descending order and take the top 2
    $mostRecent_ChromeUserEmails = ($profilesWithAllowedDomain | Sort-Object -Property ActiveTime -Descending | Select-Object -First 2).UserName

} else {
    Write-Output "Local State file not found at $ChromeStatePath"
    $mostRecent_ChromeUserEmails = "Not found"
}

## Additional items that may - or may not - be desired for the output
#$ComputerName = $env:COMPUTERNAME
#$SerialNumber = Get-WmiObject -class win32_bios | Select-Object SerialNumber
#$currentLocalUser = $username

Write-Output $mostRecent_ChromeUserEmails