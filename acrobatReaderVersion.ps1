# Define the next two variables, and modify the Set-Asset-Field at end of script
$appName = 'Adobe Acrobat Reader'
$displayName = "ReaderDC"
             
$appsList =  Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*',
                       'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*',
                       'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*',
                       'HKCU:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*' -ErrorAction Ignore                   


$appVer = $appsList | Where-Object {$_.DisplayName -match $appName} | Select-Object -Property DisplayVersion -ExpandProperty DisplayVersion
if ($appVer -ne "") { 
 $instDate = ($appsList | Where-Object {$_.DisplayName -match $appName} | Select-Object -Property InstallDate -ExpandProperty InstallDate).split(" ")[0].Insert(4,'-').Insert(7,'-')
 $AppInfo = -join($displayName, " ", "$appVer"," ", "$instDate")
 }

else { $ReaderInfo = "N/A" }

echo $AppInfo
Set-Asset-Field -Name "Adobe_Reader" -Value ($AppInfo)