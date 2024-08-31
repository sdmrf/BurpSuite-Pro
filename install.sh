#!/bin/bash

REPO_URL="https://github.com/sdmrf/BurpSuite-Pro.git"
BURP_DIR="/usr/share/burpsuitepro"
BURP_CLONE_DIR="/home/*/BurpSuite-Pro"
BURP_SCRIPT="/usr/local/bin/burpsuitepro"
BURP_RELEASES_URL="https://portswigger.net/burp/releases"
LOADER_JAR="BurpLoaderKeyGen.jar"

print_status() {
    echo -e "\e[1;34m$1\e[0m"
}

download_burpsuite() {
    print_status "Downloading Burpsuite Professional Latest..."
    local html version download_link
    html=$(curl -s "$BURP_RELEASES_URL")
    version=$(echo "$html" | grep -Po '(?<=/burp/releases/professional-community-)[0-9]+\-[0-9]+\-[0-9]+' | head -n 1)
    download_link="https://portswigger-cdn.net/burp/releases/download?product=pro&type=Jar&version=$version"

    print_status "Found Burpsuite Version: $version"
    wget "$download_link" -O "$BURP_DIR/burpsuite_pro_v$version.jar" || { echo "Download failed!"; exit 1; }

    print_status "Renaming JAR file..."
    mv "$BURP_DIR/burpsuite_pro_v$version.jar" "$BURP_DIR/burpsuite_pro_v.jar" || { echo "Renaming JAR failed!"; exit 1; }
}

cleanup_existing_dir() {
    if [ -d "$BURP_CLONE_DIR" ]; then
        print_status "Cleaning up existing directory $BURP_CLONE_DIR..."
        rm -rf "$BURP_CLONE_DIR" || { echo "Cleanup failed!"; exit 1; }
    fi
}

clone_repo() {
    print_status "Cloning Sdmrf Burpsuite Professional..."
    git clone "$REPO_URL" "$BURP_CLONE_DIR" || { echo "Cloning failed!"; exit 1; }
}

setup_burpsuite() {
    print_status "Setting up Burpsuite Professional..."
    sudo mkdir -p "$BURP_DIR" || { echo "Failed to create directory!"; exit 1; }
    sudo cp "$BURP_CLONE_DIR/$LOADER_JAR" "$BURP_DIR" || { echo "Failed to copy $LOADER_JAR!"; exit 1; }
}

generate_script() {
    print_status "Generating executable script for Burpsuite Professional..."
    cat << EOF | sudo tee "$BURP_SCRIPT" > /dev/null
#!/bin/bash
java \\
  --add-opens=java.desktop/javax.swing=ALL-UNNAMED \\
  --add-opens=java.base/java.lang=ALL-UNNAMED \\
  --add-opens=java.base/jdk.internal.org.objectweb.asm=ALL-UNNAMED \\
  --add-opens=java.base/jdk.internal.org.objectweb.asm.tree=ALL-UNNAMED \\
  --add-opens=java.base/jdk.internal.org.objectweb.asm.Opcodes=ALL-UNNAMED \\
  -javaagent:$BURP_DIR/$LOADER_JAR \\
  -noverify \\
  -jar $BURP_DIR/burpsuite_pro_v.jar &
EOF

    sudo chmod +x "$BURP_SCRIPT" || { echo "Failed to make script executable!"; exit 1; }
    print_status "Script generated at $BURP_SCRIPT"
}

launch_burpsuite() {
    print_status "Launching Burpsuite Professional..."
    "$BURP_SCRIPT" || { echo "Failed to launch Burpsuite!"; exit 1; }
}

main() {
    cleanup_existing_dir
    clone_repo
    setup_burpsuite
    cd "$BURP_DIR" || { echo "Cannot navigate to Burpsuite directory!"; exit 1; }
    download_burpsuite
    generate_script
    launch_burpsuite
}

main "$@"
