$lastThree = { $env:computername; Get-Hotfix -cn . |  Select-Object PSComputerName,HotFixID,InstalledOn,InstalledBy | Sort InstalledOn | select -Last 3}
echo $lastThree
