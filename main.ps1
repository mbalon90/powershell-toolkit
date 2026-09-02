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
. "$PSScriptRoot\src\hc_functions.ps1"

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
            . "$PSScriptRoot\HealthCheck.ps1"
            Read-Host "Press Enter to return to the menu"
        }
        2 { 
            Get-Functions | Format-Table -AutoSize | Out-Host
            Read-Host "Press Enter to return to the menu"
            
        }
        3 { 
            Write-Output "Entering CLI mode..."
            Read-Host "Press Enter to return to the menu"
            # Add CLI mode logic here

        }
        4 { 
            Write-Output "Exiting the application. Goodbye!"
            Read-Host "Press Enter to return to the menu"
            return
        }
        default {
            Write-Output "Invalid choice. Please try again."
            Read-Host "Press Enter to return to the menu"
        }
    }
} while ($true)
#Show-Logo -Version $Version
