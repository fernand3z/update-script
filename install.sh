#!/usr/bin/env bash

echo "Detecting shell type..."

# Ensure the ~/scripts directory exists
if [ ! -d "$HOME/scripts" ]; then
    echo "Creating ~/scripts directory..."
    mkdir -p "$HOME/scripts"
fi

# Detect user's shell
case "$SHELL" in
    *zsh)
        echo "Zsh detected. Copying Zsh script..."
        cp scripts/update_packages.zsh ~/scripts/update_packages
        ;;
    *bash)
        echo "Bash detected. Copying Bash script..."
        cp scripts/update_packages.sh ~/scripts/update_packages
        ;;
    *fish)
        echo "Fish detected. Copying Fish script..."
        cp scripts/update_packages.fish ~/scripts/update_packages
        ;;
    *nu)
        echo "NuShell detected. Copying NuShell script..."
        cp scripts/update_packages.nu ~/scripts/update_packages
        ;;
    *)
        echo "Unsupported shell detected. Please manually choose the script."
        exit 1
        ;;
esac

# Make the script executable
chmod +x ~/scripts/update_packages

echo "Installation complete. Script copied to ~/scripts/update_packages."
echo "You can now run the script using '~/scripts/update_packages'."
