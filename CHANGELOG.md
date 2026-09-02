
---

## v0.1

- Created functions.ps1, helpers.ps1, main.ps1 scripts

---

## v0.2

- Added descriptions for functions
- Created Changelog.md file

---

## v0.3

- Added README.md file
- Created api.ps1 file
- Updated scripts structure

---

## v0.4

- Cleaned up structure of changelog.md

---

## v0.5

- Added Synopsis to Help Documentation
- Added new HealthCheck.ps1 script 
- Added new HealthCheck function Get-HealthCheckBanner
- Added new HealthCheck function Get-DiskHealth
- Added new script HealthCheck.ps1
- Improved Help descriptions

---

## v0.6

- Added switch menu for both HealthCheck.ps1 and main.ps1 scripts
- Added Get-RAMHealth function to check physical memory usage
- Added Get-PagingHealth function to check page file usage
- Added Get-CPUHealth function to check CPU load
- Added Get-Functions to list available functions via AST parsing
- Added CLI Mode using $host.EnterNestedPrompt() with custom prompt and banner
- Built HealthCheck.ps1 menu script with Simple Check, Full Report, and CSV Export options
- Built main.ps1 as top-level application entry point with menu system
- Fixed Format-Table pipeline output leaking into function return values
- Fixed disk size unit conversion bug in Get-DiskHealth (was MB, corrected to GB)
- Integrated script HealthCheck.ps1 with main.ps1 logic
- Reworked Invoke-HealthCheck to combine and tag results by Category
- Reworked Invoke-HealthCheck to combine and tag results by Category
