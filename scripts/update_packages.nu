#!/usr/bin/env nu
# vim: syntax=sh
# -*- mode: sh -*-

def handle_error [name: string, msg: string] {
    echo $"Error updating ($name): ($msg)"
}

echo "Starting package updates..."

# Update and upgrade Homebrew
if (which brew | is-empty) == false {
    echo "Updating Homebrew..."
    try { 
        brew update
        brew upgrade
        brew cleanup
    } catch { 
        handle_error "Homebrew" $error.msg
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
        handle_error "Flatpak" $error.msg
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
        handle_error "Snap" $error.msg
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
        handle_error "Nix" $error.msg
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

# System Package Managers
if (which apt | is-empty) == false {
    echo "Updating APT packages..."
    try { 
        sudo apt update
        sudo apt upgrade -y
        sudo apt autoremove -y
    } catch { 
        handle_error "APT" $error.msg
    }
} else if (which dpkg | is-empty) == false {
    echo "Updating DPKG packages..."
    try { 
        sudo dpkg --configure -a
    } catch { 
        handle_error "DPKG" $error.msg
    }
} else if (which dnf | is-empty) == false {
    echo "Updating DNF packages..."
    try { 
        sudo dnf upgrade --refresh -y
    } catch { 
        handle_error "DNF" $error.msg
    }
} else if (which yum | is-empty) == false {
    echo "Updating YUM packages..."
    try { 
        sudo yum update -y
    } catch { 
        handle_error "YUM" $error.msg
    }
} else if (which pacman | is-empty) == false {
    echo "Updating Pacman packages..."
    try { 
        sudo pacman -Syu --noconfirm
    } catch { 
        handle_error "Pacman" $error.msg
    }
} else if (which zypper | is-empty) == false {
    echo "Updating Zypper packages..."
    try { 
        sudo zypper refresh
        sudo zypper update -y
    } catch { 
        handle_error "Zypper" $error.msg
    }
} else {
    echo "No compatible system package manager found for upgrades. Skipping..."
}

# Programming Language Package Managers
if (which npm | is-empty) == false {
    echo "Updating NPM packages..."
    try { 
        npm update -g
    } catch { 
        handle_error "NPM" $error.msg
    }
}

if (which pip | is-empty) == false {
    echo "Updating PIP packages..."
    try { 
        pip list --outdated --format=freeze | lines | str replace -r '^\-e' '' | split column '=' | get column0 | each { |pkg| pip install -U $pkg }
    } catch { 
        handle_error "PIP" $error.msg
    }
}

if (which gem | is-empty) == false {
    echo "Updating Ruby gems..."
    try { 
        gem update
    } catch { 
        handle_error "Ruby Gems" $error.msg
    }
}

if (which cargo | is-empty) == false {
    echo "Updating Cargo packages..."
    try { 
        cargo install-update -a
    } catch { 
        handle_error "Cargo" $error.msg
    }
}

# Container and Virtualization
if (which docker | is-empty) == false {
    echo "Updating Docker images..."
    try {
        docker images | lines | skip 1 | split column ' ' | get column0 | each { |image|
            docker pull $image
        }
    } catch { 
        handle_error "Docker" $error.msg
    }
}

if (which podman | is-empty) == false {
    echo "Updating Podman images..."
    try {
        podman images | lines | skip 1 | split column ' ' | get column0 | each { |image|
            podman pull $image
        }
    } catch { 
        handle_error "Podman" $error.msg
    }
}

echo "All package updates completed!"
