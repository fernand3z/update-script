#!/usr/bin/env bash

echo "Starting package updates..."

# Update and upgrade Homebrew
if command -v brew &> /dev/null; then
    echo "Updating Homebrew..."
    brew update && brew upgrade && brew cleanup
else
    echo "Homebrew not found. Skipping..."
fi

# Update Flatpak packages
if command -v flatpak &> /dev/null; then
    echo "Updating Flatpak..."
    flatpak update -y
else
    echo "Flatpak not found. Skipping..."
fi

# Update Snap packages
if command -v snap &> /dev/null; then
    echo "Updating Snap packages..."
    if ! sudo snap refresh; then
        echo "Error updating Snap packages"
    fi
else
    echo "Snap not found. Skipping..."
fi

# Update Nix packages
if command -v nix-env &> /dev/null; then
    echo "Updating Nix..."
    nix-channel --update && nix-env -u && nix-collect-garbage -d
else
    echo "Nix not found. Skipping..."
fi

# Update Paru packages
if command -v paru &> /dev/null; then
    echo "Updating Paru..."
    paru -Syu --noconfirm
else
    echo "Paru not found. Skipping..."
fi

# Update Yay packages
if command -v yay &> /dev/null; then
    echo "Updating Yay..."
    yay -Syu --noconfirm
else
    echo "Yay not found. Skipping..."
fi

# Update system packages (apt, dnf, pacman)
if command -v apt &> /dev/null; then
    echo "Updating system packages with apt..."
    sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y
elif command -v dnf &> /dev/null; then
    echo "Updating system packages with dnf..."
    sudo dnf upgrade --refresh -y
elif command -v pacman &> /dev/null; then
    echo "Updating system packages with pacman..."
    sudo pacman -Syu --noconfirm
else
    echo "No compatible system package manager found for upgrades. Skipping..."
fi

echo "All package updates completed!"
