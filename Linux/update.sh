#!/bin/bash

# Author: Sdmrf

# Variables
BURP_DIR="/usr/share/burpsuitepro"
BURP_CLONE_DIR="$HOME/BurpSuite-Pro"
BURP_SCRIPT="/usr/local/bin/burpsuitepro"
LOADER_JAR="$BURP_DIR/loader.jar"
BURP_RELEASES_URL="https://portswigger.net/burp/releases"

print_status() {
    echo -e "\e[1;34m$1\e[0m"
}

remove_old_files() {
    print_status 'Removing Old Files...'
    sudo rm -f "$BURP_DIR"/*.jar || { echo "Failed to remove old JAR files!"; exit 1; }
    sudo rm -f "$BURP_SCRIPT" || { echo "Failed to remove old script!"; exit 1; }
}

copy_loader_jar() {
    print_status 'Copying loader.jar...'
    if [ -f "$BURP_CLONE_DIR/loader.jar" ]; then
        sudo cp "$BURP_CLONE_DIR/loader.jar" "$LOADER_JAR" || { echo "Failed to copy loader.jar!"; exit 1; }
    else
        echo "loader.jar not found in $BURP_CLONE_DIR!"
        exit 1
    fi
}

download_burpsuite() {
    print_status 'Downloading Burp Suite Professional...'
    html=$(curl -s "$BURP_RELEASES_URL")
    version=$(echo "$html" | grep -Po '(?<=/burp/releases/professional-community-)[0-9]+\-[0-9]+\-[0-9]+' | head -n 1)
    download_link="https://portswigger-cdn.net/burp/releases/download?product=pro&type=Jar&version=&"

    wget "$download_link" -O "$BURP_DIR/burpsuite_pro.jar" --quiet --show-progress || { echo "Failed to download Burp Suite Professional!"; exit 1; }
    print_status "Downloaded Burp Suite Version: $version"
}

generate_executable_script() {
    print_status 'Generating executable script for Burp Suite Professional...'
    sudo tee "$BURP_SCRIPT" > /dev/null << EOF
#!/bin/bash
java \\
  --add-opens=java.desktop/javax.swing=ALL-UNNAMED \\
  --add-opens=java.base/java.lang=ALL-UNNAMED \\
  --add-opens=java.base/jdk.internal.org.objectweb.asm=ALL-UNNAMED \\
  --add-opens=java.base/jdk.internal.org.objectweb.asm.tree=ALL-UNNAMED \\
  --add-opens=java.base/jdk.internal.org.objectweb.asm.Opcodes=ALL-UNNAMED \\
  -javaagent:$LOADER_JAR \\
  -noverify \\
  -jar $BURP_DIR/burpsuite_pro.jar &
EOF

    sudo chmod +x "$BURP_SCRIPT" || { echo "Failed to make the script executable!"; exit 1; }
    sudo cp "$BURP_SCRIPT" /bin/burpsuitepro || { echo "Failed to copy the script to /bin!"; exit 1; }
}

execute_burpsuite() {
    print_status 'Executing Burp Suite Professional...'
    "$BURP_SCRIPT" || { echo "Failed to launch Burp Suite!"; exit 1; }
}

main() {
    remove_old_files
    copy_loader_jar
    download_burpsuite
    generate_executable_script
    execute_burpsuite
}

main "$@"
