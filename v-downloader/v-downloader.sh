#!/bin/bash

# Author: Chris
# Date: 11/07/2025
# Description: This script will run yt-dlp along with ffmpeg command to download any video or audio then convert it to a Logic Pro compatible format.
# Usage: ./v-downloader.sh
# Disclaimer: This script is for educational purposes only. Ensure you have the right to download and convert any content.
# Note: You must have yt-dlp and ffmpeg installed on your system for this script to work.

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

# Printing exiting message
exit_message() {
  echo -ne "${RED}Exiting"
  for i in {1..3}; do
    echo -ne "."
    sleep 1
  done
  echo -e "${RESET}"
  exit 1
}

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
    exit_message
  fi
  echo -e "${GREEN}Installing yt-dlp...${RESET}"

  # Linux using pip or
  if [ "$current_os" = "Linux" ]; then
    # check if pip3 is installed
    if command -v pip3 >/dev/null 2>&1; then
      pip3 install yt-dlp
    else
      echo -e "${YELLOW}pip3 is not installed. Please install pip3 first.${RESET}"
      exit_message
    fi
  elif [ "$current_os" = "macOS" ]; then
    # check if brew is installed
    if command -v brew >/dev/null 2>&1; then
      brew install yt-dlp
    else
      echo -e "${YELLOW}Homebrew is not installed. Please install Homebrew first.${RESET}"
      exit_message
    fi
  elif [ "$current_os" = "Windows" ]; then
    # check if pip is installed
    if command -v pip >/dev/null 2>&1; then
      pip install yt-dlp
    else
      echo -e "${YELLOW}pip is not installed. Please install pip first.${RESET}"
      exit_message
    fi
  fi

  echo -e "${GREEN}yt-dlp installed successfully!${RESET}"
  echo -e "${CYAN}Moving on to download process.${RESET}"
}

# Prompt user for any input
prompt_user() {
  local type_of_input="$1"
  local input_value

  while true; do
    if [ "$type_of_input" = "url" ]; then
      read -r -p "URL: " input_value

      # Stricter regex: must start with http(s):// and have at least one non-space character after
      if [[ "$input_value" =~ ^https?://.+ ]]; then
        echo "$input_value"
        break
      fi
    else
      read -r -p "Title: " input_value
      if [ -n "$input_value" ]; then
        echo "$input_value"
        break
      fi
    fi
  done
}

# Convert video for Logic Pro compatibility
convert_ffmpeg() {
  # Ask if user wants to convert the file
  echo -e "\n${CYAN}Do you want to convert the file for Logic Pro compatibility? [y/yes/n/no]:${RESET}"
  read -r convert_choice

  case "$convert_choice" in
    [yY] | [yY][eE][sS])
      echo -e "${GREEN}Converting file using ffmpeg...${RESET}"
      if [ -z "$input_file" ]; then
        echo -e "${RED}Error: Downloaded file not found for conversion.${RESET}"
        exit_message
      fi
      # Generate output filename based on input filename
      output_file="${input_file%.*}_converted.mp4"
      ffmpeg -i "$input_file" -c:v copy -c:a aac -b:a 320k -ar 48000 -ac 2 "$output_file"
      if [ $? -ne 0 ]; then
        echo -e "${RED}Error: ffmpeg conversion failed.${RESET}"
        exit_message
      else
        echo -e "${GREEN}Conversion complete. File saved at: ${PURPLE}${output_file}${RESET}"
      fi
      ;;
    *)
      echo -e "${YELLOW}Skipping conversion step.${RESET}"
      ;;
  esac
}


legal_prompt() {
  clear

  cat << 'EOF'
   _           ____  ____  _      _      _     ____  ____  ____ 
/ \ |\      /  _ \/  _ \/ \  /|/ \  /|/ \   /  _ \/  _ \/  _ \
| | //_____ | | \|| / \|| |  ||| |\ ||| |   | / \|| / \|| | \|
| \// \____\| |_/|| \_/|| |/\||| | \||| |_\| \_/|| |-||| |_/|
\__/        \____/\____/\_/  \|\_/  \|\____/\____/\_/ \|\____/

EOF

  echo -e "\n\n(c) Copyright - Chris (Viettu) 2025 - All rights reserved.\n\n"

  echo -e "${YELLOW}================== USER AGREEMENT =================="
  echo ""
  echo "By using this script, you agree to comply with all applicable copyright laws and the terms of service of the platforms from which you download content."
  echo "This script is intended for use with videos that are either in the public domain or licensed under Creative Commons."
  echo "You are solely responsible for ensuring that your use of this script complies with all relevant laws and regulations."
  echo "The author of this script assumes no responsibility for any misuse or illegal activities conducted using this tool."
  echo "Please use this script ethically and respect the rights of content creators."
  echo ""
  echo "================== DISCLAIMER =================="
  echo ""
  echo "The developer of this script is not responsible for any legal issues arising from the misuse of this tool."
  echo "Nor the developer is affiliated with or endorsed by any video hosting platforms."
  echo "Users are encouraged to verify the copyright status of any content before downloading or using it."
  echo "Always seek permission from content creators when in doubt."
  echo ""
  echo "========================================================="
  echo -e "${RESET}"
}

# Main function
main() {

  legal_prompt

  # Check if yt-dlp is installed
  if ! command -v yt-dlp >/dev/null 2>&1; then
    echo -e "${RED}yt-dlp is not installed.${RESET}"
    install_yt-dlp
  fi

  # Prompt for URL
  echo -e "\nPlease enter the video or audio URL to download:"
  url=$(prompt_user "url")

  # Prompt for title
  echo -e "\nPlease enter the desired file title (without extension):"
  title=$(prompt_user "text")

  # Prompt for directory
  echo -e "\n${CYAN}Enter (absolute path) directory or press <Enter> to stay in current):${RESET}"
  while true; do
    read -e -r save_dir
    # default to current directory if empty
    if [ -z "$save_dir" ]; then
      save_dir="."
      break
    elif [ -d "$save_dir" ]; then
      break
    else
      echo -e "${RED}Directory does not exist. Please enter a valid directory or leave empty for current folder.${RESET}"
    fi
  done

  # Run yt-dlp with user inputs
  yt-dlp -f "bestvideo+bestaudio/best" -o "${save_dir}/${title}.%(ext)s" "$url"

  # Wait a bit to ensure file is written
  sleep 3

  # Find the downloaded file (wildcard for extension)
  input_file=$(ls "${save_dir}/${title}."* 2>/dev/null | head -n 1)

  if [ -n "$input_file" ]; then
    convert_ffmpeg
    echo -e "${GREEN}Your file is saved at: ${PURPLE}${input_file}${RESET}"
  else
    echo -e "${RED}Downloaded file not found.${RESET}"
  fi

}

main
