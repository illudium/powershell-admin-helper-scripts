$exe = "C:\Program Files*\Google\Chrome\Application\chrome.exe"
if (Test-Path $exe) {
            $path = (Resolve-Path $exe).ProviderPath
            $ver = [System.Diagnostics.FileVersionInfo]::GetVersionInfo($path).FileVersion
        }       
Write-Host $ver