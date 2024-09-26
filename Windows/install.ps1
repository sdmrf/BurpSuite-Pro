# Author: Sdmrf

# Variables
$repoUrl = "https://github.com/sdmrf/BurpSuite-Pro.git"
$burpDir = "C:\sdmrf\BurpSuitePro"
$burpCloneDir = "C:\sdmrf\BurpSuite-Pro"
$burpScript = "$burpDir\burpsuitepro.bat"
$burpVbsScript = "$burpDir\burpsuite_launcher.vbs"
$burpIconPath = "$burpCloneDir\BurpSuitePro.ico"
$desktopPath = [System.IO.Path]::Combine([System.Environment]::GetFolderPath('Desktop'), 'BurpSuitePro.lnk')
$burpReleasesUrl = "https://portswigger.net/burp/releases"
$loaderJarUrl = "https://raw.githubusercontent.com/sdmrf/BurpSuiteLoaderGen/main/BurpLoaderKeyGen.jar"
$jdkUrl = "https://download.oracle.com/java/21/latest/jdk-21_windows-x64_bin.exe"

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

# Function to check if Java is installed
function Check-Java {
    $javaPath = Get-Command java -ErrorAction SilentlyContinue
    if (-not $javaPath) {
        return $false
    }

    $javaVersion = & java -version 2>&1 | Select-String -Pattern 'version'
    if ($javaVersion -match '(\d+\.\d+\.\d+)') {
        $version = $matches[1]
        Print-Status "Java version $version is installed."
        return $version
    }
    
    return $false
}

# Function to install Java JDK and JRE
function Install-Java {
    if (-not (Check-Java)) {
        Print-Status "Installing the latest Java JDK (21) and JRE..."
        
        # Download JDK 21
        $jdkInstallerPath = "$env:TEMP\jdk-21-windows-x64-installer.exe"
        Start-BitsTransfer -Source $jdkUrl -Destination $jdkInstallerPath
        Start-Process -FilePath $jdkInstallerPath -ArgumentList "/s" -Wait
        Remove-Item -Path $jdkInstallerPath -Force

        Print-Status "Java JDK and JRE installed successfully."
    } else {
        Print-Status "Java is already installed."
    }
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
    Print-Status "This may take a while depending on your internet speed..."

    $html = Invoke-WebRequest -Uri $burpReleasesUrl -UseBasicParsing 
    $version = $html.Links | Select-String -Pattern 'professional-community-\d+\.\d+\.\d+' | Select-Object -First 1 | ForEach-Object { [regex]::Match($_.ToString(), '\d+\.\d+\.\d+').Value }
    
    $downloadLink = "https://portswigger-cdn.net/burp/releases/download?product=pro&type=Jar&version="
    New-Item -Path $burpDir -ItemType Directory -Force | Out-Null
    
    # Optimized download using Start-BitsTransfer
    Start-BitsTransfer -Source $downloadLink -Destination "$burpDir\burpsuite_pro.jar"
    Print-Status "Downloaded Burp Suite Version: $version"
}

# Function to download the Burp Loader Key Generator
function Download-LoaderJar {
    Print-Status "Downloading the latest Burp Loader Key Generator..."
    
    # Optimized download using Start-BitsTransfer
    Start-BitsTransfer -Source $loaderJarUrl -Destination "$burpDir\BurpLoaderKeyGen.jar"
    Print-Status "Burp Loader Key Generator downloaded successfully."
}

# Function to generate the executable script for Burp Suite Professional
function Generate-Script {
    Print-Status "Generating executable script for Burp Suite Professional..."
    
    $batContent = @"
@echo off
java --add-opens=java.desktop/javax.swing=ALL-UNNAMED --add-opens=java.base/java.lang=ALL-UNNAMED --add-opens=java.base/jdk.internal.org.objectweb.asm=ALL-UNNAMED --add-opens=java.base/jdk.internal.org.objectweb.asm.tree=ALL-UNNAMED --add-opens=java.base/jdk.internal.org.objectweb.asm.Opcodes=ALL-UNNAMED -javaagent:""$burpDir\BurpLoaderKeyGen.jar"" -noverify -jar "$burpDir\burpsuite_pro.jar"
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

# Function to reload environment variables
function Reload-EnvVariables {
    Print-Status "Reloading environment variables..."
    $currentPath = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
    $env:Path = $currentPath
    Print-Status "Environment variables reloaded successfully."
}

# Function to create a VBS file to launch Burp Suite
function Create-VbsLauncher {
    Print-Status "Creating VBS launcher for Burp Suite..."
    
    $vbsContent = @"
Set WshShell = CreateObject("WScript.Shell")
WshShell.Run chr(34) & "$burpScript" & Chr(34), 0
Set WshShell = Nothing
"@

    Set-Content -Path $burpVbsScript -Value $vbsContent -ErrorAction Stop
    Print-Status "VBS Launcher created at $burpVbsScript"
}

# Function to create a shortcut with an icon on the desktop
function Create-Shortcut {
    Print-Status "Creating shortcut on the desktop..."
    
    $WScriptShell = New-Object -ComObject WScript.Shell
    $shortcut = $WScriptShell.CreateShortcut($desktopPath)
    $shortcut.TargetPath = $burpVbsScript
    $shortcut.IconLocation = $burpIconPath
    $shortcut.Save()

    Print-Status "Shortcut created on the desktop with icon."
}

# Main execution
function Main {
    Cleanup-ExistingDir
    Clone-Repo
    Install-Java
    Download-BurpSuite
    Download-LoaderJar
    Generate-Script
    Create-VbsLauncher
    Reload-EnvVariables
    Create-Shortcut
    Launch-BurpSuite
    Start-KeyGenerator
}

# Run the main function
Main
