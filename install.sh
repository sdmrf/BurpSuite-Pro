#!/bin/bash

# Define constants
REPO_URL="https://github.com/sdmrf/BurpSuite-Pro.git"
BURP_DIR="/usr/share/burpsuitepro"
BURP_SCRIPT="/usr/local/bin/burpsuitepro"
BURP_RELEASES_URL="https://portswigger.net/burp/releases"
LOADER_JAR="BurpLoaderKeyGen.jar"

# Function to print status messages
function print_status() {
    echo -e "\e[1;34m$1\e[0m"
}

# Function to download the latest Burp Suite Professional version
function download_burpsuite() {
    print_status "Downloading Burpsuite Professional Latest..."
    local html
    html=$(curl -s "$BURP_RELEASES_URL")
    local version
    version=$(echo "$html" | grep -Po '(?<=/burp/releases/professional-community-)[0-9]+\-[0-9]+\-[0-9]+' | head -n 1)
    local download_link="https://portswigger-cdn.net/burp/releases/download?product=pro&type=Jar&version=&"
    print_status "Found Burpsuite Version: $version"
    wget "$download_link" -O "burpsuite_pro_v$version.jar" --quiet
}

# Clone the repository
print_status "Cloning Sdmrf Burpsuite Professional..."
git clone "$REPO_URL" "$HOME/Burpsuite-Pro" || { echo "Cloning failed!"; exit 1; }
cd "$HOME/Burpsuite-Pro" || { echo "Cannot navigate to Burpsuite-Pro directory!"; exit 1; }

# Set up Burp Suite directory and copy loader
print_status "Setting up Burpsuite Professional..."
sudo mkdir -p "$BURP_DIR"
sudo cp -r "$LOADER_JAR" "$BURP_DIR"
cd "$BURP_DIR" || { echo "Cannot navigate to Burpsuite directory!"; exit 1; }

# Download the latest Burp Suite Professional
download_burpsuite

# Start the Key Generator
print_status "Starting Key Generator..."
(java -jar "$HOME/Burpsuite-Pro/$LOADER_JAR") & sleep 2

# Generate executable script for Burp Suite
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

# Make the script executable
sudo chmod +x "$BURP_SCRIPT"
print_status "Script generated at $BURP_SCRIPT"

# Execute Burp Suite Professional
print_status "Launching Burpsuite Professional..."
$BURP_SCRIPT
