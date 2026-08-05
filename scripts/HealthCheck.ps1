<# PC Health Check Script
Checks disk space, RAM usage, running services, Windows update status, and event log errors.
Exports results to CSV.#>

function Get-DiskHealth {

}

#Don't look yet, ready-to-use function to get disk health information
function Get-DiskHealth {
    # Get disk space information
    $disks = Get-WmiObject Win32_LogicalDisk -Filter "DriveType=3"
    $diskHealth = @()

    foreach ($disk in $disks) {
        $diskInfo = [PSCustomObject]@{
            DriveLetter = $disk.DeviceID
            FreeSpaceGB = [math]::Round($disk.FreeSpace / 1GB, 2)
            TotalSizeGB = [math]::Round($disk.Size / 1GB, 2)
            PercentFree = [math]::Round(($disk.FreeSpace / $disk.Size) * 100, 2)
        }
        $diskHealth += $diskInfo
    }

    return $diskHealth
}