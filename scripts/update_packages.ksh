#!/bin/ksh

# Request sudo privileges upfront
echo "Requesting administrator privileges..."
sudo -v || { echo "Failed to obtain administrator privileges. Exiting."; exit 1; }

# Keep sudo timestamp updated in the background
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

function handle_error {
    print -u2 "Error updating $1: $2"
}

print "Starting package updates..."

# Update and upgrade Homebrew
if whence brew >/dev/null 2>&1; then
    print "Updating Homebrew..."
    if ! { brew update && brew upgrade && brew cleanup }; then
        handle_error "Homebrew" "update failed"
    fi
fi

# Update Flatpak packages
if whence flatpak >/dev/null 2>&1; then
    print "Updating Flatpak..."
    if ! flatpak update -y; then
        handle_error "Flatpak" "update failed"
    fi
fi

# Update Snap packages
if whence snap >/dev/null 2>&1; then
    print "Updating Snap packages..."
    if ! sudo snap refresh; then
        handle_error "Snap" "update failed"
    fi
fi

# Update Nix packages
if whence nix-env >/dev/null 2>&1; then
    print "Updating Nix..."
    if ! { nix-channel --update && nix-env -u && nix-collect-garbage -d }; then
        handle_error "Nix" "update failed"
    fi
fi

# System Package Managers
if whence apt >/dev/null 2>&1; then
    print "Updating APT packages..."
    if ! { sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y }; then
        handle_error "APT" "update failed"
    fi
elif whence dpkg >/dev/null 2>&1; then
    print "Updating DPKG packages..."
    if ! sudo dpkg --configure -a; then
        handle_error "DPKG" "configuration failed"
    fi
elif whence dnf >/dev/null 2>&1; then
    print "Updating DNF packages..."
    if ! sudo dnf upgrade --refresh -y; then
        handle_error "DNF" "update failed"
    fi
elif whence yum >/dev/null 2>&1; then
    print "Updating YUM packages..."
    if ! sudo yum update -y; then
        handle_error "YUM" "update failed"
    fi
elif whence pacman >/dev/null 2>&1; then
    print "Updating Pacman packages..."
    if ! sudo pacman -Syu --noconfirm; then
        handle_error "Pacman" "update failed"
    fi
elif whence zypper >/dev/null 2>&1; then
    print "Updating Zypper packages..."
    if ! { sudo zypper refresh && sudo zypper update -y }; then
        handle_error "Zypper" "update failed"
    fi
fi

# Programming Language Package Managers
if whence npm >/dev/null 2>&1; then
    print "Updating NPM packages..."
    if ! npm update -g; then
        handle_error "NPM" "update failed"
    fi
fi

if whence pip >/dev/null 2>&1; then
    print "Updating PIP packages..."
    if ! pip list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1 | xargs -n1 pip install -U; then
        handle_error "PIP" "update failed"
    fi
fi

if whence gem >/dev/null 2>&1; then
    print "Updating Ruby gems..."
    if ! gem update; then
        handle_error "Ruby Gems" "update failed"
    fi
fi

if whence cargo >/dev/null 2>&1; then
    print "Updating Cargo packages..."
    if ! cargo install-update -a; then
        handle_error "Cargo" "update failed"
    fi
fi

# Container and Virtualization
if whence docker >/dev/null 2>&1; then
    print "Updating Docker images..."
    docker images | grep -v REPOSITORY | awk '{print $1}' | while read -r image; do
        if ! docker pull "$image"; then
            handle_error "Docker" "failed to update $image"
        fi
    done
fi

if whence podman >/dev/null 2>&1; then
    print "Updating Podman images..."
    podman images | grep -v REPOSITORY | awk '{print $1}' | while read -r image; do
        if ! podman pull "$image"; then
            handle_error "Podman" "failed to update $image"
        fi
    done
fi

print "All package updates completed!" 