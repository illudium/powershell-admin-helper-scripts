# ADJUST LINE BELOW to account for the name of the VM for which you want backup result status
# Script must run the same day as the backup(s) occur, or adjust $tStr according to your needs

$serverName = "*File*Server*"
$tStr = (get-date -Format o).Split("T")[0]
$path = "C:\ProgramData\Altaro\AltaroBackupProfile\Logs\OpControllers"
$srvrBk = Get-ChildItem -Path $path\* -Include $tStr*$serverName* | Where-Object {($_.Name -match "_Failed" -or "Success") } | sls "CONTROLLER RESULT"
$srvBkResult = $srvrBk.Line.split('=')[1]

## Additional code to log result or include in a generated email
