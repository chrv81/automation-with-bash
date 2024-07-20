#!/bin/bash

# This script is used to remove audio plugins from Logic Pro on macOS.
# It provides a user-friendly interface to select and remove plugins.
# The script supports both dialog-based and manual input methods.

# Variables for repeated paths
...
#!/bin/bash

# Variables for repeated paths
AU_COMPONENTS_SYSTEM="/Library/Audio/Plug-Ins/Components"
AU_COMPONENTS_USER="$HOME/Library/Audio/Plug-Ins/Components"
VST_SYSTEM="/Library/Audio/Plug-Ins/VST"
VST_USER="$HOME/Library/Audio/Plug-Ins/VST"
VST3_SYSTEM="/Library/Audio/Plug-Ins/VST3"
VST3_USER="$HOME/Library/Audio/Plug-Ins/VST3"
AAX_PLUGINS="/Library/Application Support/Avid/Audio/Plug-Ins"
PREFERENCES_USER="$HOME/Library/Preferences"
APPLICATION_SUPPORT_USER="$HOME/Library/Application Support"
APPLICATION_SUPPORT_SYSTEM="/Library/Application Support"
CACHES_USER="$HOME/Library/Caches"
LAUNCH_AGENTS_USER="$HOME/Library/LaunchAgents"
LAUNCH_AGENTS_SYSTEM="/Library/LaunchAgents"
LAUNCH_DAEMONS_SYSTEM="/Library/LaunchDaemons"
EXTENSIONS_SYSTEM="/Library/Extensions"

# Exit script with timer
exit_script() {
    is_failed=$1  # Add parameter to determine success or failure
    echo -n "Exiting"
    for i in {1..3}; do
        echo -n "."
        sleep 1
    done
    echo ""
    if [ "$is_failed" = true ]; then
        exit 1
    else
        exit 0
    fi
}

# Check if the OS is macOS
check_os() {
    if [[ "$OSTYPE" != "darwin"* ]]; then
        echo "This script is only for macOS that has Logic Pro as DAW."
        exit 1
    fi
}

# Install Homebrew
install_brew() {
    echo "Homebrew is required to install dialog. Do you want to install Homebrew? (yes/no)"
    read -r install_brew
    if [[ "$install_brew" == "yes" ]]; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || {
            echo "Failed to install Homebrew. Exiting."
            exit 1
        }
    else
        echo "Homebrew installation declined. Exiting."
        exit 1
    fi
}

# Install dialog using Homebrew
install_dialog() {
    if ! command -v brew &> /dev/null; then
        install_brew
    fi
    brew install dialog || {
        echo "Failed to install dialog. Exiting."
        exit 1
    }
    USE_DIALOG="yes"
}

# Check if dialog is installed and offer to install if not
check_and_install_dialog() {
    if ! command -v dialog &> /dev/null; then
        echo "dialog could not be found. Do you want to install it? (yes/no)"
        read -r install_dialog
        if [[ "$install_dialog" == "yes" ]]; then
            install_dialog
        else
            echo "dialog installation declined. Falling back to manual input method."
            USE_DIALOG="no"
        fi
    else
        USE_DIALOG="yes"
    fi
}

# List all plugins
list_plugins() {
    echo "Listing all plugins..."
    find "$AU_COMPONENTS_SYSTEM" "$AU_COMPONENTS_USER" "$VST_SYSTEM" "$VST_USER" "$VST3_SYSTEM" "$VST3_USER" "$AAX_PLUGINS" -type f \( -name "*.component" -o -name "*.vst" -o -name "*.vst3" -o -name "*.aaxplugin" \) 2>/dev/null
}

# Generate manufacturer list
generate_manufacturer_list() {
    manufacturers=()
    while IFS= read -r plugin; do
        manufacturer=$(basename "$(dirname "$plugin")")
        [[ " ${manufacturers[*]} " =~ " $manufacturer " ]] || manufacturers+=("$manufacturer")
    done < <(find "$AU_COMPONENTS_SYSTEM" "$AU_COMPONENTS_USER" "$VST_SYSTEM" "$VST_USER" "$VST3_SYSTEM" "$VST3_USER" "$AAX_PLUGINS" -type f \( -name "*.component" -o -name "*.vst" -o -name "*.vst3" -o -name "*.aaxplugin" \) 2>/dev/null)
}

# Remove selected plugin
remove_plugin() {
    local plugin_name=$1
    local manufacturer_name=$2

    echo "Removing plugin: $plugin_name from $manufacturer_name"
    sudo rm -rf \
        "$AU_COMPONENTS_SYSTEM/$plugin_name.component" \
        "$AU_COMPONENTS_USER/$plugin_name.component" \
        "$VST_SYSTEM/$plugin_name.vst" \
        "$VST_USER/$plugin_name.vst" \
        "$VST3_SYSTEM/$plugin_name.vst3" \
        "$VST3_USER/$plugin_name.vst3" \
        "$AAX_PLUGINS/$plugin_name.aaxplugin" \
        "$PREFERENCES_USER/com.$manufacturer_name.$plugin_name.plist" \
        "$APPLICATION_SUPPORT_USER/$manufacturer_name/$plugin_name" \
        "$CACHES_USER/com.$manufacturer_name.$plugin_name" \
        "$CACHES_USER/AudioUnitCache/com.apple.audiounits.cache" \
        "$CACHES_USER/com.apple.audiounits.sandboxed.cache" \
        "$CACHES_USER/com.apple.logic10" \
        "$APPLICATION_SUPPORT_USER/$manufacturer_name" \
        "$APPLICATION_SUPPORT_SYSTEM/$manufacturer_name" \
        "$LAUNCH_AGENTS_USER/com.$manufacturer_name.*" \
        "$LAUNCH_AGENTS_SYSTEM/com.$manufacturer_name.*" \
        "$LAUNCH_DAEMONS_SYSTEM/com.$manufacturer_name.*"
    sudo kextunload "$EXTENSIONS_SYSTEM/$plugin_name.kext"
    sudo rm -rf "$EXTENSIONS_SYSTEM/$plugin_name.kext"
    sudo killall -9 AudioComponentRegistrar
    sudo rm -rf "$CACHES_USER/com.apple.audiounits.cache" "$CACHES_USER/com.apple.audiounits.sandboxed.cache"
    echo "Plugin $plugin_name from $manufacturer_name has been removed. Please restart your Mac and rescan plugins in Logic Pro."
}

# Exit script with animation
exit_script() {
    echo -n "Exiting script"
    for i in {1..3}; do
        echo -n "."
        sleep 1
    done
    echo ""
    exit 0
}

# Main script loop with dialog
main_dialog() {
    while true; do
        clear
        echo "Welcome to the Plugin Removal Script!"
        list_plugins

        manufacturer_name=$(dialog --stdout --menu "Select the manufacturer" 15 50 4 "${manufacturers[@]}" "Quit" "Exit the script")
        [[ "$manufacturer_name" == "Quit" ]] && exit_script

        plugin_name=$(dialog --stdout --inputbox "Enter the name of the plugin you want to remove (e.g., Padshop, Retrologue):" 8 50)
        [[ -z "$plugin_name" ]] && { echo "No plugin name entered. Please try again."; continue; }

        remove_plugin "$plugin_name" "$manufacturer_name"

        answer=$(dialog --stdout --menu "Do you want to remove another plugin?" 10 30 2 "yes" "" "no" "")
        [[ "$answer" != "yes" ]] && exit_script
    done
}

# Main script loop with manual input
main_manual() {
    while true; do
        clear
        echo "Welcome to the Plugin Removal Script!"
        list_plugins

        echo "Enter the name of the plugin you want to remove (e.g., Padshop, Retrologue) or type 'quit' or 'exit' to leave:"
        read -r plugin_name
        [[ "$plugin_name" == "quit" || "$plugin_name" == "exit" ]] && exit_script

        echo "Enter the manufacturer name (e.g., steinberg, toontrack, fabfilter):"
        read -r manufacturer_name
        [[ -z "$manufacturer_name" ]] && { echo "No manufacturer name entered. Please try again."; continue; }

        remove_plugin "$plugin_name" "$manufacturer_name"

        echo "Do you want to remove another plugin? (yes/no)"
        read -r answer
        [[ "$answer" != "yes" ]] && exit_script
    done
}

# Script execution starts here
check_os
check_and_install_dialog
generate_manufacturer_list

if [[ "$USE_DIALOG" == "yes" ]]; then
    main_dialog
else
    main_manual
fi
