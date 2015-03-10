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
  .Parameter service
    AOS Service Name   
  .Parameter threads
    Specify the maximum number of threads for the runspace pool	
  
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
	
	[Parameter(ParameterSetName='qeuryAos')]
    [Alias('s')]
    [switch]$status,
    
    [Parameter(mandatory=$false)]
    [Alias('h')]
    [string[]]$hosts = @('localhost'), 
    
    [Parameter(mandatory=$false)]
    [Alias('e')]
    [string]$service = 'AOS60$01',
	
	[Parameter(mandatory=$false)]
    [Alias('t')]
    [Int]$threads = 1
	
	
    )
    
    BEGIN {
        $serviceList = @()
        try {
            $ErrorActionPreference = "Stop";
            Write-Verbose "Gathering $($service) services on $($hosts)"
            $serviceList += Gather-Services -h $hosts -s $service
			Write-Verbose "Gathered $($serviceList.Count) services"
        } catch {
           return $_.Exception.Message
        } finally {
            $ErrorActionPreference = "Continue";
        }   
    }
    
    PROCESS {
		$Code = {
			param($Credentials,$ComputerName)
			$session = New-PSSession -ComputerName $ComputerName -Credential $Credentials
			Invoke-Command -Session $session -ScriptBlock {w32tm /resync /nowait /rediscover}
		}
	
	
        foreach ($srvc in $serviceList) {
            if($start.IsPresent) {
				Write-Verbose "Resuming $($srvc.Name) service on $($srvc.MachineName)"
                Resume-Service $srvc
				Write-Verbose "$($srvc.Name) service is now: $($srvc.status)"
            } elseif($stop.IsPresent) {
				Write-Verbose "Halting $($srvc.Name) service on $($srvc.MachineName)"
                Halt-Service $srvc
				Write-Verbose "$($srvc.Name) service is now: $($srvc.status)"
            } elseif($status.IsPresent) {
				$msg = "$($srvc.MachineName) `t $($srvc.Name) `t $($srvc.Status)"
				switch ($srvc.Status) 
				{ 
					"Stopped" 	{Write-Host "$msg" -foregroundcolor Red} 
					"Started" 	{Write-Host "$msg" -foregroundcolor Green} 
					"Running" 	{Write-Host "$msg" -foregroundcolor Green} 
					"Stopping"	{Write-Host "$msg" -foregroundcolor Orange} 
					"Starting" 	{Write-Host "$msg" -foregroundcolor Blue} 
					default {Write-Host "$msg"}
				}
            }
        }
    }
    
    END {
        Write-Host "Complete"
    }
}