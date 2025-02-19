#!/bin/bash

# Function to check if 'rofi' is installed
check_and_install_rofi() {
    echo "Checking if 'rofi' is installed..."
    if ! command -v rofi &>/dev/null; then
        echo "'rofi' is not installed. Installing..."
        sudo apt update && sudo apt install rofi -y
    else
        echo "'rofi' is already installed."
    fi
}

# Function to clone or update the repository
clone_or_update_repo() {
    local repo_url="git@github.com:dvdknaap/rofi-hacking-helper.git"
    local target_dir="$HOME/Desktop/base"

    if [ -d "$target_dir" ]; then
        echo "Target directory $target_dir already exists. Pulling latest changes..."
        git -C "$target_dir" pull
    else
        echo "Cloning repository to $target_dir..."
        git clone "$repo_url" "$target_dir"
    fi
}

# Function to set up a keyboard shortcut using XFCE
setup_xfce_shortcut() {
    local shortcut_command="$1"
    local keybind="$2"

    echo "Setting up keyboard shortcut..."
    xfconf-query -c xfce4-keyboard-shortcuts -p "/commands/custom/<Primary><Shift>m" -t string -s "$shortcut_command" --create

    if [ $? -eq 0 ]; then
        echo -e "\e[32mShortcut successfully created! Use $keybind to launch the menu.\e[0m"
    else
        echo -e "\e[31mFailed to create shortcut. Please check your XFCE settings manually.\e[0m"
    fi
}

# Function to check if a keybinding already exists using gsettings
check_gsettings_keybinding() {
    local search_command="$1"

    echo "Checking if keybinding with command '$search_command' already exists..."
    local keybindings
    keybindings=$(gsettings get org.gnome.settings-daemon.plugins.media-keys custom-keybindings | tr -d "[],'")

    for key in $keybindings; do
        local key_path="org.gnome.settings-daemon.plugins.media-keys.custom-keybindings.$key"
        local command
        command=$(gsettings get "$key_path" command | tr -d "'")

        if [[ "$command" == *"$search_command" ]]; then
            echo -e "\e[32mKeybinding already exists:\e[0m $command"
            return 0
        fi
    done

    echo -e "\e[33mNo existing keybinding found for command '$search_command'.\e[0m"
    return 1
}

# Function to set up the addCreds repository and addCreds alias
setup_add_creds() {
    local add_creds_dir="$HOME/.addCreds"
    local add_creds_repo="git@github.com:dvdknaap/add-creds-rofi.git"
    local script_dir=$(dirname "$(realpath "$0")")
    local addCreds_aliases_file="$script_dir/.addCreds_aliases"
    local symlink_target="$HOME/.addCreds_aliases"

    echo "Checking if the addCreds repository exists..."
    if [ -d "$add_creds_dir" ]; then
        echo "addCreds repository already exists. Pulling latest changes..."
        git -C "$add_creds_dir" pull
    else
        echo "Cloning addCreds repository to $add_creds_dir..."
        git clone "$add_creds_repo" "$add_creds_dir"
    fi

    echo "Creating or verifying symlink for .addCreds_aliases..."
    if [ -f "$addCreds_aliases_file" ]; then
        if [ -L "$symlink_target" ]; then
            echo "Symlink already exists."
        else
            ln -sf "$addCreds_aliases_file" "$symlink_target"
            echo "Symlink created: $symlink_target -> $addCreds_aliases_file"
        fi
    else
        echo "Error: .addCreds_aliases file not found in $script_dir."
        return 1
    fi

    echo "Checking if .addCreds_aliases is sourced in shell configuration..."
    for shell_rc in "$HOME/.zshrc" "$HOME/.bashrc"; do
        if [ -f "$shell_rc" ]; then
            if ! grep -q "if [ -f ~/.addCreds_aliases ]; then" "$shell_rc"; then
                echo "Adding sourcing of .addCreds_aliases to $shell_rc..."
                echo "if [ -f ~/.addCreds_aliases ]; then" >> "$shell_rc"
                echo "    . ~/.addCreds_aliases" >> "$shell_rc"
                echo "fi" >> "$shell_rc"
            else
                echo ".addCreds_aliases is already sourced in $shell_rc."
            fi
        fi
    done
}

# Main function to execute the script steps
main() {
    local shortcut_command="$HOME/Desktop/base/code/xdotool/rofisearch_scripts_menu.sh"
    local keybind="Ctrl+Shift+M"

    check_and_install_rofi
    clone_or_update_repo

    # Check for existing keybinding
    check_gsettings_keybinding "$shortcut_command"
    if [ $? -ne 0 ]; then
        setup_xfce_shortcut "$shortcut_command" "$keybind"
    else
        echo "Keybinding setup skipped as it already exists."
    fi

    # Set up addCreds repository and addCreds alias
    setup_add_creds

    echo -e "\n\e[32mSetup is complete. You can now use the menu with $keybind and addCreds in your terminal.\e[0m"
}

# Run the main function
main
