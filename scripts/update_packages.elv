#!/usr/bin/env elvish

fn handle-error {|name msg|
    echo "Error updating "$name": "$msg"" >&2
}

echo "Starting package updates..."

# System Package Managers (requiring sudo)
if (has-external apt) {
    echo "Updating APT packages..."
    try {
        sudo apt update
        sudo apt upgrade -y
        sudo apt autoremove -y
    } catch e {
        handle-error "APT" "update failed"
    }
} elif (has-external dpkg) {
    echo "Updating DPKG packages..."
    try {
        sudo dpkg --configure -a
    } catch e {
        handle-error "DPKG" "configuration failed"
    }
} elif (has-external dnf) {
    echo "Updating DNF packages..."
    try {
        sudo dnf upgrade --refresh -y
    } catch e {
        handle-error "DNF" "update failed"
    }
} elif (has-external yum) {
    echo "Updating YUM packages..."
    try {
        sudo yum update -y
    } catch e {
        handle-error "YUM" "update failed"
    }
} elif (has-external pacman) {
    echo "Updating Pacman packages..."
    try {
        sudo pacman -Syu --noconfirm
    } catch e {
        handle-error "Pacman" "update failed"
    }
} elif (has-external zypper) {
    echo "Updating Zypper packages..."
    try {
        sudo zypper refresh
        sudo zypper update -y
    } catch e {
        handle-error "Zypper" "update failed"
    }
} elif (has-external emerge) {
    echo "Updating Portage packages..."
    try {
        sudo emerge --sync
        sudo emerge -uDN @world
    } catch e {
        handle-error "Portage" "update failed"
    }
} elif (has-external xbps-install) {
    echo "Updating XBPS packages..."
    try {
        sudo xbps-install -Su
    } catch e {
        handle-error "XBPS" "update failed"
    }
} elif (has-external apk) {
    echo "Updating APK packages..."
    try {
        sudo apk update
        sudo apk upgrade
    } catch e {
        handle-error "APK" "update failed"
    }
} elif (has-external pkgtool) {
    echo "Updating Slackware packages..."
    try {
        sudo slackpkg update
        sudo slackpkg upgrade-all
    } catch e {
        handle-error "Slackware" "update failed"
    }
}

# Update Snap packages (requires sudo)
if (has-external snap) {
    echo "Updating Snap packages..."
    try {
        sudo snap refresh
    } catch e {
        handle-error "Snap" "update failed"
    }
}

# Update and upgrade Homebrew
if (has-external brew) {
    echo "Updating Homebrew..."
    try {
        brew update
        brew upgrade
        brew cleanup
    } catch e {
        handle-error "Homebrew" "update failed"
    }
}

# Update Flatpak packages
if (has-external flatpak) {
    echo "Updating Flatpak..."
    try {
        flatpak update -y
    } catch e {
        handle-error "Flatpak" "update failed"
    }
}

# Update Nix packages
if (has-external nix-env) {
    echo "Updating Nix..."
    try {
        nix-channel --update
        nix-env -u
        nix-collect-garbage -d
    } catch e {
        handle-error "Nix" "update failed"
    }
}

# Programming Language Package Managers
if (has-external npm) {
    echo "Updating NPM packages..."
    try {
        npm update -g
    } catch e {
        handle-error "NPM" "update failed"
    }
}

if (has-external pip) {
    echo "Updating PIP packages..."
    try {
        pip list --outdated --format=freeze | each {|pkg|
            pip install -U $pkg
        }
    } catch e {
        handle-error "PIP" "update failed"
    }
}

if (has-external gem) {
    echo "Updating Ruby gems..."
    try {
        gem update
    } catch e {
        handle-error "Ruby Gems" "update failed"
    }
}

# Container and Virtualization
if (has-external docker) {
    echo "Updating Docker images..."
    try {
        docker images | each {|line|
            if (not (eq $line[0] "REPOSITORY")) {
                docker pull $line[0]
            }
        }
    } catch e {
        handle-error "Docker" "update failed"
    }
}

echo "All package updates completed!" 