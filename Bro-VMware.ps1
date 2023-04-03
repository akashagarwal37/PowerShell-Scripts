Clear
#Define Path and Variables required. 
    $ServerFile = "C:\Users\Documents\Script\server.txt"
    $global:URI = 

#Clear any pervious content in files. 
    #Clear-Content $ServerFile

#Fetch vCenter Details from Oasis. 
    Write-Host "*****Start of Script to Add Virtual Disk to VM *****" -ForegroundColor DarkMagenta
    #$Cred= Get-Credential -Message "Enter Credentials for vCenter Server"
    Write-Host "Provide List of Servers in the notepad"
    Invoke-Item $ServerFile
    Pause
    $OASIS = 
    $ServerFileContent = Get-Content $ServerFile
    foreach ($Server in $ServerFileContent)
        {     
            ####Get Details Using API for each Server#####
	$vCenterServer=$OASISDetails.vCenterConsole
        Switch($vCenterServer)
            {
                ' ' { 
                      Write-Host "vCenter Server Details not available `n" -ForegroundColor Red
                      Continue
                    }

                default { Write-Host "vCenter Server for $Server is $vCenterServer `n"
                #$vc=Connect-VIServer $vCenterServer -Credential $Cred
                $vc=Connect-VIServer $vCenterServer
                Get-datastore -VM $Server
                #$DSFreeSpace= $DSDetails.FreeSpaceGB | write-output
                #$DSCapacity=$DSDetails.CapacityGB
                #$DSThreshold = $DSCapacity * 0.10
                #$DSAddSpace= Read-Host "Please enter disk size which needs to be added in GB"                
                #$Space= Get-Host "Please enter space to be added to disk on Server $Server"
                }
            }

        }
        
