Param($Server,$SUser)
$ErrorActionPreference= 'stop'
$Filename = 'ErrorLog_'+(get-date -f yyyy-MM-dd)+'.txt'
$Filepath= 'C:\Users\unixbot\Documents\Scripts\errorlogs'
function Get-TimeStamp {return "[{0:MM/dd/yy} {0:HH:mm:ss}]" -f (Get-Date)}
try{
####Set Credentials
$user =
$pass= cat 'C:\Users\Documents\securepass.txt' | convertto-securestring
$cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $user,$pass
$File = "C:\Users\Documents\Final\CSVReports\${SUser}_HC.xlsx"
####Create CIM Session
	$Session = New-CimSession -ComputerName $Server -Credential $cred
    Write-Host ("Server Name `t`t : $Server")
####CPU Utilization
	$CU = Get-CimInstance -ClassName win32_processor -CimSession $Session
	$CU | select DeviceID,NumberOfCores, CurrentClockSpeed, MaxClockSpeed,NumberOfLogicalProcessors, LoadPercentage| Export-Excel $File -ClearSheet -WorksheetName "CPU Details" -BoldTopRow -AutoSize
	$CU_Check= $CU | Measure-Object -Property LoadPercentage -Average | Select-Object -ExpandProperty Average

	if($CU_Check -gt '90') 
		{
			Write-Host "CPU Utilization `t : $CU_Check% `t`t(High) `t ***Please Check process consuming CPU***"
		}
	else 
		{
			Write-Host "CPU Utilization `t : $CU_Check% `t`t(Normal)" -ForegroundColor Green 
		}

####Memory Utilization
	$MU = Get-CimInstance -ClassName win32_operatingsystem -CimSession $Session
	$MU_Check= (($MU.FreePhysicalMemory/$MU.TotalVisibleMemorySize)*100).ToString("#.##")

	if($MU_Check -gt '90') 
		{
			Write-Host "Memory Utilization `t : $MU_Check% `t(High) `t`t ****Please check for Process(s) consuming Memory****" -ForegroundColor Red -BackgroundColor Yellow
		}
	else 
		{
			Write-Host "Memory Utilization `t : $MU_Check% `t(Normal)" -ForegroundColor Green 
		}

	$MU_Full=$MU| select @{n='Size(GB)';e={[math]::round($_.TotalVisibleMemorySize/1mb,2)}},@{n='Free(GB)';e={[math]::round($_.FreePhysicalMemory/1mb,2)}}, @{n='Free%';e={[math]::round(($_.FreePhysicalMemory/$_.TotalVisibleMemorySize)*100,2)}}
	$MU_Full |  Export-Excel $File -ClearSheet -WorksheetName "Memory_Details" -AutoSize -BoldTopRow

####Ping Test
	$PT= Test-Connection -ComputerName $Server -quiet
	If($PT){Write-Host "Ping Test `t`t`t : Successful"}
	else{Write-Host "Ping Test `t`t`t : Failed!!! , Check Server Connectivity"}

####Disk Utilization
	$hash = @{
		2 = "Removable disk"
		3= "Fixed local disk"
		4= "Network disk"
		5 = "Compact disk"}

	$DU= Get-CimInstance -ClassName win32_logicaldisk -CimSession $Session
    Write-Host "Disk Utilization: "
	foreach ($disk in $DU)
		{
			if ($disk.size -gt '0'){
            $Drive= $disk.deviceid
            $Disk_Free = (($disk.freespace/$disk.size)*100).tostring("#.##")
			if ($Disk_Free -lt '10'){Write-host "$Drive $Disk_Free% Free (High), ****Please check for files consuming Disk****"}
            elseif ($Disk_Free -le '10' -and $Disk_Free -ge '15') {Write-host "$Drive $Disk_Free% Free (Warning), ****Please check for files consuming Disk****"}		
            else {Write-host "$Drive $Disk_Free% Free (Normal)"}
		}}
	#$DU_Check = $DU | select @{n="Drive";e={$_.deviceid}},@{n="Free%" ; e={[math]::round(($_.freespace/$_.size)*100,2)}} |ft -AutoSize
	
	$DU_Full= $DU|select @{n="Drive";e={$_.deviceid}},volumename, @{n='DriveType' ; e={$hash.item([int]$_.DriveType)}}, @{n="Size(GB)" ; e={[math]::Round($_.size/1GB,2)}}, @{n="Free Space(GB)" ; e={[math]::Round($_.freespace/1GB,2)}}, @{n="Free%" ; e={[math]::round(($_.freespace/$_.size)*100,2)}} -ErrorAction SilentlyContinue
	
	$DU_Full|Export-Excel $File -ClearSheet -WorksheetName "Disk_Details" -AutoSize -BoldTopRow

Write-Host "`n***I can send email for Full Details,Type(Yes/No)***"
}
catch{  $Scriptname=$PSItem.InvocationInfo.scriptname
        Write-Host "General System Error!!!! `nApologies for inconvenience caused, OsBot Team is looking into the issue."
        Write-Output "`n" " $(Get-TimeStamp) $Suser" | Out-File $Filepath/$Filename -Append
        Write-Output "Script Name:- $Scriptname"| Out-File $Filepath/$Filename -Append
        $_.exception.message | Out-File $Filepath/$Filename -Append
      }