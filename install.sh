#!/bin/bash

REPO_URL="https://github.com/sdmrf/BurpSuite-Pro.git"
BURP_DIR="/usr/share/burpsuitepro"
BURP_CLONE_DIR="$HOME/BurpSuite-Pro"
BURP_SCRIPT="/usr/local/bin/burpsuitepro"
BURP_RELEASES_URL="https://portswigger.net/burp/releases"
LOADER_JAR="BurpLoaderKeyGen.jar"

function print_status() {
    echo -e "\e[1;34m$1\e[0m"
}

function download_burpsuite() {
    print_status "Downloading Burpsuite Professional Latest..."
    local html
    html=$(curl -s "$BURP_RELEASES_URL")
    local version
    version=$(echo "$html" | grep -Po '(?<=/burp/releases/professional-community-)[0-9]+\-[0-9]+\-[0-9]+' | head -n 1)
    local download_link="https://portswigger-cdn.net/burp/releases/download?product=pro&type=Jar&version=$version"
    print_status "Found Burpsuite Version: $version"
    wget "$download_link" -O "$BURP_DIR/burpsuite_pro_v$version.jar" --quiet
    echo "$version"
}

if [ -d "$BURP_CLONE_DIR" ]; then
    print_status "Cleaning up existing directory $BURP_CLONE_DIR..."
    rm -rf "$BURP_CLONE_DIR"
fi

print_status "Cloning Sdmrf Burpsuite Professional..."
git clone "$REPO_URL" "$BURP_CLONE_DIR" || { echo "Cloning failed!"; exit 1; }
cd "$BURP_CLONE_DIR" || { echo "Cannot navigate to Burpsuite-Pro directory!"; exit 1; }

print_status "Setting up Burpsuite Professional..."
sudo mkdir -p "$BURP_DIR"
sudo cp "$LOADER_JAR" "$BURP_DIR" || { echo "Failed to copy $LOADER_JAR!"; exit 1; }
cd "$BURP_DIR" || { echo "Cannot navigate to Burpsuite directory!"; exit 1; }

version=$(download_burpsuite)

print_status "Starting Key Generator..."
(java -jar "$BURP_DIR/$LOADER_JAR") & sleep 2

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
  -jar $BURP_DIR/burpsuite_pro_v$version.jar &
EOF

sudo chmod +x "$BURP_SCRIPT"
print_status "Script generated at $BURP_SCRIPT"

print_status "Launching Burpsuite Professional..."
$BURP_SCRIPT
