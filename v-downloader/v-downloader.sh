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
      read -r -p "Enter URL: " input_value

      # Stricter regex: must start with http(s):// and have at least one non-space character after
      if [[ "$input_value" =~ ^https?://.+ ]]; then
        echo "$input_value"
        break
      fi
    else
      read -r -p "Enter text: " input_value
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
      ffmpeg -i "$input_file" -c:v copy -c:a aac "$output_file"
      echo -e "${GREEN}Conversion complete. File saved at: ${PURPLE}${output_file}${RESET}"
      ;;
    *)
      echo -e "${YELLOW}Skipping conversion step.${RESET}"
      ;;
  esac
}


# Main function
main() {
  echo -e "${CYAN}Running v-downloader script!${RESET}"

  # Check if yt-dlp is installed
  if ! command -v yt-dlp >/dev/null 2>&1; then
    echo -e "${YELLOW}yt-dlp is not installed.${RESET}"
    install_yt-dlp
  fi

  echo -e "${GREEN}yt-dlp is installed.${RESET} \nMoving on to download process..."
  echo ""

  # Prompt for URL
  echo -e "${CYAN}Please enter the video or audio URL to download:${RESET}"
  url=$(prompt_user "url")

  # Prompt for title
  echo -e "\n${CYAN}Please enter the desired file title (without extension):${RESET}"
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
  convert_ffmpeg

  # Print out the file path for user
  # Find the downloaded file (wildcard for extension)
  echo -e "${GREEN}Your file is saved at: ${PURPLE}${save_dir}/${title}.[extension]${RESET}"
}

main
