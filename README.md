# TFSDownloadFiles

## Purpose:
Main idea is to find the Release artifacts for non-compiled applications. 

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

### Example
```
FindChangese.ps1 "http://TFSSERVERNAME:8080/tfs" "$/TestProject/Application1/Releases/Release_Branch" "D:\TFS\Drop"
```

```
FindChangese.ps1 $(SYSTEM_TEAMFOUNDATIONCOLLECTIONURI) $(BUILD_SOURCESDIRECTORY) BUILD_ARTIFACTSTAGINGDIRECTORY
```

### Screenshots


      
      
