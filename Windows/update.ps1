# Author: Sdmrf

# Variables
$burpDir = "C:\sdmrf\BurpSuitePro"
$burpCloneDir = "$env:USERPROFILE\BurpSuite-Pro"
$burpScript = "C:\Program Files\burpsuitepro.bat"
$loaderJar = "$burpDir\loader.jar"
$burpReleasesUrl = "https://portswigger.net/burp/releases"

# Function to print status messages
function Print-Status {
    param (
        [string]$message
    )
    Write-Host "$message" -ForegroundColor Cyan
}

# Function to remove old files
function Remove-OldFiles {
    Print-Status "Removing Old Files..."
    Remove-Item -Path "$burpDir\*.jar" -Force -ErrorAction Stop
    Remove-Item -Path $burpScript -Force -ErrorAction Stop
}

# Function to copy loader.jar
function Copy-LoaderJar {
    Print-Status "Copying loader.jar..."
    $sourceLoaderJar = Join-Path $burpCloneDir "loader.jar"
    if (Test-Path $sourceLoaderJar) {
        Copy-Item -Path $sourceLoaderJar -Destination $loaderJar -Force -ErrorAction Stop
    } else {
        Write-Host "loader.jar not found in $burpCloneDir!" -ForegroundColor Red
        exit 1
    }
}

# Function to download Burp Suite Professional
function Download-BurpSuite {
    Print-Status "Downloading Burp Suite Professional..."
    
    $html = Invoke-WebRequest -Uri $burpReleasesUrl -UseBasicP | Select-Object -ExpandProperty Content
    $version = [regex]::Match($html, '(?<=/burp/releases/professional-community-)[0-9]+\-[0-9]+\-[0-9]+').Value
    $downloadLink = "https://portswigger-cdn.net/burp/releases/download?product=pro&type=Jar&version="

    Invoke-WebRequest -Uri $downloadLink -OutFile "$burpDir\burpsuite_pro.jar" -ErrorAction Stop
    Print-Status "Downloaded Burp Suite Version: $version"
}

# Function to generate executable script for Burp Suite Professional
function Generate-ExecutableScript {
    Print-Status "Generating executable script for Burp Suite Professional..."
    
    $scriptContent = @"
@echo off
java ^
  --add-opens=java.desktop/javax.swing=ALL-UNNAMED ^
  --add-opens=java.base/java.lang=ALL-UNNAMED ^
  --add-opens=java.base/jdk.internal.org.objectweb.asm=ALL-UNNAMED ^
  --add-opens=java.base/jdk.internal.org.objectweb.asm.tree=ALL-UNNAMED ^
  --add-opens=java.base/jdk.internal.org.objectweb.asm.Opcodes=ALL-UNNAMED ^
  -javaagent:$loaderJar ^
  -noverify ^
  -jar $burpDir\burpsuite_pro.jar
"@

    Set-Content -Path $burpScript -Value $scriptContent -Force
    # Make the script executable
    Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
}

# Function to execute Burp Suite Professional
function Execute-BurpSuite {
    Print-Status "Executing Burp Suite Professional..."
    & $burpScript -ErrorAction Stop
}

# Main execution
function Main {
    Remove-OldFiles
    Copy-LoaderJar
    Download-BurpSuite
    Generate-ExecutableScript
    Execute-BurpSuite
}

# Run the main function
Main
