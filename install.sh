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
        cp scripts/update_packages.sh ~/scripts/update_packages
        ;;
    *bash)
        echo "Bash detected. Copying Bash script..."
        cp scripts/update_packages.sh ~/scripts/update_packages
        ;;
    *fish)
        echo "Fish detected. Copying Fish script..."
        cp scripts/update_packages.sh ~/scripts/update_packages
        ;;
    *nu)
        echo "NuShell detected. Copying NuShell script..."
        cp scripts/update_packages.sh ~/scripts/update_packages
        ;;
    *ksh)
        echo "Korn Shell detected. Copying KSH script..."
        cp scripts/update_packages.sh ~/scripts/update_packages
        ;;
    *csh|*tcsh)
        echo "C Shell/TC Shell detected. Copying CSH script..."
        cp scripts/update_packages.sh ~/scripts/update_packages
        ;;
    *dash)
        echo "Dash detected. Copying Dash script..."
        cp scripts/update_packages.sh ~/scripts/update_packages
        ;;
    *elvish)
        echo "Elvish detected. Copying Elvish script..."
        cp scripts/update_packages.sh ~/scripts/update_packages
        ;;
    *xonsh)
        echo "Xonsh detected. Copying Xonsh script..."
        cp scripts/update_packages.sh ~/scripts/update_packages
        ;;
    *busybox)
        echo "BusyBox Shell detected. Copying BusyBox script..."
        cp scripts/update_packages.sh ~/scripts/update_packages
        ;;
    *sh)
        echo "Bourne Shell detected. Copying POSIX sh script..."
        cp scripts/update_packages.sh ~/scripts/update_packages
        ;;
    *)
        echo "Unsupported shell detected. Using POSIX sh compatible script as fallback..."
        cp scripts/update_packages.sh ~/scripts/update_packages
        ;;
esac

# Make the script executable
chmod +x ~/scripts/update_packages

echo "Installation complete. Script copied to ~/scripts/update_packages."
echo "You can now run the script using '~/scripts/update_packages'."
