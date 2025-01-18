#!/usr/bin/env fish

echo "Starting package updates..."

# Update and upgrade Homebrew
if type -q brew
    echo "Updating Homebrew..."
    brew update && brew upgrade && brew cleanup
else
    echo "Homebrew not found. Skipping..."
end

# Update Flatpak packages
if type -q flatpak
    echo "Updating Flatpak..."
    flatpak update -y
else
    echo "Flatpak not found. Skipping..."
end

# Update Snap packages
if type -q snap
    echo "Updating Snap packages..."
    if not sudo snap refresh
        echo "Error updating Snap packages"
    end
else
    echo "Snap not found. Skipping..."
end

# Update Nix packages
if type -q nix-env
    echo "Updating Nix..."
    nix-channel --update; and nix-env -u; and nix-collect-garbage -d
else
    echo "Nix not found. Skipping..."
end

# Update Paru packages
if type -q paru
    echo "Updating Paru..."
    paru -Syu --noconfirm
else
    echo "Paru not found. Skipping..."
end

# Update Yay packages
if type -q yay
    echo "Updating Yay..."
    yay -Syu --noconfirm
else
    echo "Yay not found. Skipping..."
end

# Update system packages (apt, dnf, pacman)
if type -q apt
    echo "Updating system packages with apt..."
    sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y
else if type -q dnf
    echo "Updating system packages with dnf..."
    sudo dnf upgrade --refresh -y
else if type -q pacman
    echo "Updating system packages with pacman..."
    sudo pacman -Syu --noconfirm
else
    echo "No compatible system package manager found for upgrades. Skipping..."
end

echo "All package updates completed!"
