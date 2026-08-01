# This file contains helper functions for the PowerShell application. It includes functions for listing all main and helper functions along with their descriptions.

<# .DESCRIPTION 
Listing All Main Functions #>
function Get-Functions {
    $tokens = $null
    $errors = $null
    $ast = [System.Management.Automation.Language.Parser]::ParseFile("$PSScriptRoot\Scripts\functions.ps1", [ref]$tokens, [ref]$errors)

    $functions = $ast.FindAll({
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
}
