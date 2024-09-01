#!/bin/bash
# Author: Sdmrf

BURP_DIR="/usr/share/burpsuitepro"
BURP_CLONE_DIR="$HOME/BurpSuite-Pro"
BURP_SCRIPT="/usr/local/bin/burpsuitepro"

cleanup_existing_dir() {
    print_status "Cleaning up existing directory $BURP_CLONE_DIR..."
    rm -rf "$BURP_CLONE_DIR" || { echo "Cleanup failed!"; exit 1; }
}

remove_burpsuite() {
    print_status "Removing Burp Suite Professional..."
    sudo rm -rf "$BURP_DIR" || { echo "Failed to remove directory!"; exit 1; }
}

remove_script() {
    print_status "Removing executable script for Burp Suite Professional..."
    sudo rm -f "$BURP_SCRIPT" || { echo "Failed to remove script!"; exit 1; }
}

main () {
    cleanup_existing_dir
    remove_burpsuite
    remove_script
    print_status "Uninstallation complete!"
}

main "$@"