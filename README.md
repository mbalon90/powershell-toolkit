# PowerShell Scripts and Functions

A small PowerShell sandbox repository for reusable scripts, helper functions, and experiments.
It helps keep PowerShell code organized, testable, and easy to reuse across projects.

## Overview

This repository contains a menu-driven PowerShell toolkit, along with reusable functions and helper utilities.

Running `main.ps1` launches an interactive menu with:
- **Health Check** — runs disk, RAM, paging, and CPU health checks, with options for a quick summary, a full detailed report, or exporting results to CSV.
- **Get Functions** — lists all available functions in the toolkit, along with their synopsis and description, parsed directly from source using the PowerShell AST parser.
- **CLI Mode** — drops into a nested PowerShell prompt for running ad-hoc commands without leaving the toolkit.

The main goal is to:
- Keep shared logic in one place.
- Make scripts easier to read and maintain.
- Provide a simple place for testing and demonstrating PowerShell scripting concepts.

## Repository structure

- `main.ps1` — entry point script; launches the interactive menu.
- `src/functions.ps1` — general helper functions and supporting logic.
- `src/api.ps1` — functions for API-related testing/utilities.
- `src/HealthCheck/HealthCheck.ps1` — script for performing system health checks (disk, RAM, paging, CPU), with menu options for summary view, full report, and CSV export.
- `src/HealthCheck/hc_functions.ps1` — health check functions (`Get-DiskHealth`, `Get-RAMHealth`, `Get-PagingHealth`, `Get-CPUHealth`, `Get-HealthCheckBanner`, `Invoke-HealthCheck`).
- `src/HealthCheck/HealthCheck.md` — detailed documentation for the health check module.
- `CHANGELOG.md` — version history and changes.
- `README.md` — repository overview and usage notes.

## Requirements

- PowerShell 5.1 or PowerShell 7+.
- Windows or another supported PowerShell environment.
- Visual Studio Code recommended for editing.

## Getting started

1. Clone the repository.
2. Open the folder in Visual Studio Code.
3. Open a PowerShell terminal in the repository root.
4. Run the main script:

```powershell
.\main.ps1
```

## Versioning

The current version is stored in `main.ps1`.

Example:

```powershell
$Version = "0.5"
```