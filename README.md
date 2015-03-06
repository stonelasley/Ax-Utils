# Ax-Utils
Microsoft Dynamics AX Utilities

 ## Installation
  1. Find your powershell module path
  ```PowerShell
  PS C:\> echo $env:PSModulePath
  C:\Users\slasley\Documents\WindowsPowerShell\Modules;C:\Windows\system32\WindowsPowerShell\v1.0\Modules\
  ```
  ______________________________________________________________________________________________________________________________________________________
  2. Create the first directory (under your user profile) if it doesn't exist
  ```PowerShell
  PS C:\> New-Item "$env:USERPROFILE\Documents\WindowsPowerShell\Modules" -type directory
  ```
  3. Clone this repository in that location. 
  ```PowerShell
  PS C:\> git clone git@github.com:stonelasley/Ax-Utils.git $env:USERPROFILE\Documents\WindowsPowerShell\Modules\Ax-Utils
  ```
  4. Check that Windows recognizes it as a module 
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
  5. Import the Module
  ```PowerShell
  PS C:\> Import-Module Ax-Utils
  ```
  ______________________________________________________________________________________________________________________________________________________
  
 ## Usage
 1. Query, Stop, and Start services in batches. 
 ![alt tag](https://dl.dropboxusercontent.com/u/29534952/img/Ax-Utils.PNG)