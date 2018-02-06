# TFSDownloadFiles

## Purpose:
Main idea is to find the Release artifacts for non-compiled applications. 

When we do adopt Continuous Deployment with TFS, how do we define the only changed files within the release branch for non-compiled applications? The attached script will get you find and download only the files that has modified from the given release (or source control application branch) branch.

## Prerequisites

*	This script is tested in on-prem TFS 2015 environment only

*	Build agent must have Visual Studio 2015 installed

*	Build service account should have enough permissions on the box to download files (May be admin group member on the build server)

## How to use this?

1.	Download the “FindChangese.ps1” file from repository,

2.  Check-in “FindChangese.ps1” to TFS Source control

3.	The script requires 3 parameters in below given order.
      
      i.	First one should be TFS Server url (Or use pre-defined variable as $(SYSTEM_TEAMFOUNDATIONCOLLECTIONURI)
      
      ii.	Source control path of TFS Release branch
      
      iii.	Local file path on build server where the files should be downloaded to. (Or we can use TFS Build artifacts staging directory to download files)

4. Call the above powershell script as shown below within build script.

### Example 1
```
FindChangese.ps1 "http://TFSSERVERNAME:8080/tfs" "$/TestProject/Application1/Releases/Release_Branch" "D:\TFS\Drop"
```

### Screenshots


![ScreenShot](https://github.com/haribabubavanari/TFSDownloadFiles/blob/master/Example1.png)
      

### Example 2
You can pass predefined variables as parameters in TFS Build. Make sure your repository mapping limited to your release branch only, otherwise $(Build.SourceBranch) will result in to root level path ($\Team Project).

```
FindChangese.ps1 $(SYSTEM.TEAMFOUNDATIONCOLLECTIONURI) $(Build.SourceBranch) $(BUILD.ARTIFACTSTAGINGDIRECTORY)
```

### Screenshots


![ScreenShot](https://github.com/haribabubavanari/TFSDownloadFiles/blob/master/Example3.png)
      
      
