 <#
        .SYNOPSIS
        HealthCheck Script

        .DESCRIPTION
        This script will fetch the healthcheck information of any system

        .PARAMETER Name
        HealthCheck Script.

        .INPUTS
        None. 

        .OUTPUTS
        The healthcheck report

        .VERSION
        1.0

        .DEVELOPER
        vRO Automation Team
    #>
$(try
{
    #Inputs
    $serverName = "[serverName]"

    #Defining the PS object to store the commands output
    $psObj = New-Object PSObject -Property @{
        "Hostname"                       = hostname
        "System Boot Time"               = ($(systeminfo|FIND "System Boot Time") -split("Time:"))[1].trim() 
        "CPU Load"                       = $(Try{Get-Process | Sort-Object CPU -Descending | Select-Object -First 10 -ErrorAction SilentlyContinue | Format-Table -Wrap}catch{$_.Exception.message})
        "Memory Usage"                   = $(wmic OS get FreePhysicalMemory,FreeVirtualMemory,FreeSpaceInPagingFiles /VALUE) | ?{$_ -ne ""}
        "Page File Details"              = $(wmic pagefile list /format:list) | ?{$_ -ne ""}
        "OS File Location"               = (Get-WmiObject Win32_OperatingSystem).SystemDrive
        "Drive utilization"              = $(Try{get-WmiObject win32_logicaldisk -ErrorAction stop}catch{$_.Exception})
        "Monitoring Agent Running"       = $(Try{get-service "winrm" -ErrorAction stop | Format-Table -Wrap }catch{$_.Exception.message})
        "Backup Agent Running"           = $(Try{get-service "smcservice" -ErrorAction stop | Format-Table -Wrap }catch{$_.Exception.message})
        "SSSD/Authentication running"    = $(ping nmp.mx.com)
        "Network Interface Errors"       = $(netsh interface ipv4 show ipstats)
        "System Errors"                  = $(Try{$(Get-EventLog -LogName System -EntryType Error -Newest 10 -ErrorAction Stop | Format-Table -Wrap)}catch{$_.Exception.message})
    }

    #Print the values of the script
    $psObj | Select Hostname, "System Boot Time", "OS File Location" | Format-List
    foreach($obj in $psObj.PSObject.Properties)
    {
        if($obj.Name -ne "Hostname" -and $obj.Name -ne "System Boot Time" -and $obj.Name -ne "OS File Location")
        {
            $obj.Name
            "*************************************************************************************"
            $obj.Value
            ""
            ""
        }
    }

}
catch
{
    "UNIQUEERRORCODE : Error occured in the scripts $($_.Exception)"
} ) |  Out-File C:\Users\241817\Documents\scriptOut.txt