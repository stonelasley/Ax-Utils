Function Stop-AOS
{
 <#
  .Synopsis
    Converts Bytes into the appropriate unit of measure. 
   .Description
    The Get-OptimalSize function converts bytes into the appropriate unit of 
    measure. It returns a string representation of the number.
   .Example
    Get-OptimalSize 1025
    Converts 1025 bytes to 1.00 KiloBytes
    .Example
    Get-OptimalSize -sizeInBytes 10099999 
    Converts 10099999 bytes to 9.63 MegaBytes
   .Parameter SizeInBytes
    The size in bytes to be converted
   .Inputs
    [int64]
   .OutPuts
    [string]
   .Notes
    NAME:  Get-OptimalSize
    AUTHOR: Ed Wilson
    LASTEDIT: 1/4/2010
    KEYWORDS:
   .Link
     Http://www.ScriptingGuys.com
 #Requires -Version 2.0
 #>
    [CmdletBinding()]
	PARAM (
    [string[]]$hosts, 
    [string]$serviceName = 'AOS60$01'
    )
    
    BEGIN {
        $MAosServices = @()
        #Getting All AOS Services
        foreach ($aosSrvr in $hosts) {
            echo $aosSrvr
            try {
             $MAosServices += Get-Service $serviceName -ComputerName $aosSrvr
            } catch [Exception] {
               return $_.Exception.Message
            }  	
        }

    }
    
    PROCESS {
        foreach ($aosSrvc in $MAosServices) {
            echo $aosSrvc.Name
            echo $aosSrvc.MachineName
        	stopService $aosSrvc
        }
    }
    
    END {
    
    }
} #end Function Stop AOS 

function AxUtilStopService ($service) {
	#Stopping SSRS Service
	Write-Host "Stopping $($service.Name) on $($service.MachineName)... be patient this will take several minutes" -foregroundcolor yellow
	#Stop-Service $service
	#$service.WaitForStatus('Stopped')
	Write-Host "$($service.Status)" -foregroundcolor green
}