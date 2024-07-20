#!/bin/bash

# Author: Chris
# Date: 22-08-2023
# Description: This script is used to switch node version based on .nvmrc file

# Color coding
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# use `n` to switch node version
use_n_switch() {
  local desired_version=$(cat .nvmrc 2>/dev/null)
  
  # if desired_version exists, then `n install {version}`
  if [ -n "$desired_version" ]; then
    echo "Switch to version ${desired_version}" 
    n install "$desired_version"
  fi
}

# use `nvm` to switch node version
use_nvm_switch() {
  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"

  # if nvmrc_path exists, then run nvm new version
  if [ -n "$nvmrc_path" ]; then
    local nvmrc_version=$(nvm version "$(cat "${nvmrc_path}")")

    # check
    if [ "$nvmrc_version" = "N/A" ]; then
      # nvm install
      echo "nvmr_version: ${$nvmrc_version}"
    elif [ "$nvmrc_version" != "$current_version" ]; then
    echo "Switch to version ${nvmrc_version}" 
      # nvm use
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    echo -e "${GREEN}Reverting to nvm default version${NC}"
    # nvm use default
  fi
}

# main function
load_version_manager() {
  echo "Running switch version..."
  if command -v n > /dev/null 2>&1; then
    echo -e "${YELLOW}n version manager found${NC}"
    use_n_switch
  elif command -v nvm > /dev/null 2>&1; then
    echo -e "${YELLOW}nvm version manager found${NC}"
    use_nvm_swith
  else
    echo -e "${RED}Neither n nor nvm found. Please install manually according to version inside .nvmrc${NC}"
  fi
}

load_version_manager