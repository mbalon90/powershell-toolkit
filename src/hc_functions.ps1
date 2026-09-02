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
            TotalFreeSpaceGB = [math]::Round($drive.TotalFreeSpace / 1GB, 2) 
            TotalSizeGB      = [math]::Round($drive.TotalSize / 1GB, 2) 
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
function Get-CPUHealth {    
    <# .SYNOPSIS
    This function checks the health of the system's CPU.
#>
    <# .DESCRIPTION
    This function checks the health of the system's CPU by evaluating the percentage of CPU usage.  
#>
    $fixedCpu = Get-CimInstance -ClassName Win32_Processor | Select-Object Name, LoadPercentage, Status
    $cpuHealth = foreach ($cpu in $fixedCpu) {  
        $percentUsed = $cpu.LoadPercentage
  
        if ($null -eq $percentUsed) {
            $status = "Unknown"
        }
        elseif ($percentUsed -gt 90) {
            $status = "Critical"
        }
        elseif ($percentUsed -gt 80) {
            $status = "Warning"
        }
        else {
            $status = "OK"
        }

        [PSCustomObject]@{
            Name           = $cpu.Name
            LoadPercentage = $percentUsed
            Status         = $status
        } 
    }
    $cpuHealth
}
