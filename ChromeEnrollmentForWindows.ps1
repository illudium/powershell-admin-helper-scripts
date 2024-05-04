#ChromeEnrollmentForWindows script

$DebugPreference = 'Continue'
$LogDate = (Get-Date).tostring("dd-MMM-yyyy_THH-mm-ss")
$logFileName="ChromeBrowser_managementEnrollment_$LogDate.log"

$transcriptPath="C:\Windows\TEMP\$logFileName"

Start-Transcript -Path $transcriptPath -Force -NoClobber

$regkey = 'HKLM:\SOFTWARE\Policies\Google\Chrome'
$name = 'CloudManagementEnrollmentToken'
$mgmtToken = '<yourChromeMgmtTokenHERE'

try{
$exists = Get-ItemProperty -path $regkey -name $name -ErrorAction SilentlyContinue
 
if ($exists.CloudManagementEnrollmentToken -eq $mgmtToken)
	{
		Write-Output "Registry Key Present"
		Exit 0	
	}
ELSE
	{
		Write-Output "Registry Key Missing"
		New-Item -Path $regkey -Force | Out-Null
		New-ItemProperty -Path $regkey -name $name -Value $mgmtToken `
		-PropertyType DWORD -Force | Out-Null
	}
}
catch{
Write-Output $_.Exception.Message
} 

finally {
  Stop-Transcript
}