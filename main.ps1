# This script is the main entry point for the PowerShell application. It initializes the environment, loads necessary modules, and starts the application.

# Define the version of the application
$Version = "0.3"

# Load helper functions and modules
. "$PSScriptRoot/helpers.ps1"
. "$PSScriptRoot/functions.ps1"

# Initialize the application
welcome -Version $Version
