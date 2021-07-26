$exe = "C:\Program Files*\Microsoft\Edge\Application\msedge.exe"

if (Test-Path $exe) {
  $product = "MS Edge"
  $EdgeVersion = (Get-ItemProperty "HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*" | where {$_.DisplayName -like 'Microsoft Edge'} | select-object -ExpandProperty Version)  
  $installDate = (Get-ItemProperty "HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*" | where {$_.DisplayName -like 'Microsoft Edge'} | select-object -ExpandProperty InstallDate).Insert(4,'-').Insert(7,'-')       
} 

else { $product = "n/a" }

$EdgeInfo = -join($product, "`n", $EdgeVersion, "  ", "$installDate")
