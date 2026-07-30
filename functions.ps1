<# .DESCRIPTION 
Shows a hello message #>
function Test-Hello {
    Write-Host "Hello"
}
<# .DESCRIPTION
Shows the current version information #>
function version {
    Write-Host "  Version 0.1" -ForegroundColor Green
}
<# .DESCRIPTION
Shows welcome logp #>
function welcome {
    clear-host
    $line = "=" * 21
    Write-Host $line -ForegroundColor Green
    Write-Host "  Scripting Toolkit" -ForegroundColor Green
    version
    Write-Host $line -ForegroundColor Green
}