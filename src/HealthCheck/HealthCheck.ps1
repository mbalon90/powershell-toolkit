<# .SYNOPSIS
    Invokes the health check functionality.
#>
<# .DESCRIPTION
    This script invokes the health check functionality, displaying the health check banner and checking disk health.
#>

# Load required modules & test scripts
. "$PSScriptRoot\hc_functions.ps1"

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
$simpleReport = $allResults | Select-Object Category, Name, Status 

do {
    Clear-Host
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
            Clear-Host
            Set-Banner -title "Health Check Simple Report"
            $simpleReport | Format-Table -AutoSize
            Read-Host "Press Enter to return to the menu"
        }
        2 { 
            Clear-Host
            Set-Banner -title "Health Check Full Report"
            $diskResults | Format-Table -AutoSize
            $ramResults | Format-Table -AutoSize
            $pagingResults | Format-Table -AutoSize
            $cpuResults | Format-Table -AutoSize
            Read-Host "Press Enter to return to the menu"
        
        }
        3 { 
            Clear-Host
            Set-Banner -title "Export Results to CSV"
            Write-Host "Please provide the path where you would like to export the CSV file (e.g., C:\Reports\HealthCheckReport.csv):"
            $csvPath = Read-Host "Enter the CSV file path"
            $simpleReport | Export-Csv -Path $csvPath -NoTypeInformation
            Write-Host "Health check results exported to $csvPath" -ForegroundColor Green
            Read-Host "Press Enter to return to the menu"
        }
        4 { 
            Write-Host "Exiting the health check..." -ForegroundColor Green
            return
        }
        default {
            Write-Host "Invalid choice. Please enter 1, 2, or 3." -ForegroundColor Red
        }
    }
} while ($true) 
Clear-Host
