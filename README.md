# Ax-Utils
Microsoft Dynamics AX Utilities

```PowerShell
PS C:\> echo $env:PSModulePath
C:\Users\slasley\Documents\WindowsPowerShell\Modules;C:\Windows\system32\WindowsPowerShell\v1.0\Modules\
```
______________________________________________________________________________________________________________________________________________________
Create the first directory (under your user profile) if it doesn't exist
clone this repository in that location. 
```PowerShell
PS C:\> git clone git@github.com:stonelasley/Ax-Utils.git $env:USERPROFILE\Documents\WindowsPowerShell\Modules\Ax-Utils
```
You can then Import the module
1. Check that Windows recognizes it as a module 
```PowerShell
PS C:\> Get-Module -ListAvailable
____________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________________
PS C:\> Get-Module -ListAvailable

ModuleType Name                      ExportedCommands                                                           
---------- ----                      ----------------                                                           
Script     Ax-Utils                  {}                                                                         
Manifest   AppLocker                 {}                                                                         
Manifest   BitsTransfer              {}                                                                         
Manifest   PSDiagnostics             {}                                                                         
Manifest   TroubleshootingPack       {}      
```
2. Import the Module
```PowerShell
PS C:\> Import-Module Ax-Utils
```
______________________________________________________________________________________________________________________________________________________