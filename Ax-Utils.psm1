
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
        foreach ($aosSrvr in $hosts) {
            try {
                $ErrorActionPreference = "Stop"; #stop on errror
                Write-Verbose "Getting $($serviceName) service on $($aosSrvr)"
                $MAosServices += Get-Service $serviceName -ComputerName $aosSrvr
                
            } catch {
               Write-Host "EEYYY"
               return $_.Exception.Message
            } finally {
                $ErrorActionPreference = "Continue";
            }
        }

    }
    
    PROCESS {
        foreach ($aosSrvc in $MAosServices) {
            Write-Host $aosSrvc
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

function Halt-Service {
    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Medium')]
	
    PARAM (
    [Parameter(Position=0, ValueFromPipelineByPropertyName=$true, Mandatory=$true)]
    $service
    )
    
    BEGIN {

    }
    
    PROCESS {
        
        Write-Verbose "Attempting to Stop $($service.Name) on $($service.MachineName)... be patient this will take several minutes"
        if ($pscmdlet.ShouldProcess($service.MachineName)) {
            spsv $aosSrvc.Name
            $service.WaitForStatus('Stopped')
        }
        Write-Verbose "$($aosSrvc.Name): $($aosSrvc.Status)"
    }
    
    END {
    
    }
    
}

function Resume-Service {
    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Medium')]
	
    PARAM (
    [Parameter(Position=0, ValueFromPipelineByPropertyName=$true, Mandatory=$true)]
    $service
    )
    
    BEGIN {

    }
    
    PROCESS {
        
        Write-Verbose "Attempting to Start $($service.Name) on $($service.MachineName)... be patient this will take several minutes"
        if ($pscmdlet.ShouldProcess($service.MachineName)) {
            sasv $aosSrvc.Name
            $service.WaitForStatus('Running')
        }
        Write-Verbose "$($aosSrvc.Name): $($aosSrvc.Status)"
    }
    
    END {
    
    }
    
}