function Set-Banner { 
    <# .SYNOPSIS
    This function displays the defined banner.
#>
    <# .DESCRIPTION
    This function displays the defined banner.
#>
    param   (
        [string]$title
    )
    Write-Host ""
    Write-Host "===============================" -ForegroundColor Green
    Write-Host "$title" -ForegroundColor Green
    Write-Host "===============================" -ForegroundColor Green
}
function Show-Logo {
    <# .SYNOPSIS
    Shows welcome logo 
#>
    <# .DESCRIPTION
    This function displays a welcome logo with the application version. It clears the console and prints a formatted 
#>
    param(
        [string]$Version
    )
    Set-Banner -title "Scripting Toolkit v$Version"
}
function Get-Functions {
    <# .SYNOPSIS
    This function displays a welcome message to the user. 
#>
    <# .DESCRIPTION 
    Listing All Main Functions 
#>
    $tokens = $null
    $errors = $null
    $func = [System.Management.Automation.Language.Parser]::ParseFile("$PSScriptRoot\functions.ps1", [ref]$tokens, [ref]$errors)
    $api = [System.Management.Automation.Language.Parser]::ParseFile("$PSScriptRoot\api.ps1", [ref]$tokens, [ref]$errors)

    $functions = $func.FindAll({
            param($node)
            $node -is [System.Management.Automation.Language.FunctionDefinitionAst]
        }, $true)


    foreach ($f in $functions) {
        $help = $f.GetHelpContent()
        $synopsis = if ($help -and $help.Synopsis) { $help.Synopsis.Trim() } else { '' }
        $description = if ($help -and $help.Description) { $help.Description.Trim() } else { '' }
        [pscustomobject]@{
            Name        = $f.Name
            Synopsis    = if ($synopsis.Length -gt 50) { $synopsis.Substring(0, 47) + '...' } else { $synopsis }
            Description = if ($description.Length -gt 50) { $description.Substring(0, 47) + '...' } else { $description }
        }
    }
    $api_functions = $api.FindAll({
            param($node)
            $node -is [System.Management.Automation.Language.FunctionDefinitionAst]
        }, $true)
        
    foreach ($f in $api_functions) {
        $help = $f.GetHelpContent()
        $synopsis = if ($help -and $help.Synopsis) { $help.Synopsis.Trim() } else { '' }
        $description = if ($help -and $help.Description) { $help.Description.Trim() } else { '' }
        [pscustomobject]@{
            Name        = $f.Name
            Synopsis    = if ($synopsis.Length -gt 50) { $synopsis.Substring(0, 47) + '...' } else { $synopsis }
            Description = if ($description.Length -gt 50) { $description.Substring(0, 47) + '...' } else { $description }
        }
    }
}
function Show-Changelog {
    <# .SYNOPSIS
    This function displays the changelog information for the application. 
#>
    <# .DESCRIPTION 
    Shows changelog information
#>
    Get-Content .\CHANGELOG.md
}
function Get-IPAddresses {
    <#
    .SYNOPSIS
        Retrieves the local and public IP addresses of the system.
    .DESCRIPTION
        This function retrieves the local IPv4 address of the system (excluding loopback addresses) and the public IP address using an external service.
    .OUTPUTS
        A custom object containing LocalIP and PublicIP properties.
    #>
    $local = (Get-NetIPAddress -AddressFamily IPv4 |
        Where-Object InterfaceAlias -NotLike '*Loopback*' |
        Select-Object -First 1).IPAddress

    $public = (Invoke-RestMethod -Uri "https://api.ipify.org").Trim()

    [pscustomobject]@{
        LocalIP  = $local
        PublicIP = $public
    }
}
