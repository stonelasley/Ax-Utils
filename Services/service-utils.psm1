Function Gather-Services
{
 <#
  .Synopsis
    Gathers services to enable acting upon them in groups.
  
  .Description
    Collects services. 
  
  .Example
    Aos-Mgr -start 
    Starts AOS60$01 Service on localhost
  
  .Example
    $servers = @(AOSSERVER01, AOSSERVER02, AOSSERVER03)
    Gather-Service -hosts $servers 
    Starts AOS60$01 Service on AOSSERVER01, AOSSERVER02, AOSSERVER03
    
  .Example
    Aos-Mgr -start -m AOSSERVER01, AOSSERVER02, AOSSERVER03 -s = AXService
    Starts AXService Service on AOSSERVER01, AOSSERVER02, AOSSERVER03
  
  .Parameter hosts
    Specify hosts service lives on
  .Parameter serviceName
    Service Name    
  
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
    PARAM (
    
    [Parameter(mandatory=$false)]
    [Alias('h')]
    [string[]]$hosts = @('localhost'), 
    
    [Parameter(mandatory=$false)]
    [Alias('s')]
    [string]$serviceName = 'AOS60$01'
    )
    
    BEGIN {
        $srvcList = @()
    }
    
    PROCESS {
        foreach ($host in $hosts) {
            Write-Verbose "Getting $($serviceName) service on $($host)"
            try {
                $ErrorActionPreference = "Stop"; #stop on errror
                $srvcList += Get-Service $serviceName -ComputerName $host
            } catch [ServiceCommandException] {
                return $_.Exception.Message
            } finally {
                $ErrorActionPreference = "Continue";
            }
            

        }
    }
    
    END {
        return $srvcList;
    }
}

function Halt-Service {
    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='High')]
	
    PARAM (
    [Parameter(Position=0, ValueFromPipelineByPropertyName=$true, Mandatory=$true)]
    $srvc
    )
    
    BEGIN {

    }
    
    PROCESS {
        
        Write-Verbose "Attempting to Stop $($srvc.Name) on $($srvc.MachineName)... be patient this will take several minutes"
        if ($pscmdlet.ShouldProcess($srvc.MachineName)) {
            spsv $srvc.Name
            $srvc.WaitForStatus('Stopped')
        }
        Write-Verbose "$($aosSrvc.Name): $($aosSrvc.Status)"
    }
    
    END {
    
    }
    
}

function Resume-Service {
    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='High')]
	
    PARAM (
    [Parameter(Position=0, ValueFromPipelineByPropertyName=$true, Mandatory=$true)]
    $srvc
    )
    
    BEGIN {

    }
    
    PROCESS {
        
        Write-Verbose "Attempting to Start $($srvc.Name) on $($srvc.MachineName)... be patient this will take several minutes"
        if ($pscmdlet.ShouldProcess($srvc.MachineName)) {
            sasv $srvc.Name
            $srvc.WaitForStatus('Running')
        }
        Write-Verbose "$($srvc.Name): $($srvc.Status)"
    }
    
    END {
    
    }
    
}