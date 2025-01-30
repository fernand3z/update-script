#!/bin/zsh

# Error handling function
function handle_error() {
    echo "Error updating $1: $2" >&2
}

echo "Starting package updates..."

# System Package Managers (requiring sudo)
if command -v apt &> /dev/null; then
    echo "Updating APT packages..."
    if ! { sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y }; then
        handle_error "APT" "update failed"
    fi
elif command -v dpkg &> /dev/null; then
    echo "Updating DPKG packages..."
    if ! sudo dpkg --configure -a; then
        handle_error "DPKG" "configuration failed"
    fi
elif command -v dnf &> /dev/null; then
    echo "Updating DNF packages..."
    if ! sudo dnf upgrade --refresh -y; then
        handle_error "DNF" "update failed"
    fi
elif command -v yum &> /dev/null; then
    echo "Updating YUM packages..."
    if ! sudo yum update -y; then
        handle_error "YUM" "update failed"
    fi
elif command -v pacman &> /dev/null; then
    echo "Updating Pacman packages..."
    if ! sudo pacman -Syu --noconfirm; then
        handle_error "Pacman" "update failed"
    fi
elif command -v zypper &> /dev/null; then
    echo "Updating Zypper packages..."
    if ! { sudo zypper refresh && sudo zypper update -y }; then
        handle_error "Zypper" "update failed"
    fi
elif command -v emerge &> /dev/null; then
    echo "Updating Portage packages..."
    if ! { sudo emerge --sync && sudo emerge -uDN @world }; then
        handle_error "Portage" "update failed"
    fi
elif command -v xbps-install &> /dev/null; then
    echo "Updating XBPS packages..."
    if ! sudo xbps-install -Su; then
        handle_error "XBPS" "update failed"
    fi
elif command -v apk &> /dev/null; then
    echo "Updating APK packages..."
    if ! { sudo apk update && sudo apk upgrade }; then
        handle_error "APK" "update failed"
    fi
elif command -v pkgtool &> /dev/null; then
    echo "Updating Slackware packages..."
    if ! { sudo slackpkg update && sudo slackpkg upgrade-all }; then
        handle_error "Slackware" "update failed"
    fi
fi

# Update Snap packages (requires sudo)
if command -v snap &> /dev/null; then
    echo "Updating Snap packages..."
    if ! sudo snap refresh; then
        handle_error "Snap" "update failed"
    fi
fi

# Update and upgrade Homebrew
if command -v brew &> /dev/null; then
    echo "Updating Homebrew..."
    if ! { brew update && brew upgrade && brew cleanup }; then
        handle_error "Homebrew" "update failed"
    fi
fi

# Update Flatpak packages
if command -v flatpak &> /dev/null; then
    echo "Updating Flatpak..."
    if ! flatpak update -y; then
        handle_error "Flatpak" "update failed"
    fi
fi

# Update Nix packages
if command -v nix-env &> /dev/null; then
    echo "Updating Nix..."
    if ! { nix-channel --update && nix-env -u && nix-collect-garbage -d }; then
        handle_error "Nix" "update failed"
    fi
fi

# Programming Language Package Managers
if command -v npm &> /dev/null; then
    echo "Updating NPM packages..."
    if ! npm update -g; then
        handle_error "NPM" "update failed"
    fi
fi

if command -v yarn &> /dev/null; then
    echo "Updating Yarn packages..."
    if ! yarn global upgrade; then
        handle_error "Yarn" "update failed"
    fi
fi

if command -v pnpm &> /dev/null; then
    echo "Updating PNPM packages..."
    if ! pnpm update -g; then
        handle_error "PNPM" "update failed"
    fi
fi

if command -v pip &> /dev/null; then
    echo "Updating PIP packages..."
    if ! pip list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1 | xargs -n1 pip install -U; then
        handle_error "PIP" "update failed"
    fi
fi

if command -v conda &> /dev/null; then
    echo "Updating Conda packages..."
    if ! conda update --all -y; then
        handle_error "Conda" "update failed"
    fi
fi

if command -v gem &> /dev/null; then
    echo "Updating Ruby gems..."
    if ! gem update; then
        handle_error "Ruby Gems" "update failed"
    fi
fi

if command -v composer &> /dev/null; then
    echo "Updating Composer packages..."
    if ! composer global update; then
        handle_error "Composer" "update failed"
    fi
fi

if command -v cargo &> /dev/null; then
    echo "Updating Cargo packages..."
    if ! cargo install-update -a; then
        handle_error "Cargo" "update failed"
    fi
fi

# Container and Virtualization
if command -v docker &> /dev/null; then
    echo "Updating Docker images..."
    docker images | grep -v REPOSITORY | awk '{print $1}' | while read -r image; do
        if ! docker pull "$image"; then
            handle_error "Docker" "failed to update $image"
        fi
    done
fi

if command -v podman &> /dev/null; then
    echo "Updating Podman images..."
    podman images | grep -v REPOSITORY | awk '{print $1}' | while read -r image; do
        if ! podman pull "$image"; then
            handle_error "Podman" "failed to update $image"
        fi
    done
fi

if command -v singularity &> /dev/null; then
    echo "Updating Singularity..."
    if ! singularity pull; then
        handle_error "Singularity" "update failed"
    fi
fi

if command -v minikube &> /dev/null; then
    echo "Updating Minikube..."
    if ! minikube update-check; then
        handle_error "Minikube" "update failed"
    fi
fi

echo "All package updates completed!"
