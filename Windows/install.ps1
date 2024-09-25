# Author: Sdmrf

# Variables
$repoUrl = "https://github.com/sdmrf/BurpSuite-Pro.git"
$burpDir = "C:\sdmrf\BurpSuitePro"
$burpCloneDir = "$env:USERPROFILE\BurpSuite-Pro"
$burpScript = "C:\Program Files\burpsuitepro.bat"
$burpReleasesUrl = "https://portswigger.net/burp/releases"
$loaderJarUrl = "https://raw.githubusercontent.com/sdmrf/BurpSuiteLoaderGen/main/BurpLoaderKeyGen.jar"

# Function to print status messages
function Print-Status {
    param (
        [string]$message
    )
    Write-Host "$message" -ForegroundColor Cyan
}

# Function to print error messages and exit
function Error-Status {
    param (
        [string]$message
    )
    Write-Host "$message" -ForegroundColor Red
    exit 1
}

# Function to clean up existing directory
function Cleanup-ExistingDir {
    if (Test-Path $burpCloneDir) {
        Print-Status "Cleaning up existing directory $burpCloneDir..."
        Remove-Item -Path $burpCloneDir -Recurse -Force -ErrorAction SilentlyContinue
    }
}

# Function to clone the Burp Suite Professional repository
function Clone-Repo {
    Print-Status "Cloning the Burp Suite Professional repository..."
    git clone $repoUrl $burpCloneDir -q
}

# Function to download the latest Burp Suite Professional
function Download-BurpSuite {
    Print-Status "Downloading the latest Burp Suite Professional..."
    Print-Status "Please wait while we complete the process :)"
    Print-Status "This may take a while depending on your internet speed..."
    
    $html = Invoke-WebRequest -Uri $burpReleasesUrl -UseBasicParsing 
    $version = $html.Links | Select-String -Pattern 'professional-community-\d+\.\d+\.\d+' | Select-Object -First 1 | ForEach-Object { [regex]::Match($_.ToString(), '\d+\.\d+\.\d+').Value }
    
    $downloadLink = "https://portswigger-cdn.net/burp/releases/download?product=pro&type=Jar&version=&"
    New-Item -Path $burpDir -ItemType Directory -Force | Out-Null 
    Invoke-WebRequest -Uri $downloadLink -OutFile "$burpDir\burpsuite_pro.jar" -ErrorAction Stop
    Print-Status "Downloaded Burp Suite Version: $version"
}

# Function to download the Burp Loader Key Generator
function Download-LoaderJar {
    Print-Status "Downloading the latest Burp Loader Key Generator..."
    Invoke-WebRequest -Uri $loaderJarUrl -OutFile "$burpDir\BurpLoaderKeyGen.jar" -ErrorAction Stop
}

# Function to generate the executable script for Burp Suite Professional
function Generate-Script {
    Print-Status "Generating executable script for Burp Suite Professional..."
    
    $batContent = @"
@echo off
java --add-opens=java.desktop/javax.swing=ALL-UNNAMED --add-opens=java.base/java.lang=ALL-UNNAMED --add-opens=java.base/jdk.internal.org.objectweb.asm=ALL-UNNAMED --add-opens=java.base/jdk.internal.org.objectweb.asm.tree=ALL-UNNAMED --add-opens=java.base/jdk.internal.org.objectweb.asm.Opcodes=ALL-UNNAMED -javaagent:""$burDir\BurpLoaderKeyGen.jar"" -noverify -jar "$burpDir\burpsuite_pro.jar"
"@
    
    Set-Content -Path $burpScript -Value $batContent -ErrorAction Stop
    Set-ItemProperty -Path $burpScript -Name IsReadOnly -Value $false
    Print-Status "Script generated at $burpScript"
}

# Function to launch Burp Suite Professional
function Launch-BurpSuite {
    Print-Status "Launching Burp Suite Professional..."
    Start-Process -FilePath $burpScript -NoNewWindow
}

# Function to start the key generator
function Start-KeyGenerator {
    Print-Status "Starting Key Generator..."
    Start-Process -FilePath "java.exe" -ArgumentList "-jar", "$burpDir\BurpLoaderKeyGen.jar" -NoNewWindow
    Print-Status "Key Generator process has started. Follow the instructions to generate the key."
}

# Main execution
function Main {
    Cleanup-ExistingDir
    Clone-Repo
    Download-BurpSuite
    Download-LoaderJar
    Generate-Script
    Launch-BurpSuite
    Start-KeyGenerator
}

# Run the main function
Main
