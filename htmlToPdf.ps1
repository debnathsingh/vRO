function htmlToPdf
{
    param (
        [Parameter(mandatory=$true)]
        $appName,

        [Parameter(mandatory=$true)]
        $filePath
    )

    #Define the inputs and outputs Path
    $outputPath = $inputPath.Split(".")[0]+".pdf"

    #Print the Input, Output and Application Path
    Write-Host  "--------------Inputs--------------"
    Write-Host  "Application Name : $appName"
    Write-Host  "Input Path : $inputPath"
    Write-Host  "Output Path : $outputPath"
    Write-Host ""

    try
    {
        #Test the input Path
        if(!(Test-Path $inputPath))
        {
            throw "$inputPath is not valid"
        }

        #Create the object for Process
        $pinfo = New-Object System.Diagnostics.ProcessStartInfo
        $pinfo.FileName = $appName
        $pinfo.RedirectStandardError = $true
        $pinfo.RedirectStandardOutput = $true
        $pinfo.UseShellExecute = $false
        $pinfo.Arguments = "--headless","--no-margins","--no-pdf-header-footer","--print-to-pdf=""$outputPath""","$inputPath"
        $p = New-Object System.Diagnostics.Process
        $p.StartInfo = $pinfo
        $p.Start() | Out-Null
        $p.WaitForExit()

        Write-Host  "--------------Outputs--------------"
        $stdout = $p.StandardOutput.ReadToEnd()
        $stderr = $p.StandardError.ReadToEnd()
        Write-Host "Exit Code: $($p.ExitCode)"
        Write-Host "stdout: $stdout"
        Write-Host "stderr: $stderr"
        Write-Host  ""

        #Check for error
        if($p.ExitCode -ne 0)
        {
            throw "stdout: $stdout, stderr: $stderr"
        }
        if(!(Test-Path $outputPath))
        {
            throw "Output $outputPath is not present"
        }
     }
     catch
     {
        "Error occured in the function htmlToPdf : $($_.Exception)"
     }
}

$chromePath = "C:\Program Files\Google\Chrome\Application\chrome.exe"
$edgePath = "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
$inputPath = "C:\TempNew\Integrated_Delivery_Scripts_IIS\Storage\NasuniHealthReport_DSO00002185_172_17_208_32_25052023112419.htm"

htmlToPdf -appPath $chromePath -filePath $inputPath
#htmlToPdf -appPath $edgePath -filePath $inputPath
