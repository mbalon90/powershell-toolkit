<# .SYNOPSIS
    Invokes the health check functionality.
#>
<# .DESCRIPTION
    This script invokes the health check functionality, displaying the health check banner and checking disk health.
#>

#Prepare the environment
Clear-Host

# Load required modules & test scripts
. "$PSScriptRoot\src\functions.ps1"
. "$PSScriptRoot\src\hc_functions.ps1"

#Define the health check functions
$diskResults = Get-DiskHealth
$ramResults = Get-RAMHealth
$pagingResults = Get-PagingHealth
$cpuResults = Get-CPUHealth

$diskResults | Add-Member -NotePropertyName Category -NotePropertyValue "Disk"
$ramResults | Add-Member -NotePropertyName Category -NotePropertyValue "RAM"
$pagingResults | Add-Member -NotePropertyName Category -NotePropertyValue "Paging"
$cpuResults | Add-Member -NotePropertyName Category -NotePropertyValue "CPU"

$allResults = $diskResults + $ramResults + $pagingResults + $cpuResults
$allReport = $allResults | Select-Object Category, Name, Status 

do {
    Set-Banner -title "System Health Check"
    Write-Output "Please provide which health check you would like to perform:"
    $menuOptions = @(
        "1. Simple CLI Check"
        "2. Full CLI Report"
        "3. Export to CSV"
        "4. Exit"
    )
    $menuOptions
    $choice = Read-Host "Enter your choice (1, 2, or 3)"

    switch ($choice) {
        1 { 
    
            $allReport | Format-Table -AutoSize
        }
        2 { 
            Set-Banner -title "Disks"
            $diskResults | Format-Table -AutoSize
            Set-Banner -title "RAM"
            $ramResults | Format-Table -AutoSize
            Set-Banner -title "Paging"
            $pagingResults | Format-Table -AutoSize
            Set-Banner -title "CPU"
            $cpuResults | Format-Table -AutoSize
        
        }
        3 { 
            Write-Host "Please provide the path where you would like to export the CSV file (e.g., C:\Reports\HealthCheckReport.csv):"
            $csvPath = Read-Host "Enter the CSV file path"
            $allReport | Export-Csv -Path $csvPath -NoTypeInformation
            Write-Output "Health check results exported to $csvPath"
        }
        4 { 
            Write-Output "Exiting the health check."
            return
        }
        default {
            Write-Output "Invalid choice. Please enter 1, 2, or 3."
        }
    }
} while ($true) 
