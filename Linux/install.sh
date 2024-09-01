#!/bin/bash

# Author: Sdmrf

# Variables
REPO_URL="https://github.com/sdmrf/BurpSuite-Pro.git"
BURP_DIR="/usr/share/burpsuitepro"
BURP_CLONE_DIR="/home/*/BurpSuite-Pro"
BURP_SCRIPT="/usr/local/bin/burpsuitepro"
BURP_RELEASES_URL="https://portswigger.net/burp/releases"
LOADER_JAR_URL="https://raw.githubusercontent.com/sdmrf/BurpSuiteLoaderGen/main/BurpLoaderKeyGen.jar"
USERNAME_FILE="/usr/share/burpsuitepro/username.txt"

print_status() {
    echo -e "\e[1;34m$1\e[0m"
}

handle_error() {
    echo -e "\e[1;31m$1\e[0m"
    exit 1
}

get_username() {
    if [ ! -f "$USERNAME_FILE" ]; then
        read -p "Enter your username for the Burp Suite key loader: " username
        echo "$username" > "$USERNAME_FILE" || handle_error "Failed to save username!"
    else
        username=$(cat "$USERNAME_FILE")
    fi
    echo "$username"
}

download_burpsuite() {
    print_status "Downloading the latest Burp Suite Professional..."
    local html version download_link
    html=$(curl -s "$BURP_RELEASES_URL") || handle_error "Failed to fetch release page."

    version=$(echo "$html" | grep -Po '(?<=/burp/releases/professional-community-)[0-9]+\-[0-9]+\-[0-9]+' | head -n 1)
    download_link="https://portswigger-cdn.net/burp/releases/download?product=pro&type=Jar&version=&"

    wget "$download_link" -O "$BURP_DIR/burpsuite_pro.jar" -q --progress=bar:force || handle_error "Download failed!"
    print_status "Downloaded Burp Suite Version: $version"
}

cleanup_existing_dir() {
    [ -d "$BURP_CLONE_DIR" ] && {
        print_status "Cleaning up existing directory $BURP_CLONE_DIR..."
        rm -rf "$BURP_CLONE_DIR" || handle_error "Cleanup failed!"
    }
}

clone_repo() {
    print_status "Cloning the Burp Suite Professional repository..."
    git clone "$REPO_URL" "$BURP_CLONE_DIR" || handle_error "Cloning failed!"
}

setup_burpsuite() {
    print_status "Setting up Burp Suite Professional..."
    sudo mkdir -p "$BURP_DIR" || handle_error "Failed to create directory!"
    wget "$LOADER_JAR_URL" -O "$BURP_DIR/BurpLoaderKeyGen.jar" || handle_error "Failed to download BurpLoaderKeyGen.jar!"
}

generate_script() {
    print_status "Generating executable script for Burp Suite Professional..."
    sudo tee "$BURP_SCRIPT" > /dev/null << EOF
#!/bin/bash
java \\
  -jar $BURP_DIR/burpsuite_pro.jar &
EOF

    sudo chmod +x "$BURP_SCRIPT" || handle_error "Failed to make the script executable!"
    print_status "Script generated at $BURP_SCRIPT"
}

start_key_generator() {
    local username
    username=$(get_username)
    print_status "Starting Key Generator with username: $username..."
    java -jar "$BURP_DIR/BurpLoaderKeyGen.jar" -username "$username" || handle_error "Failed to start the Key Generator!"
    print_status "Key Generator process has started. Follow the instructions to generate the key."
}

launch_burpsuite() {
    print_status "Launching Burp Suite Professional..."
    "$BURP_SCRIPT" || handle_error "Failed to launch Burp Suite!"
}

main() {
    cleanup_existing_dir
    clone_repo
    setup_burpsuite
    download_burpsuite
    generate_script

    if [ ! -f "$USERNAME_FILE" ]; then
        start_key_generator
        sleep 5s  # Ensure Key Generator is fully initialized
    fi

    launch_burpsuite
}

main "$@"
