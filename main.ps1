<# .SYNOPSIS
    This script is the main entry point for the PowerShell application. It initializes the environment, loads necessary modules, and starts the application. 
#>
<# .DESCRIPTION
    This script initializes the environment, loads necessary modules, and starts the PowerShell application.
#>

# Define the version of the application
$Version = "0.6"

# Load required modules & test scripts
. "$PSScriptRoot\src\api.ps1"
. "$PSScriptRoot\src\functions.ps1"

# Clear the console
Clear-Host

# Initialize the application
do {
    Show-Logo -Version $Version
    Write-Output "Welcome to the PowerShell Toolkit!"
    Write-Output "Please select an option:"
    $menuOptions = @(
        "1. Health Check"
        "2. Get Functions"
        "3. Enter CLI Mode"
        "4. Exit"
    )
    $menuOptions
    $choice = Read-Host "Enter your choice (1, 2, 3, or 4)"

    switch ($choice) {
        1 { 
            # Invoke the health check functionality
            . "$PSScriptRoot\HealthCheck\HealthCheck.ps1"
            Read-Host "Press Enter to return to the menu"
        }
        2 { 
            Get-Functions | Format-Table -AutoSize | Out-Host
            Read-Host "Press Enter to return to the menu"
            
        }
        3 { 
            $originalPrompt = (Get-Item Function:prompt).ScriptBlock
            Clear-Host
            Set-Banner -title "Scripting Toolkit CLI mode `nGet-Functions"
            function prompt {
                "CLI Mode> "
            }
            $host.EnterNestedPrompt()
            Write-Host "Exiting CLI mode..." -foregroundcolor Green
            Set-Item Function:\prompt -Value $originalPrompt
            Read-Host "Press Enter to return to the menu"
            Clear-Host
        }
        4 { 
            Write-Host "Exiting the application. Goodbye!" -foregroundcolor Green
            Read-Host "Press Enter to return to the menu"
            Clear-Host
            return
        }
        default {
            Write-Host "Invalid choice. Please try again." -foregroundcolor Red
            Read-Host "Press Enter to return to the menu"
        }
    }
} while ($true)
#Show-Logo -Version $Version
