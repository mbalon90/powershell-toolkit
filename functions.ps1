#This file contains the main functions used in the PowerShell application. It includes functions for displaying messages, version information, and welcome messages.

<# .DESCRIPTION
Shows welcome logo #>
function welcome {
    param(
        [string]$Version
    )

    clear-host
    $line = "=" * 24
    Write-Host $line -ForegroundColor Green
    Write-Host " Scripting Toolkit v$Version"-ForegroundColor Green
    Write-Host " Get-Functions" -ForegroundColor Green
    Write-Host $line -ForegroundColor Green
}

<# .DESCRIPTION 
Shows a hello message #>
function Test-Hello {
    Write-Host "Hello"
}
<# .DESCRIPTION 
Shows changelog information #>
function changelog {
    Get-Content .\changelog.md
}
