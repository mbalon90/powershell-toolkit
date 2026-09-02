# HealthCheck.ps1

Performs a system health check across disk space, physical RAM, page file usage, and CPU load, returning structured results and/or an interactive report.

## Usage

Run directly:
```powershell
.\HealthCheck.ps1
```

Or invoke from the main menu (`main.ps1` → Health Check), or call `Invoke-HealthCheck` directly if `src/functions.ps1` is dot-sourced.

On running, you'll be prompted to choose:
1. **Simple Check** — lists only items with a non-OK status (Warning/Critical).
2. **Full CLI Report** — displays a detailed table for each check (disk, RAM, paging, CPU).
3. **Export to CSV** — exports the combined report to a CSV file at a path you specify.
4. **Exit**

## Checks performed

| Check | Source | Status thresholds |
|---|---|---|
| Disk | `[System.IO.DriveInfo]` — fixed drives only | <10% free = Critical, <20% free = Warning |
| RAM | `Win32_OperatingSystem` | >90% used = Critical, >80% used = Warning |
| Paging | `Win32_PageFileUsage` | >90% used = Critical, >80% used = Warning |
| CPU | `Win32_Processor` | >90% load = Critical, >80% load = Warning |

*(Fill in your actual thresholds — I'm going from what we worked through in this session; double check the CPU/disk numbers you landed on, since a couple got adjusted along the way.)*

## Output shape

Each result is a `[PSCustomObject]` tagged with a `Category` (Disk/RAM/Paging/CPU), a `Status` (OK/Warning/Critical), and check-specific detail fields (e.g. `TotalFreeSpaceGB`, `PercentFreeSpace` for Disk).

## Notes

- Only fixed, ready drives are checked (removable/network/optical drives are excluded).
- CPU load can occasionally report as `$null` on some systems due to a known WMI limitation — [note however you decided to handle this, if you added the null guard].