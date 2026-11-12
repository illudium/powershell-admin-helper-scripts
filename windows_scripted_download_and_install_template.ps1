## YOU SHOULD ONLY NEED TO EDIT $uri below and Parameterized switches below (if needed)

# 1. Configuration
$uri = "http://dl.google.com/edgedl/chrome/install/GoogleChromeStandaloneEnterprise64.msi"

#
# Parameterized switches
$msiSwitches = @("/qn", "/norestart") 

# 2. Resolve Pathing
$tempDir = [System.Environment]::GetEnvironmentVariable('TEMP', 'Machine')
if (-not (Test-Path -Path $tempDir)) {
    New-Item -Path $tempDir -ItemType Directory -Force | Out-Null
}

$msiName = Split-Path -Path $uri -Leaf
$msiPath = Join-Path -Path $tempDir -ChildPath $msiName

# Ensure TLS 1.2 and 1.3 are enabled
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 -bor [Net.SecurityProtocolType]::Tls13

# 3. Helper Functions
function Download-WithBits {
    param([string]$Source, [string]$Destination)
    try {
        Write-Host "Attempting download via BITS..."
        Start-BitsTransfer -Source $Source -Destination $Destination -ErrorAction Stop
        return (Test-Path $Destination)
    } catch {
        Write-Warning "BITS failed: $($_.Exception.Message)"
        return $false
    }
}

function Download-WithWebRequest {
    param([string]$Source, [string]$Destination)
    try {
        Write-Host "Attempting download via Invoke-WebRequest..."
        $oldPreference = $ProgressPreference
        $ProgressPreference = 'SilentlyContinue'
        
        Invoke-WebRequest -Uri $Source -OutFile $Destination -UseBasicParsing -ErrorAction Stop
        
        $ProgressPreference = $oldPreference
        return (Test-Path $Destination)
    } catch {
        Write-Warning "WebRequest failed: $($_.Exception.Message)"
        return $false
    }
}

# 4. Execution Logic
if (Test-Path $msiPath) { Remove-Item $msiPath -Force }

$downloadSuccess = Download-WithBits -Source $uri -Destination $msiPath

if (-not $downloadSuccess) {
    Write-Host "Falling back to WebRequest..." -ForegroundColor Yellow
    $downloadSuccess = Download-WithWebRequest -Source $uri -Destination $msiPath
}

if (-not $downloadSuccess) {
    throw "Critical Failure: Could not download MSI from $uri"
}

Write-Host "Success, file located at: $msiPath"

if ($downloadSuccess) {
    # 1. Combine arguments cleanly into an array.
    # We wrap the MSI path in literal double quotes to handle any potential spaces safely.
    $arguments = @("/i", "`"$msiPath`"") + $msiSwitches

    Write-Host "Running: msiexec.exe $($arguments -join ' ')" -ForegroundColor Cyan

    # 2. Execute and wait for completion
    $process = Start-Process -FilePath "msiexec.exe" -ArgumentList $arguments -Wait -NoNewWindow -PassThru

    # 3. Check the exit code (0 and 3010/reboot initiated are successful)
    if ($process.ExitCode -eq 0 -or $process.ExitCode -eq 3010) {
        Write-Host "Deployment Completed Successfully. (Exit Code: $($process.ExitCode))" -ForegroundColor Green
        exit 0
    } else {
        Write-Host "Deployment failed during installation. (Exit Code: $($process.ExitCode))" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "Deployment failed: Could not download file." -ForegroundColor Red
    exit 1
}

Remove-Item $msiPath