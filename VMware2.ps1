Clear
####Check if PowerCLI module is installed, if not then it will be installed#### 

    if(-not (Get-Installedmodule -name VMware* -ErrorAction SilentlyContinue))
    { 
        Write-warning "Module is not Installed, Proceeding with PowerCLI Module Install"
        Install-Module -Name VMware.PowerCLI –Scope CurrentUser -Verbose -ErrorAction Stop 
        Write-host "Module has been intalled Successfull"
    } 
    if (!(test-path '.\serverlist.txt'))
         { New-Item .\serverlist.txt}
    else 
         {clear-content .\serverlist.txt}

#Define Path and Variables required. 
    $ServerFile = ".\serverlist.txt"
    $global:URI = 

#Fetch vCenter Details from Oasis. 
    Write-Host "*****Start of Script to Add Virtual Disk to VM *****" -ForegroundColor DarkMagenta
    Write-Host "Provide List of Servers in the notepad"
    Invoke-Item $ServerFile
    Pause
    $OASIS = New-WebServiceProxy $URI -class server -namespace webservice
    $ServerFileContent = Get-Content $ServerFile
    foreach ($Server in $ServerFileContent)
        {     
            $OASISDetails = $OASIS.OASISInfobyServerName("$Server")
            $OASISDetails | select DeviceName,vCenterConsole,OSDescription,SupportStageDescription,SupportDescription,SupportEnvDescription
            $vCenterServer=$OASISDetails.vCenterConsole
        Switch($vCenterServer)
            {
                ' ' { 
                      Write-Warning "vCenter Server Details not available `n" -ErrorAction Continue
                    }}
    $Cred= Get-Credential -Message "Enter Credentials for vCenter Server $vCenterServer"
    $vc=Connect-VIServer $vCenterServer -Credential $Cred
    $DSAddSpace= Read-Host "Disk Size to be added to $Server"
    
#Fetch Datastore details for VM
    $DSDetails= Get-datastore -VM $Server | where-object {$_.name -notlike "*ISO*" -and $_.Name -notlike "*template*" -and $_.Name -notlike "*arep*" -and $_.Name -notlike "*dnu*" -and $_.Name -notlike "*MGMT*" -and $_.Name -notlike "*ORAC*" -and $_.State -notlike "Unavailable"}
    
#Fetch Required Parameter to apply threshold logic 
    
    [Decimal]$DSFreeSpace= $DSDetails.FreeSpaceGB
        write-host "Free space availabe on Datastore $DSDetails is $DSFreeSpaceAfterAdd `n"
    [Decimal]$DSCapacity= $DSDetails.CapacityGB * (10/100)
        write-host "Threshold for Datastore $DSDetails is $DSCapacity `n"
    [Decimal]$DSFreeSpaceAfterAdd = $DSFreeSpaceAfterAdd - $DSAddSpace
        write-host "Free Space on Datastore $DSDetails after adding $DSAddSpace GB is $DSFreeSpaceAfterAdd `n"
    if ($DSFreeSpaceAfterAdd -ile $DSCapacity)
        { Write-warning "Adding $DSAddSpace GB disk will breach 10% Threshold Criteria for datastore $DSDetails. `n" -ErrorAction Continue}
    else    
        {
                #Getting disks added to VM 
                Write-Host " Disk Available before adding new Disk `n"
                get-harddisk -VM $Server | select Filename, CapacityGB, StorageFormat |sort -Property Filename -Descending| format-table -AutoSize 
                write-host "Adding $DSAddSpace GB disk to $Server on Datastore $DSdetails"
                new-harddisk -VM $Server -CapacityGB $DSAddSpace -Datastore $DSDetails
                Write-Host " Disk Available after adding new Disk `n"
                get-harddisk -VM $Server |select Filename, CapacityGB, StorageFormat |sort -Property Filename -Descending| format-table -AutoSize 
        }
        }