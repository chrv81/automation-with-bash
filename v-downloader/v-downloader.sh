#!/bin/bash

# Author: Chris
# Date: 11/07/2025
# Description: This script will run yt-dlp along with ffmpeg command to download any video or audio then convert it to a Logic Pro compatible format.
# Usage: ./v-downloader.sh

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

# Check what OS we are running on
check_os() {
  current_os=$(uname -s)
  case "$current_os" in
  Linux*) echo "Linux" ;;
  Darwin*) echo "macOS" ;;
  CYGWIN* | MINGW*) echo "Windows" ;;
  *) echo "Unknown" ;;
  esac
}

# Install `yt-dlp` if not installed
install_yt-dlp() {
  current_o=$(check_os)
  if [ "$os" = "Unknown" ]; then
    echo -e "${RED}Unknown OS: $os${NC}"
    echo -e "${YELLOW}This script is designed for Linux, macOS, or Windows environments.${NC}"
    echo -e "${WHITE}Please run this script on a supported operating system.${NC}"
    echo -e "${RED}Exiting...${NC}"
    exit 1
  fi
}

# Main function
main() {
  echo -e "${CYAN}Running v-downloader script...${RESET}"

  # Check if yt-dlp is installed
  if command -v yt-dlp >/dev/null 2>&1; then
    echo -e "${GREEN}yt-dlp is installed.${RESET} \nMoving on to download process..."
    echo ""
    install_yt-dlp
  else
    echo -e "${YELLOW}yt-dlp is not installed.${RESET} \nPlease install it first."

  fi
}

main
