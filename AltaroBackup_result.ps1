# ADJUST LINE BELOW to account for the name of the VM for which you want backup result status
# Script must run the same day as the backup(s) occur, or adjust $tStr according to your needA

$serverName = "*File*Server*"
$tStr = (get-date -Format o).Split("T")[0]
$path = "C:\ProgramData\Altaro\AltaroBackupProfile\Logs\OpControllers"
$srvrBk = Get-ChildItem -Path $path\* -Include $tStr*$serverName*_Success.log | sls "ControllerRct.DoWork\(\)\: CONTROLLER RESULT"
$srvBkResult = $srvrBk.Line.split('=')[1]

## Additional code to log result or include in a generated email
