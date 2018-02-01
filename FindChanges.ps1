$tfsServer = $args[0]
$sourceBranch = $args[1]
$targetDirectory = $args[2]

#$tfsServer = "http://tfsServer:8080/tfs"
#$sourceBranch = "$/TestProject/Application/Release1.0_Branch"
#$targetDirectory = "C:\TestFolder\TestFiles"


Add-Type -Path "C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\IDE\CommonExtensions\Microsoft\TeamFoundation\Team Explorer\Microsoft.TeamFoundation.VersionControl.Client.dll"
Add-Type -Path "C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\IDE\CommonExtensions\Microsoft\TeamFoundation\Team Explorer\Microsoft.TeamFoundation.WorkItemTracking.Client.dll"
Add-Type -Path "C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\IDE\CommonExtensions\Microsoft\TeamFoundation\Team Explorer\Microsoft.TeamFoundation.Client.dll"

$tfs = [Microsoft.TeamFoundation.Client.TeamFoundationServerFactory]::GetServer($tfsServer) 
$versionControlType = [Microsoft.TeamFoundation.VersionControl.Client.VersionControlServer] 
$versionControlServer = $tfs.GetService($versionControlType) 

$latest = [Microsoft.TeamFoundation.VersionControl.Client.VersionSpec]::Latest
$recursionType = [Microsoft.TeamFoundation.VersionControl.Client.RecursionType]::Full # 'Full'

$vCSChangeSets = $versionControlServer.QueryHistory($sourceBranch, $latest, 0, $recursionType, $null, $null, $null, [int32]::MaxValue, $false, $false)
$vCSChangeSets.GetType()


foreach ($Id in $vCSChangeSets.ChangesetID)
    {
    $Changes =$versionControlServer.GetChangeset($Id).Changes 

    foreach ($change in $Changes)
        {
          if($change.ChangeType -Match "Edit")
            {
              $change.Item.ServerItem
              $destinationPath = $change.Item.ServerItem.Replace($sourceBranch, $targetDirectory)
              #Write-Host "Download to" $([IO.Path]::GetFullPath($destinationPath)) -ForegroundColor Red
              $versionControlServer.DownloadFile($change.Item.ServerItem, $([IO.Path]::GetFullPath($destinationPath)))
            }
        }
    }
