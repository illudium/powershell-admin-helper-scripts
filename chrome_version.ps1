$exe = "C:\Program Files*\Google\Chrome\Application\chrome.exe"
$path = (Resolve-Path $exe).ProviderPath
if (Test-Path $path) {
            $path = (Resolve-Path $exe).ProviderPath
            $ver = [System.Diagnostics.FileVersionInfo]::GetVersionInfo($path).FileVersion
        }       
Write-Host $ver
