# Burp Suite Professional

**Enhance Your Testing Skills with Burp Suite Professional**
_~Test like a Pro, with Ignorance is a Bliss as a Motto_

![BurpSuite-Banner](https://raw.githubusercontent.com/sdmrf/BurpSuiteLoaderGen/main/Media/BurpSuitePro_2.png)

## Disclaimer

This repository is intended solely for educational purposes, or maybe not who knows?

## Overview

This repository provides a streamlined method for installing Burp Suite Professional with a single command. While a manual installation guide is also available, we recommend the automated process for convenience.

![BurpSuite-Professional](https://raw.githubusercontent.com/sdmrf/BurpSuiteLoaderGen/main/Media/BurpSuitePro_3.png)

# Linux Installation

## Prerequisites

Before proceeding with the installation, ensure that the following dependencies are installed on your system:

### General Dependencies

- `git` - for version control
- `curl` or `wget` - for downloading files

### Ubuntu/Debian-based Systems

```bash
sudo apt-get install -y openjdk-22-jre openjdk-22-jdk git curl wget
```

### Fedora-based Systems

```bash
sudo dnf install -y java-22-openjdk java-22-openjdk-devel git curl wget
```

### CentOS/RHEL-based Systems

```bash
sudo yum install -y java-22-openjdk java-22-openjdk-devel git curl wget
```

### Arch-based Systems

```bash
sudo pacman -S jdk-openjdk git curl wget
```

<img alt="prerequisites" src="https://raw.githubusercontent.com/sdmrf/BurpSuiteLoaderGen/main/Media/prerequisites_linux.gif" width="500">

## Installation

### Automated Installation

To install Burp Suite Professional, run the following command (root user):

```bash
curl https://raw.githubusercontent.com/sdmrf/BurpSuite-Pro/main/Linux/install.sh | sudo bash
```

Note: Make sure to enter your password after running this command as it is executed with root privileges.

<img alt="installation" src="https://raw.githubusercontent.com/sdmrf/BurpSuiteLoaderGen/main/Media/installation_linux.gif" width="500">

### Manual Installation

If you prefer a manual installation, follow the steps below:

1. Clone the repository:

```bash
git clone https://github.com/sdmrf/BurpSuite-Pro.git
```

2. Change the directory:

```bash
cd BurpSuite-Pro/Linux
```

3. Run the installation script:

```bash
sudo bash install.sh
```

## Usage

To run Burp Suite Professional, execute the following command:

```bash
burpsuitepro
```

<img alt="usage" src="https://raw.githubusercontent.com/sdmrf/BurpSuiteLoaderGen/main/Media/usage_linux.gif" width="500">

## Uninstallation

### Automated Uninstallation

To uninstall Burp Suite Professional, run the following command (root user):

```bash
curl https://raw.githubusercontent.com/sdmrf/BurpSuite-Pro/main/Linux/uninstall.sh | sudo bash
```

<img alt="uninstallation" src="https://raw.githubusercontent.com/sdmrf/BurpSuiteLoaderGen/main/Media/uninstallation_linux.gif" width="500">

### Manual Uninstallation

1. Change the directory:

```bash
cd BurpSuite-Pro/Linux
```

2. Run the uninstallation script:

```bash
sudo bash uninstall.sh
```

## Update (Optional)

### Automated Update

To update Burp Suite Professional, run the following command (root user):

```bash
curl https://raw.githubusercontent.com/sdmrf/BurpSuite-Pro/main/Linux/update.sh | sudo bash
```

### Manual Update

1. Change the directory:

```bash
cd BurpSuite-Pro/Linux
```

2. Run the update script:

```bash
sudo bash update.sh
```

![BurpSuite-Professional](https://raw.githubusercontent.com/sdmrf/BurpSuiteLoaderGen/main/Media/BurpSuitePro_1.png)

# Windows Installation

## Prerequisites

Before proceeding with the installation, ensure that the following dependencies are installed on your system:

- `git` - for cloning this repository || [Download Git](https://git-scm.com/downloads)

- `Java` - for running Burp Suite Professional || [Download Java](https://www.java.com/en/download/)

- `PowerShell` - for executing scripts 

<img alt="usage" src="https://raw.githubusercontent.com/sdmrf/BurpSuiteLoaderGen/main/Media/prerequisites_windows.gif" width="500">

## Installation

### Automated Installation

To install Burp Suite Professional, run the following command:

```powershell
iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/sdmrf/BurpSuite-Pro/main/Windows/install.ps1'))
```

<img alt="usage" src="https://raw.githubusercontent.com/sdmrf/BurpSuiteLoaderGen/main/Media/installation_windows.gif" width="500">

### Manual Installation

1. Download the repository:

```powershell
git clone https://github.com/sdmrf/BurpSuite-Pro.git
```

2. Change the directory:

```powershell
cd BurpSuite-Pro/Windows
```

3. Open PowerShell as an administrator and run the following commands:

```powershell
Set-ExecutionPolicy Unrestricted -Scope Process
```

4. Run the installation script:

```powershell
.\install.ps1
```

## Usage

<img alt="usage" src="https://raw.githubusercontent.com/sdmrf/BurpSuiteLoaderGen/main/Media/usage_windows.gif" width="500">

To run Burp Suite Professional, click on the `Burp-Suite-Pro.vbs` file.

You can also create a shortcut for the `Burp-Suite-Pro.vbs` file on your desktop for easy access.

### Steps to create a shortcut:

1. Right-click on the `Burp-Suite-Pro.vbs` file.
2. Click on `Send to`.
3. Click on `Desktop (create shortcut)`.
4. Change the icon of the shortcut by following these steps:
   - Right-click on the shortcut.
   - Click on `Properties`.
   - Click on `Change Icon`.
   - Click on `Browse`.
   - Select the `BurpSuitePro.ico` file from this repository.
   - Click on `Open`.
   - Click on `OK`.
   - Click on `Apply`.
   - Click on `OK`.
5. Now, you can access Burp Suite Professional by double-clicking on the shortcut.

## Uninstallation

### Automated Uninstallation

To uninstall Burp Suite Professional, run the following command:

```powershell
iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/sdmrf/BurpSuite-Pro/main/Windows/uninstall.ps1'))
```

### Manual Uninstallation

1. Change the directory:

```powershell
cd BurpSuite-Pro/Windows
```

2. Open PowerShell as an administrator and run the following commands:

```powershell
Set-ExecutionPolicy Unrestricted -Scope Process
```

3. Run the uninstallation script:

```powershell
.\uninstall.ps1
```

## Update (Optional)

### Automated Update

To update Burp Suite Professional, run the following command:

```powershell
iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/sdmrf/BurpSuite-Pro/main/Windows/update.ps1'))
```

### Manual Update

1. Change the directory:

```powershell
cd BurpSuite-Pro/Windows
```

2. Open PowerShell as an administrator and run the following commands:

```powershell
Set-ExecutionPolicy Unrestricted -Scope Process
```

3. Run the update script:

```powershell
.\update.ps1
```

## Credits

A special thanks to [sdmrf](https://github.com/sdmrf) for developing this script and to [h3110w0r1d-y](https://github.com/h3110w0r1d-y) for providing the Burp Suite key generation loader.
