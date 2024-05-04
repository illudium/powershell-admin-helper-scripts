# Updated May 2 20204 2:36 PM
$appID = 'Mozilla.Firefox'

$DebugPreference = 'Continue'
$LogDate = (Get-Date).tostring("dd-MMM-yyyy_THH-mm-ss")
$logFileName="wingetUpdate_$appID_$LogDate.log"

$transcriptPath="C:\Windows\TEMP\$logFileName"

Start-Transcript -Path $transcriptPath -Force -NoClobber

$GetWingetPath = Resolve-Path 'C:\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_*_*__8wekyb3d8bbwe'

if ($GetWingetPath){
 $WingetPath = $GetWingetPath[-1].Path
}


try {
 Set-Location $WingetPath
 $upgradeInfo = &.\winget.exe search --id $appID --exact
 if ($upgradeInfo -match $appID) {
    Write-Output "Upgrade available for: $appID"
    &.\winget.exe upgrade --id $appID --silent --force --accept-package-agreements --accept-source-agreements
    #Stop-Transcript
    exit 0
 }else{
  Write-Output "No upgrade available for $appID at this time"
  exit 0
  #Stop-Transcript
 }
}
catch {
    #If there are errors, catch them and display
    Write-Output "The error is:"`n
    Write-Output "Message: [$($_.Exception.Message)"]
    exit 1
    #Stop-Transcript
}

finally {
  Stop-Transcript
}
catch [System.InvalidOperationException]{}