#!/bin/bash

# Author: Sdmrf

# Variables
REPO_URL="https://github.com/sdmrf/BurpSuite-Pro.git"
BURP_DIR="/usr/share/burpsuitepro"
BURP_CLONE_DIR="$HOME/BurpSuite-Pro"
BURP_SCRIPT="/usr/local/bin/burpsuitepro"
BURP_RELEASES_URL="https://portswigger.net/burp/releases"
LOADER_JAR_URL="https://raw.githubusercontent.com/sdmrf/BurpSuiteLoaderGen/main/BurpLoaderKeyGen.jar"

print_status() {
    echo -e "\e[1;34m$1\e[0m"
}

error_status() {
    echo -e "\e[1;31m$1\e[0m"
    exit 1
}

cleanup_existing_dir() {
    if [ -d "$BURP_CLONE_DIR" ]; then
        print_status "Cleaning up existing directory $BURP_CLONE_DIR..."
        rm -rf "$BURP_CLONE_DIR" || error_status "Cleanup failed!"
    fi
}

clone_repo() {
    print_status "Cloning the Burp Suite Professional repository..."
    git clone "$REPO_URL" "$BURP_CLONE_DIR" || error_status "Cloning failed!"
}

download_burpsuite() {
    print_status "Downloading the latest Burp Suite Professional..."
    print_status "Please wait while we complete the process :)"
    local html version download_link
    sudo mkdir -p "$BURP_DIR" || error_status "Failed to make directory '$BURP_DIR'"
    html=$(curl -s "$BURP_RELEASES_URL")
    version=$(echo "$html" | grep -Po '(?<=/burp/releases/professional-community-)[0-9]{4}\.[0-9]+\.[0-9]+' | head -n 1)
    download_link="https://portswigger-cdn.net/burp/releases/download?product=pro&type=Jar&version=&"
    sudo wget "$download_link" -O "$BURP_DIR/burpsuite_pro.jar" -q --progress=bar:force || error_status "Download failed!"
    print_status "Downloaded Burp Suite Version: $version"
}

download_loader_jar() {
    print_status "Downloading the latest Burp Loader Key Generator..."
    sudo wget "$LOADER_JAR_URL" -O "$BURP_DIR/BurpLoaderKeyGen.jar" || error_status "Failed to download BurpLoaderKeyGen.jar!"
}

generate_script() {
    print_status "Generating executable script for Burp Suite Professional..."
    sudo tee "$BURP_SCRIPT" > /dev/null << EOF
#!/bin/bash
java \\
  --add-opens=java.desktop/javax.swing=ALL-UNNAMED \\
  --add-opens=java.base/java.lang=ALL-UNNAMED \\
  --add-opens=java.base/jdk.internal.org.objectweb.asm=ALL-UNNAMED \\
  --add-opens=java.base/jdk.internal.org.objectweb.asm.tree=ALL-UNNAMED \\
  --add-opens=java.base/jdk.internal.org.objectweb.asm.Opcodes=ALL-UNNAMED \\
  -javaagent:$BURP_DIR/BurpLoaderKeyGen.jar \\
  -noverify \\
  -jar $BURP_DIR/burpsuite_pro.jar &
EOF

    sudo chmod +x "$BURP_SCRIPT" || error_status "Failed to make the script executable!"
    print_status "Script generated at $BURP_SCRIPT"
}

launch_burpsuite() {
    print_status "Launching Burp Suite Professional..."
    "$BURP_SCRIPT" & sleep 10s || error_status "Failed to launch Burp Suite!"
}

start_key_generator() {
    print_status "Starting Key Generator..."
    java -jar "$BURP_DIR/BurpLoaderKeyGen.jar" || { echo "Failed to start the Key Generator!"; exit 1; }
    print_status "Key Generator process has started. Follow the instructions to generate the key."
}

main() {
    cleanup_existing_dir
    clone_repo
    download_burpsuite
    download_loader_jar
    generate_script
    launch_burpsuite
    start_key_generator
}

main "$@"
