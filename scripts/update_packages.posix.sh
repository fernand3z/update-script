#!/bin/sh

# Request sudo privileges upfront
echo "Requesting administrator privileges..."
sudo -v || { echo "Failed to obtain administrator privileges. Exiting."; exit 1; }

# Keep sudo timestamp updated in the background
(while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done) 2>/dev/null &

echo "Starting package updates..."

# Helper function for command existence check
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Helper function for error handling
handle_error() {
    echo "Error updating $1: $2"
}

# System Package Managers (requiring sudo)
if command_exists apt; then
    echo "Updating APT packages..."
    if ! { sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y; }; then
        handle_error "APT" "update failed"
    fi
elif command_exists dpkg; then
    echo "Updating DPKG packages..."
    if ! sudo dpkg --configure -a; then
        handle_error "DPKG" "configuration failed"
    fi
elif command_exists dnf; then
    echo "Updating DNF packages..."
    if ! sudo dnf upgrade --refresh -y; then
        handle_error "DNF" "update failed"
    fi
elif command_exists yum; then
    echo "Updating YUM packages..."
    if ! sudo yum update -y; then
        handle_error "YUM" "update failed"
    fi
elif command_exists pacman; then
    echo "Updating Pacman packages..."
    if ! sudo pacman -Syu --noconfirm; then
        handle_error "Pacman" "update failed"
    fi
elif command_exists zypper; then
    echo "Updating Zypper packages..."
    if ! { sudo zypper refresh && sudo zypper update -y; }; then
        handle_error "Zypper" "update failed"
    fi
elif command_exists emerge; then
    echo "Updating Portage packages..."
    if ! { sudo emerge --sync && sudo emerge -uDN @world; }; then
        handle_error "Portage" "update failed"
    fi
elif command_exists xbps-install; then
    echo "Updating XBPS packages..."
    if ! sudo xbps-install -Su; then
        handle_error "XBPS" "update failed"
    fi
elif command_exists apk; then
    echo "Updating APK packages..."
    if ! { sudo apk update && sudo apk upgrade; }; then
        handle_error "APK" "update failed"
    fi
elif command_exists pkgtool; then
    echo "Updating Slackware packages..."
    if ! { sudo slackpkg update && sudo slackpkg upgrade-all; }; then
        handle_error "Slackware" "update failed"
    fi
fi

# Update Snap packages (requires sudo)
if command_exists snap; then
    echo "Updating Snap packages..."
    if ! sudo snap refresh; then
        handle_error "Snap" "update failed"
    fi
fi

# Update and upgrade Homebrew
if command_exists brew; then
    echo "Updating Homebrew..."
    if ! { brew update && brew upgrade && brew cleanup; }; then
        handle_error "Homebrew" "update failed"
    fi
fi

# Update Flatpak packages
if command_exists flatpak; then
    echo "Updating Flatpak..."
    if ! flatpak update -y; then
        handle_error "Flatpak" "update failed"
    fi
fi

# Update Nix packages
if command_exists nix-env; then
    echo "Updating Nix..."
    if ! { nix-channel --update && nix-env -u && nix-collect-garbage -d; }; then
        handle_error "Nix" "update failed"
    fi
fi

# Programming Language Package Managers
if command_exists npm; then
    echo "Updating NPM packages..."
    if ! npm update -g; then
        handle_error "NPM" "update failed"
    fi
fi

if command_exists yarn; then
    echo "Updating Yarn packages..."
    if ! yarn global upgrade; then
        handle_error "Yarn" "update failed"
    fi
fi

if command_exists pnpm; then
    echo "Updating PNPM packages..."
    if ! pnpm update -g; then
        handle_error "PNPM" "update failed"
    fi
fi

if command_exists pip; then
    echo "Updating PIP packages..."
    if ! pip list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1 | xargs -n1 pip install -U; then
        handle_error "PIP" "update failed"
    fi
fi

if command_exists conda; then
    echo "Updating Conda packages..."
    if ! conda update --all -y; then
        handle_error "Conda" "update failed"
    fi
fi

if command_exists gem; then
    echo "Updating Ruby gems..."
    if ! gem update; then
        handle_error "Ruby Gems" "update failed"
    fi
fi

if command_exists composer; then
    echo "Updating Composer packages..."
    if ! composer global update; then
        handle_error "Composer" "update failed"
    fi
fi

if command_exists cargo; then
    echo "Updating Cargo packages..."
    if ! cargo install-update -a; then
        handle_error "Cargo" "update failed"
    fi
fi

# Container and Virtualization
if command_exists docker; then
    echo "Updating Docker images..."
    docker images | grep -v REPOSITORY | awk '{print $1}' | while read -r image; do
        if ! docker pull "$image"; then
            handle_error "Docker" "failed to update $image"
        fi
    done
fi

if command_exists podman; then
    echo "Updating Podman images..."
    podman images | grep -v REPOSITORY | awk '{print $1}' | while read -r image; do
        if ! podman pull "$image"; then
            handle_error "Podman" "failed to update $image"
        fi
    done
fi

if command_exists singularity; then
    echo "Updating Singularity..."
    if ! singularity pull; then
        handle_error "Singularity" "update failed"
    fi
fi

if command_exists minikube; then
    echo "Updating Minikube..."
    if ! minikube update-check; then
        handle_error "Minikube" "update failed"
    fi
fi

echo "All package updates completed!" 