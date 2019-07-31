#FileName: DownloadChangeset.ps1
#Date: 02/09/2018

#This script is to download a specific given changeset version files from TFS. This script can excecute as part of TFS Builds/ manually by passing 3 parameters

#------Parameters---------
#$tfsServer = "http://tfsserver:8080/tfs"
#$targetDirectory = "C:\Users\bavanari_haribabu\Downloads\TestFiles"
#$changeSetNumbers = "2229, 2356 "

$tfsServer = $args[0]
$targetDirectory = $args[1]
$changeSetNumbers = $args[2]



Function Get-DownloadFile($changeSetNumber)
{
        #Get Changeset object for given changeset number. 
        $changeset = $versionControlServer.GetChangeset($changeSetNumber)

        Write-Host "    "
        Write-Host "==============================="
        Write-Host "Changeset ID: $changeSetNumber"
        Write-Host "==============================="
        #Run through each change in the changeset
        foreach ($change in $changeset.Changes)
        {
            $serverPath = $change.Item.ServerItem

	        Write-Host "Server Path: $serverPath"
            
            $tempPath =$serverPath -creplace '^[^\\]*\/COBOL\/', ''
            $tempPath = $tempPath -replace '/','\'

            $destinationPath = $targetDirectory+"\"+$tempPath
            Write-Host "Local Path: $destinationPath"
            Write-Host "    "
            
            $cvs =  New-Object Microsoft.TeamFoundation.VersionControl.Client.ChangesetVersionSpec $changeSetNumber
            $versionControlServer.DownloadFile($serverPath,0,$cvs,$destinationPath)              

        }
}



Write-Host "    "
Write-Host "+++++++++ START +++++++++++"
Write-Host "TFS Server Url =$tfsServer"
Write-Host "Directory to Download = $targetDirectory"

#Microsoft references to use TFS API
Add-Type -Path "C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\IDE\CommonExtensions\Microsoft\TeamFoundation\Team Explorer\Microsoft.TeamFoundation.VersionControl.Client.dll"
Add-Type -Path "C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\IDE\CommonExtensions\Microsoft\TeamFoundation\Team Explorer\Microsoft.TeamFoundation.WorkItemTracking.Client.dll"
Add-Type -Path "C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\IDE\CommonExtensions\Microsoft\TeamFoundation\Team Explorer\Microsoft.TeamFoundation.Client.dll"

#Get TFS Version Control object
$tfs = [Microsoft.TeamFoundation.Client.TeamFoundationServerFactory]::GetServer($tfsServer) 
$versionControlType = [Microsoft.TeamFoundation.VersionControl.Client.VersionControlServer] 
$versionControlServer = $tfs.GetService($versionControlType) 

$changesets= $changeSetNumbers.Split(',')
foreach($changeset in $changesets)
{
Get-DownloadFile($changeset)
}


Write-Host "+++++++++ END +++++++++++"

