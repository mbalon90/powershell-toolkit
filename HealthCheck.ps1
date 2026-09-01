<# .SYNOPSIS
    Invokes the health check functionality.
#>
<# .DESCRIPTION
    This script invokes the health check functionality, displaying the health check banner and checking disk health.
#>

#Prepare the environment
Clear-Host

# Load required modules & test scripts
. "$PSScriptRoot\scripts\hc_functions.ps1"

$diskResults = Get-DiskHealth
$ramResults = Get-RAMHealth
$pagingResults = Get-PagingHealth

$diskResults | Add-Member -NotePropertyName Category -NotePropertyValue "Disk"
$ramResults | Add-Member -NotePropertyName Category -NotePropertyValue "RAM"
$pagingResults | Add-Member -NotePropertyName Category -NotePropertyValue "Paging"

do {
    Get-HealthCheckBanner
    Write-Output "Please provide which health check you would like to perform:"
    $menuOptions = @(
        "1. Simple Check"
        "2. Full CLI Report"
        "3. Export to CSV"
        "4. Exit"
    )
    $menuOptions
    $choice = Read-Host "Enter your choice (1, 2, or 3)"

    switch ($choice) {  
        1 { 
    
            $allResults = $diskResults + $ramResults + $pagingResults
            $allResults | Select-Object Category, Name, Status | Format-Table -AutoSize
        }
        2 { 
            $diskResults | Format-Table -AutoSize
            $ramResults | Format-Table -AutoSize
            $pagingResults | Format-Table -AutoSize
        
        }
        3 { 
            Write-Host "Please provide the path where you would like to export the CSV file (e.g., C:\Reports\HealthCheckReport.csv):"
            $csvPath = Read-Host "Enter the CSV file path"
            $allResults = $diskResults + $ramResults + $pagingResults
            $allResults | Select-Object Category, Name, Status | Export-Csv -Path $csvPath -NoTypeInformation
            Write-Output "Health check results exported to $csvPath"
        }
        4 { 
            Write-Output "Exiting the health check."
            exit
        }
        default {
            Write-Output "Invalid choice. Please enter 1, 2, or 3."
        }
    }
} while ($true) 
