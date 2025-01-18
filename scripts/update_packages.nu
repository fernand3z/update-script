#!/usr/bin/env nu
# vim: syntax=sh
# -*- mode: sh -*-

echo "Starting package updates..."

# Update and upgrade Homebrew
if (which brew | is-empty) == false {
    echo "Updating Homebrew..."
    try { 
        brew update
        brew upgrade
        brew cleanup
    } catch { 
        echo $"Error updating Homebrew: ($error.msg)"
    }
} else {
    echo "Homebrew not found. Skipping..."
}

# Update Flatpak packages
if (which flatpak | is-empty) == false {
    echo "Updating Flatpak..."
    try { 
        flatpak update -y
    } catch { 
        echo $"Error updating Flatpak: ($error.msg)"
    }
} else {
    echo "Flatpak not found. Skipping..."
}

# Update Snap packages
if (which snap | is-empty) == false {
    echo "Updating Snap packages..."
    try { 
        sudo snap refresh
    } catch { 
        echo $"Error updating Snap packages: ($error.msg)"
    }
} else {
    echo "Snap not found. Skipping..."
}

# Update Nix packages
if (which nix-env | is-empty) == false {
    echo "Updating Nix..."
    try { 
        nix-channel --update
        nix-env -u
        nix-collect-garbage -d
    } catch { 
        echo $"Error updating Nix: ($error.msg)"
    }
} else {
    echo "Nix not found. Skipping..."
}

# Update Paru packages
if (which paru | is-empty) == false {
    echo "Updating Paru..."
    try { 
        paru -Syu --noconfirm
    } catch { 
        echo $"Error updating Paru: ($error.msg)"
    }
} else {
    echo "Paru not found. Skipping..."
}

# Update Yay packages
if (which yay | is-empty) == false {
    echo "Updating Yay..."
    try { 
        yay -Syu --noconfirm
    } catch { 
        echo $"Error updating Yay: ($error.msg)"
    }
} else {
    echo "Yay not found. Skipping..."
}

# Update system packages (apt, dnf, pacman)
if (which apt | is-empty) == false {
    echo "Updating system packages with apt..."
    try { 
        sudo apt update
        sudo apt upgrade -y
        sudo apt autoremove -y
    } catch { 
        echo $"Error updating apt packages: ($error.msg)"
    }
} else if (which dnf | is-empty) == false {
    echo "Updating system packages with dnf..."
    try { 
        sudo dnf upgrade --refresh -y
    } catch { 
        echo $"Error updating dnf packages: ($error.msg)"
    }
} else if (which pacman | is-empty) == false {
    echo "Updating system packages with pacman..."
    try { 
        sudo pacman -Syu --noconfirm
    } catch { 
        echo $"Error updating pacman packages: ($error.msg)"
    }
} else {
    echo "No compatible system package manager found for upgrades. Skipping..."
}

echo "All package updates completed!"
