#!/bin/bash

# Author: Chris
# Date: 27/08/2025 (DD/MM/YYYY)
# Description: This script will clean up system cache files on macOS.
# Usage: ./system-cleanup.sh
# Disclaimer: This script is for educational purposes only. Ensure you understand what each command does before running it.
# Note: This script is designed to run on macOS only.

# Color coding
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
WHITE='\033[1;37m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
ORANGE='\033[0;33m' # Note: Bash doesn't have a true orange, this is yellow/brown
BOLD='\033[1m'
UNDERLINE='\033[4m'
RESET='\033[0m' # No Color

ENABLE_DIALOG_CHOICE=false

exist_msg() {
    echo -ne "${RED}Exiting"
    for i in {1..3}; do
        echo -ne "."
        sleep 1
    done
}

check_os() {
    current_os=$(uname -s)
    if [[ $current_os != 'Darwin' ]]; then
        echo -e "${RED}This script is only for macOS.${RESET}"
        exist_msg
        exit 1
    fi
}

text_user_choice() {
    while true; do
        echo -e "${YELLOW}$1 (yes/no)${RESET}"
        read -r choice
        case "$choice" in
            [yY] | [yY][eE][sS])
                echo "yes"
                break
                ;;
            [nN] | [nN][oO])
                echo "no"
                break
                ;;
            *)
                echo -e "${RED}Invalid choice, Try again (yes/no).${RESET}"
                ;;
        esac
    done
}

check_install_dialog() {
    if ! command -v dialog &> /dev/null; then
        echo -e "${YELLOW}The command 'dialog' is not installed.${RESET}"
        # Only pass a simple message, not ASCII art or multi-line text
        user_choice=$(text_user_choice "Would you like to install it using Homebrew?")
        
        if [[ "$user_choice" == "yes" ]]; then
            brew install dialog
             # Check again after install
            if ! command -v dialog &> /dev/null; then
                echo -e "${GREEN}dialog installed successfully!${RESET}"
                ENABLE_DIALOG_CHOICE=true
            else
                echo -e "${RED}Failed to install dialog.${RESET}"
                ENABLE_DIALOG_CHOICE=false
            fi
        else
            echo -e "${RED}Permission to install 'dialog' is denied."
            echo -e "Using regular text input.${RESET}"
            ENABLE_DIALOG_CHOICE=false
        fi
    fi
}

rm_cache() {
    # Location of your user cache directory
    echo -e "${YELLOW}Cache directories to be cleaned:${RESET}"
    cache_dirs=(
        "$HOME/Library/Caches/*"
        "/Library/Caches/*"
        "/System/Library/Caches/*"
        "/private/var/folders/*"
    )
    for dir in "${cache_dirs[@]}"; do
        echo -e "$dir"
    done
    
    if [ "$ENABLE_DIALOG_CHOICE" = true ]; then
        echo "test"
    else 
        user_choice=$(text_user_choice "Do you want to proceed with cleaning these cache directories?")
        if [[ "$user_choice" == "yes" ]]; then
            for directory in "

    fi
}



program_prompt() {
    clear
    cat << 'EOF'
                _                        _                              
               | |                      | |                             
  ___ _   _ ___| |_ ___ _ __ ___     ___| | ___  __ _ _ __  _   _ _ __  
 / __| | | / __| __/ _ \ '_ ` _ \   / __| |/ _ \/ _` | '_ \| | | | '_ \ 
 \__ \ |_| \__ \ ||  __/ | | | | | | (__| |  __/ (_| | | | | |_| | |_) |
 |___/\__, |___/\__\___|_| |_| |_|  \___|_|\___|\__,_|_| |_|\__,_| .__/ 
       __/ |                                                     | |    
      |___/                                                      |_|    

EOF
    echo -e "(c) Copyright - Chris (Viettu) 2025 - All rights reserved."
    echo -e "${YELLOW}This script will clean up system cache files on macOS.${RESET}\n"
    echo -e "=========================================================\n"
}

main() {
    check_os
    program_prompt
    check_install_dialog
    rm_cache
}

main