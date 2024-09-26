# Author: Sdmrf

# Variables
$burpDir = "C:\sdmrf\BurpSuitePro"
$burpCloneDir = "$env:USERPROFILE\BurpSuite-Pro"
$burpScript = "C:\Program Files\burpsuitepro.bat"

# Function to print status messages
function Print-Status {
    param (
        [string]$message
    )
    Write-Host "$message" -ForegroundColor Cyan
}

# Function to print error messages
function Error-Status {
    param (
        [string]$message
    )
    Write-Host "$message" -ForegroundColor Red
}

# Function to clean up existing directory
function Cleanup-ExistingDir {
    if (Test-Path $burpCloneDir) {
        Print-Status "Cleaning up existing directory $burpCloneDir..."
        Remove-Item -Path $burpCloneDir -Recurse -Force -ErrorAction SilentlyContinue
    } else {
        Print-Status "Directory $burpCloneDir is already not there."
    }
}

# Function to remove Burp Suite Professional directory
function Remove-BurpSuite {
    if (Test-Path $burpDir) {
        Print-Status "Removing Burp Suite Professional..."
        Remove-Item -Path $burpDir -Recurse -Force -ErrorAction Stop
    } else {
        Print-Status "Directory $burpDir is already not there."
    }
}

# Function to remove the executable script for Burp Suite Professional
function Remove-Script {
    if (Test-Path $burpScript) {
        Print-Status "Removing executable script for Burp Suite Professional..."
        Remove-Item -Path $burpScript -Force -ErrorAction Stop
    } else {
        Print-Status "Script $burpScript is already not there."
    }
}

# Main execution
function Main {
    Cleanup-ExistingDir
    Remove-BurpSuite
    Remove-Script
    Print-Status "Uninstallation complete!"
}

# Run the main function
Main
