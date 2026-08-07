# This script is the main entry point for the PowerShell application. It initializes the environment, loads necessary modules, and starts the application.

# Define the version of the application
$Version = "0.4"

# Load required modules
. "$PSScriptRoot\src\api.ps1"
. "$PSScriptRoot\src\functions.ps1"

#Load scripts
. "$PSScriptRoot\scripts\HealthCheck.ps1"

# Initialize the application
Show-Logo -Version $Version
