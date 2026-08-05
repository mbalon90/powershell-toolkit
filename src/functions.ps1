#This file contains the main functions used in the PowerShell application. It includes functions for displaying messages, version information, and welcome messages.

<# .DESCRIPTION
Shows welcome logo #>
function Show-Logo {
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
Shows changelog information #>
function Show-Changelog {
    Get-Content .\CHANGELOG.md
}

<# .DESCRIPTION 
Listing All Main Functions #>
function Get-Functions {
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
        $description = if ($help -and $help.Description) { $help.Description.Trim() } else { '' }
        [pscustomobject]@{
            Name        = $f.Name
            Description = if ($description.Length -gt 50) { $description.Substring(0, 47) + '...' } else { $description }
        }
    }

    $api_functions = $api.FindAll({
            param($node)
            $node -is [System.Management.Automation.Language.FunctionDefinitionAst]
        }, $true)
        
    foreach ($f in $api_functions) {
        $help = $f.GetHelpContent()
        $description = if ($help -and $help.Description) { $help.Description.Trim() } else { '' }
        [pscustomobject]@{
            Name        = $f.Name
            Description = if ($description.Length -gt 50) { $description.Substring(0, 47) + '...' } else { $description }
        }
    }
}