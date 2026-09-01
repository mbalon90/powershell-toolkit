<# .SYNOPSIS
    Invokes the health check functionality.
#>
<# .DESCRIPTION
    This script invokes the health check functionality, displaying the health check banner and checking disk health.
#>

# Load required modules & test scripts
function Get-HealthCheckBanner { 
    <# .SYNOPSIS
    This function displays the health check banner.
#>
    <# .DESCRIPTION
    This function displays the health check banner.
#>
    Write-Host "======================" -ForegroundColor Green
    Write-Host "System Health Check" -ForegroundColor Green
    Write-Host "======================" -ForegroundColor Green
}
function Get-DiskHealth {
    <# .SYNOPSIS
    This script performs a health check on the system, including disk space, RAM usage, running services, Windows update status, and event log errors. 
    The results are exported to a CSV file.
#>
    <# .DESCRIPTION
    The script checks the health of the system by performing various checks and exporting the results to a CSV file. 
    It checks disk space, RAM usage, running services, Windows update status, and event log errors.
#>
    $fixedDrives = [System.IO.DriveInfo]::GetDrives() | Where-Object { $_.IsReady -eq $true -and $_.DriveType -eq "Fixed" } 
    $diskHealth = foreach ($drive in $fixedDrives) {    
        $percentFreeSpace = [math]::Round(($drive.TotalFreeSpace / $drive.TotalSize) * 100, 2)    
        if ($percentFreeSpace -lt 10) {
            $status = "Critical"
        }
        elseif ($percentFreeSpace -lt 20) {
            $status = "Warning"
        }
        else {
            $status = "OK"
        }
        [PSCustomObject]@{
            Name             = $drive.Name
            VolumeLabel      = $drive.VolumeLabel
            IsReady          = $drive.IsReady
            DriveType        = $drive.DriveType
            TotalFreeSpaceGB = [math]::Round($drive.TotalFreeSpace / 1MB, 2) 
            TotalSizeGB      = [math]::Round($drive.TotalSize / 1MB, 2) 
            PercentFreeSpace = $percentFreeSpace 
            Status           = $status
        } 
    }
    $diskHealth 
}
function Get-RAMHealth {
    <# .SYNOPSIS
    This function checks the health of the system's RAM.
#>
    <# .DESCRIPTION
    This function checks the health of the system's RAM by evaluating the percentage of memory used.
#>
    $memory = Get-CimInstance -ClassName Win32_OperatingSystem | Select-Object TotalVisibleMemorySize, FreePhysicalMemory
    $percentUsed = [math]::Round((($memory.TotalVisibleMemorySize - $memory.FreePhysicalMemory) / $memory.TotalVisibleMemorySize) * 100, 2)
  
    if ($percentUsed -gt 90) {
        $status = "Critical"
    }
    elseif ($percentUsed -gt 80) {
        $status = "Warning"
    }
    else {
        $status = "OK"
    }

    [PSCustomObject]@{
        Name                     = $env:COMPUTERNAME
        FreePhysicalMemoryGB     = [math]::Round($memory.FreePhysicalMemory / 1MB, 2)
        TotalVisibleMemorySizeGB = [math]::Round($memory.TotalVisibleMemorySize / 1MB, 2) 
        PercentUsed              = $percentUsed
        Status                   = $status
    } 

}
function Get-PagingHealth {
    <# .SYNOPSIS
    This function checks the health of the system's paging file.
#>  
    <# .DESCRIPTION
    This function checks the health of the system's paging file by evaluating the percentage of paging file used.   
    #>
    $paging = Get-CimInstance -ClassName Win32_PageFileUsage | Select-Object Name, AllocatedBaseSize, CurrentUsage, PeakUsage
    $percentUsed = [math]::Round(($paging.CurrentUsage / $paging.AllocatedBaseSize) * 100, 2)
  
    if ($percentUsed -gt 90) {
        $status = "Critical"
    }
    elseif ($percentUsed -gt 80) {
        $status = "Warning"
    }
    else {
        $status = "OK"
    }

    [PSCustomObject]@{
        Name                = $paging.Name
        CurrentUsageGB      = [math]::Round($paging.CurrentUsage / 1024, 2)
        AllocatedBaseSizeGB = [math]::Round($paging.AllocatedBaseSize / 1024, 2)
        PeakUsageGB         = [math]::Round($paging.PeakUsage / 1024, 2)
        PercentUsed         = $percentUsed
        Status              = $status
    } 
}
function Invoke-HealthCheck {
    <# .SYNOPSIS
    Gathers the health check data for Health Check script.
#>
    <# .DESCRIPTION
    This function gathers the health check data.
#>
    $diskResults = Get-DiskHealth
    $ramResults = Get-RAMHealth
    $pagingResults = Get-PagingHealth

    $diskResults | Add-Member -NotePropertyName Category -NotePropertyValue "Disk"
    $ramResults | Add-Member -NotePropertyName Category -NotePropertyValue "RAM"
    $pagingResults | Add-Member -NotePropertyName Category -NotePropertyValue "Paging"
}

Clear-Host
Get-HealthCheckBanner
Invoke-HealthCheck

Write-Output "Please provide which health check you would like to perform:"
Write-Output "1. Simple Check"
Write-Output "2. Full CLI Report"        
Write-Output "3. Export to CSV"
Write-Output "4. Exit"
$choice = Read-Host "Enter your choice (1, 2, or 3)"

switch ($choice) {  
    1 { 
    
        $allResults = $diskResults + $ramResults + $pagingResults
        $allResults | Where-Object { $_.Status -ne "OK" } | Select-Object Category, Name, Status | Format-Table -AutoSize
    }
    2 { 

        $diskResults | Format-Table -AutoSize
        $ramResults | Format-Table -AutoSize
        $pagingResults | Format-Table -AutoSize
    }
    3 { 
        Write-Host "Please provide the path where you would like to export the CSV file (e.g., C:\Reports\HealthCheckReport.csv):"
        $csvPath = Read-Host "Enter the CSV file path"
        $allResults | Export-Csv -Path $csvPath -NoTypeInformation
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
