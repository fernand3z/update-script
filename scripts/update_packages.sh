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

# System Package Managers
if command -v apt &> /dev/null; then
    echo "Updating APT packages..."
    try {
        sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y
    } catch {
        echo "Error updating APT packages"
    }
elif command -v dpkg &> /dev/null; then
    echo "Updating DPKG packages..."
    sudo dpkg --configure -a
elif command -v dnf &> /dev/null; then
    echo "Updating DNF packages..."
    sudo dnf upgrade --refresh -y
elif command -v yum &> /dev/null; then
    echo "Updating YUM packages..."
    sudo yum update -y
elif command -v rpm &> /dev/null; then
    echo "Checking RPM packages..."
    sudo rpm -qa
elif command -v pacman &> /dev/null; then
    echo "Updating Pacman packages..."
    sudo pacman -Syu --noconfirm
elif command -v zypper &> /dev/null; then
    echo "Updating Zypper packages..."
    sudo zypper refresh && sudo zypper update -y
elif command -v emerge &> /dev/null; then
    echo "Updating Portage packages..."
    sudo emerge --sync && sudo emerge -uDN @world
elif command -v xbps-install &> /dev/null; then
    echo "Updating XBPS packages..."
    sudo xbps-install -Su
elif command -v apk &> /dev/null; then
    echo "Updating APK packages..."
    sudo apk update && sudo apk upgrade
elif command -v pkgtool &> /dev/null; then
    echo "Updating Slackware packages..."
    sudo slackpkg update && sudo slackpkg upgrade-all
elif command -v guix &> /dev/null; then
    echo "Updating Guix packages..."
    guix pull && guix upgrade
fi

# Programming Language Package Managers
if command -v npm &> /dev/null; then
    echo "Updating NPM packages..."
    npm update -g
fi

if command -v yarn &> /dev/null; then
    echo "Updating Yarn packages..."
    yarn global upgrade
fi

if command -v pnpm &> /dev/null; then
    echo "Updating PNPM packages..."
    pnpm update -g
fi

if command -v pip &> /dev/null; then
    echo "Updating PIP packages..."
    pip list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1 | xargs -n1 pip install -U
fi

if command -v conda &> /dev/null; then
    echo "Updating Conda packages..."
    conda update --all -y
fi

if command -v poetry &> /dev/null; then
    echo "Updating Poetry packages..."
    poetry self update
fi

if command -v gem &> /dev/null; then
    echo "Updating Ruby gems..."
    gem update
fi

if command -v bundle &> /dev/null; then
    echo "Updating Bundler..."
    bundle update
fi

if command -v mvn &> /dev/null; then
    echo "Updating Maven packages..."
    mvn versions:update-parent versions:update-properties
fi

if command -v gradle &> /dev/null; then
    echo "Updating Gradle..."
    gradle wrapper --gradle-version latest
fi

if command -v composer &> /dev/null; then
    echo "Updating Composer packages..."
    composer global update
fi

if command -v go &> /dev/null; then
    echo "Updating Go packages..."
    go get -u all
fi

if command -v cargo &> /dev/null; then
    echo "Updating Cargo packages..."
    cargo install-update -a
fi

if command -v cpan &> /dev/null; then
    echo "Updating CPAN packages..."
    cpan -u
fi

if command -v R &> /dev/null; then
    echo "Updating R packages..."
    R --quiet -e "update.packages(ask = FALSE)"
fi

if command -v cabal &> /dev/null; then
    echo "Updating Cabal packages..."
    cabal update && cabal upgrade
fi

if command -v stack &> /dev/null; then
    echo "Updating Stack packages..."
    stack upgrade && stack update
fi

if command -v luarocks &> /dev/null; then
    echo "Updating LuaRocks packages..."
    luarocks install --local
fi

# Container and Virtualization
if command -v docker &> /dev/null; then
    echo "Updating Docker images..."
    docker images | grep -v REPOSITORY | awk '{print $1}' | xargs -L1 docker pull
fi

if command -v podman &> /dev/null; then
    echo "Updating Podman images..."
    podman images | grep -v REPOSITORY | awk '{print $1}' | xargs -L1 podman pull
fi

if command -v singularity &> /dev/null; then
    echo "Updating Singularity..."
    singularity pull
fi

if command -v minikube &> /dev/null; then
    echo "Updating Minikube..."
    minikube update-check
fi

echo "All package updates completed!"
