<#
    .SYNOPSIS
    Uninstall Windows Application/Service Script

    .DESCRIPTION
    This script will Uninstall Windows Application/Service from the System

    .PARAMETER Name
    Uninstall Windows Application/Service Script

    .INPUTS
    Application Name 

    .OUTPUTS
    The Logs of the script

    .VERSION
    1.0

    .DEVELOPER
    vRO Automation Team
#>


try
{
    #Inputs
    $application = "[Applications]"
    #$application ="FireFox"
    $SEARCH = $application
    #Write-Host "Looking for application on server.."
    $INSTALLED = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* |  Select-Object DisplayName, UninstallString
    $INSTALLED += Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName, UninstallString
    $RESULT = $INSTALLED | ?{ $_.DisplayName -ne $null } | Where-Object {$_.DisplayName -match $SEARCH } 
    $restart = $Flase

    if ($RESULT -eq $null)
    { 
	    $services= Get-WindowsOptionalFeature -Online -FeatureName $SEARCH

        <#if ($services -eq $null -or $services.State -eq "Disabled")
        {
            throw $SEARCH,"application/Service not found on server or already disabled"
        }
	    #>
        if ($services -eq $null)
        {
            Write-Host "Application/Service not found on server"
        }
        if ($services -ne $null -and $services.State -eq "Disabled")
        {
            Write-Host "Application/Service is already disabled"
        }
        else 
        { 
            Write-Host "Service found on server :",$services.DisplayName
            Write-Host "Service status : ", $services.State
            Write-Host "Initiating disable operation .."
            $a= Disable-WindowsOptionalFeature -Online -FeatureName $services.FeatureName -NoRestart
            if ($a.RestartNeeded) 
            {
                Write-Host "System reboot required to complete the operation"
                $restart= $True
                return $restart
            }
        }                                     
    }
    else
    {
          Write-Host "Application found :",$RESULT
          if ($RESULT.uninstallstring -like "msiexec*")
          {
                Write-Host "application uninstallation is in progress...."
                $ARGS=(($RESULT.UninstallString -split ' ')[1] -replace '/I','/X ') + ' /q'
                Start-Process msiexec.exe -ArgumentList $ARGS -Wait
                Write-Host "Application removed successfully from server"
          } 
          else 
          {
                Write-Host "application uninstallation is in progress...."
                $UNINSTALL_COMMAND=(($RESULT.UninstallString -split '\"')[1])
                $UNINSTALL_ARGS=(($RESULT.UninstallString -split '\"')[2]) + ' /S'
                Start-Process $UNINSTALL_COMMAND -ArgumentList $UNINSTALL_ARGS -Wait
                Write-Host "Application removed successfully from server"
          }
     }
}
catch
{
    "UNIQUEERRORCODE : Error occured in the scripts $($_.Exception)"
}