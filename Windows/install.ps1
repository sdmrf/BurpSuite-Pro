# Set Wget Progress to Silent, because it slows down downloading by 50x
echo "Setting Wget Progress to Silent, because it slows down downloading by 50x`n"
$ProgressPreference = 'SilentlyContinue'

# Variables
$repoUrl = "https://github.com/sdmrf/BurpSuite-Pro.git"
$burpDir = "C:\sdmrf\burpsuitepro"
$burpCloneDir = "$HOME\BurpSuite-Pro"
$burpScript = "C:\sdmrf\burpsuitepro\burp.bat"
$burpReleasesUrl = "https://portswigger.net/burp/releases"
$loaderJarUrl = "https://raw.githubusercontent.com/sdmrf/BurpSuiteLoaderGen/main/BurpLoaderKeyGen.jar"

function Print-Status($message) {
    Write-Host "$message" -ForegroundColor Blue
}

function Error-Status($message) {
    Write-Host "$message" -ForegroundColor Red
    exit 1
}

# Cleanup existing directory
if (Test-Path $burpCloneDir) {
    Print-Status "Cleaning up existing directory $burpCloneDir..."
    Remove-Item -Recurse -Force $burpCloneDir || Error-Status "Cleanup failed!"
}

# Clone the repository
Print-Status "Cloning the Burp Suite Professional repository..."
git clone $repoUrl $burpCloneDir || Error-Status "Cloning failed!"

# Download Burp Suite Professional
Print-Status "Downloading the latest Burp Suite Professional..."
New-Item -Path $burpDir -ItemType Directory -Force
$html = Invoke-WebRequest -Uri $burpReleasesUrl -UseBasicParsing
$version = ($html.Links.href | Select-String -Pattern "professional-community-[0-9]{4}\.[0-9]+\.[0-9]+").Matches.Value.Split("-")[1]
$downloadLink = "https://portswigger-cdn.net/burp/releases/download?product=pro&type=Jar&version=$version"
Invoke-WebRequest -Uri $downloadLink -OutFile "$burpDir\burpsuite_pro.jar" || Error-Status "Download failed!"
Print-Status "Downloaded Burp Suite Version: $version"

# Download Burp Loader Key Generator
Print-Status "Downloading the latest Burp Loader Key Generator..."
Invoke-WebRequest -Uri $loaderJarUrl -OutFile "$burpDir\BurpLoaderKeyGen.jar" || Error-Status "Failed to download BurpLoaderKeyGen.jar!"

# Generate batch script for Burp Suite
Print-Status "Generating executable script for Burp Suite Professional..."
$burpScriptContent = @"
@echo off
java --add-opens=java.desktop/javax.swing=ALL-UNNAMED ^
     --add-opens=java.base/java.lang=ALL-UNNAMED ^
     --add-opens=java.base/jdk.internal.org.objectweb.asm=ALL-UNNAMED ^
     --add-opens=java.base/jdk.internal.org.objectweb.asm.tree=ALL-UNNAMED ^
     --add-opens=java.base/jdk.internal.org.objectweb.asm.Opcodes=ALL-UNNAMED ^
     -javaagent:$burpDir\BurpLoaderKeyGen.jar ^
     -noverify ^
     -jar $burpDir\burpsuite_pro.jar
"@
Set-Content -Path $burpScript -Value $burpScriptContent
Print-Status "Script generated at $burpScript"

# Make the script executable and run Burp Suite
Print-Status "Launching Burp Suite Professional..."
Start-Process "cmd.exe" -ArgumentList "/c $burpScript" || Error-Status "Failed to launch Burp Suite!"

# Start Key Generator
Print-Status "Starting Key Generator..."
Start-Process "java" -ArgumentList "-jar $burpDir\BurpLoaderKeyGen.jar" || Error-Status "Failed to start the Key Generator!"
Print-Status "Key Generator process has started. Follow the instructions to generate the key."
