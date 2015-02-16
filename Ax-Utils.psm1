Function Aos-Mgr
{
 <#
  .Synopsis
    Facilitates the management of multiple AOS services across multiple machines. 
  
  .Description
    Allows the management of a multiple AOS environment.
  
  .Example
    Aos-Mgr -start 
    Starts AOS60$01 Service on localhost
  
  .Example
    $servers = @(AOSSERVER01, AOSSERVER02, AOSSERVER03)
    Aos-Mgr -stop -hosts $servers 
    Starts AOS60$01 Service on AOSSERVER01, AOSSERVER02, AOSSERVER03
    
  .Example
    Aos-Mgr -start -m AOSSERVER01, AOSSERVER02, AOSSERVER03 -s = AXService
    Starts AXService Service on AOSSERVER01, AOSSERVER02, AOSSERVER03
  
  .Parameter start
    Start Application Object Service(s)
  .Parameter stop
    Stop Application Object Service(s)
  .Parameter hosts
    Specify hosts service lives on
  .Parameter serviceName
    AOS Service Name    
  
  .Inputs
    [string]
  
  .Notes 
      NAME:  AOS-Util
      AUTHOR: Stone C. Lasley
      LASTEDIT: 1/4/2010
      KEYWORDS:
  
  .Link
   Http://www.github.com/stonelasley
    
 #Requires -Version 2.0
 #>
    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Medium')]
    [OutputType([String])]
	
    PARAM (
    [Parameter(ParameterSetName='startAos')]
    [Alias('u')]
    [switch]$start,
    
    [Parameter(ParameterSetName='stopAos')]
    [Alias('d')]
    [switch]$stop,
    
    [Parameter(mandatory=$false)]
    [Alias('h')]
    [string[]]$hosts = @('localhost'), 
    
    [Parameter(mandatory=$false)]
    [Alias('s')]
    [string]$serviceName = 'AOS60$01'
    )
    
    BEGIN {

        $MAosServices = @()
        try {
            $ErrorActionPreference = "Stop"; #stop on errror
            Write-Verbose "Getting $($serviceName) service on $($aosSrvr)"
            $MAosServices += Gather-Services -h $hosts -s $serviceName
            
        } catch {
           Write-Host "EEYYY"
           return $_.Exception.Message
        } finally {
            $ErrorActionPreference = "Continue";
        }
        

    }
    
    PROCESS {
        foreach ($aosSrvc in $MAosServices) {
            if($start.IsPresent) {
                Resume-Service $aosSrvc
            } elseif($stop.IsPresent) {
                Halt-Service $aosSrvc
            }
        }
    }
    
    END {
        Write-Host "Complete"
    }
}