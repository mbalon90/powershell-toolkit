<# .SYNOPSIS
    This script is the main entry point for the PowerShell application. It initializes the environment, loads necessary modules, and starts the application. 
#>
<# .DESCRIPTION
    This script initializes the environment, loads necessary modules, and starts the PowerShell application.
#>

# Define the version of the application
$Version = "0.4"

# Load required modules & test scripts
. "$PSScriptRoot\src\api.ps1"
. "$PSScriptRoot\src\functions.ps1"
. "$PSScriptRoot\scripts\hc_functions.ps1"

# Initialize the application
Show-Logo -Version $Version
