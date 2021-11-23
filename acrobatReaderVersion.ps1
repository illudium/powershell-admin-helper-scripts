$exe = "C:\Program Files*\Adobe\Acrobat *\Acrobat\Acrobat.exe"
$path = (Resolve-Path $exe).ProviderPath
if (Test-Path $path) {
  $AdobeInfo = Get-ItemProperty "HKLM:\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*" | where {$_.DisplayName -like 'Adobe Acrobat*' -and $_.DisplayName -NotLike '*Reader*'}
  $acro_prod = ($AdobeInfo | select-object -ExpandProperty DisplayName | %{$_.Split() | Select -Last 2}) -join ' '
  $acro_ver =  ($AdobeInfo | select-object -ExpandProperty DisplayVersion | %{$_.Split('.') | Select -First 3}) -join '.'
  $installDate = ($AdobeInfo | where {$_.DisplayName -like 'Adobe Acrobat*' -and $_.DisplayName -NotLike '*Reader*'} | select-object -ExpandProperty InstallDate).Insert(4,'-').Insert(7,'-')       
} 

else { $acro_prod = "n/a" }

$AcrobatInfo = -join($acro_prod, "`n", $acro_ver, "  ", "$installDate")
