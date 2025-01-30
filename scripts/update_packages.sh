#!/bin/bash

# Request sudo privileges upfront
echo "Requesting administrator privileges..."
sudo -v || { echo "Failed to obtain administrator privileges. Exiting."; exit 1; }

# Keep sudo timestamp updated
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

echo "Starting package updates..."

# System Package Managers
if command -v apt &> /dev/null; then
    echo "Updating APT packages..."
    sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y || echo "Error updating APT packages"
fi

if command -v dpkg &> /dev/null; then
    echo "Updating DPKG packages..."
    sudo dpkg --configure -a
fi

if command -v dnf &> /dev/null; then
    echo "Updating DNF packages..."
    sudo dnf upgrade --refresh -y
fi

if command -v yum &> /dev/null; then
    echo "Updating YUM packages..."
    sudo yum update -y
fi

if command -v pacman &> /dev/null; then
    echo "Updating Pacman packages..."
    sudo pacman -Syu --noconfirm
fi

if command -v zypper &> /dev/null; then
    echo "Updating Zypper packages..."
    sudo zypper refresh && sudo zypper update -y
fi

if command -v emerge &> /dev/null; then
    echo "Updating Portage packages..."
    sudo emerge --sync && sudo emerge -uDN @world
fi

if command -v xbps-install &> /dev/null; then
    echo "Updating XBPS packages..."
    sudo xbps-install -Su
fi

if command -v apk &> /dev/null; then
    echo "Updating APK packages..."
    sudo apk update && sudo apk upgrade
fi

if command -v snap &> /dev/null; then
    echo "Updating Snap packages..."
    sudo snap refresh || echo "Error updating Snap packages"
fi

if command -v brew &> /dev/null; then
    echo "Updating Homebrew..."
    brew update && brew upgrade && brew cleanup
fi

if command -v flatpak &> /dev/null; then
    echo "Updating Flatpak..."
    flatpak update -y
fi

if command -v nix-env &> /dev/null; then
    echo "Updating Nix..."
    nix-channel --update && nix-env -u && nix-collect-garbage -d
fi

if command -v paru &> /dev/null; then
    echo "Updating Paru..."
    paru -Syu --noconfirm
fi

if command -v yay &> /dev/null; then
    echo "Updating Yay..."
    yay -Syu --noconfirm
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
    pip install --upgrade pip
    pip freeze --local | cut -d= -f1 | xargs -n1 pip install --upgrade
fi


if command -v poetry &> /dev/null; then
    echo "Updating Poetry packages..."
    poetry self update
fi

if command -v gem &> /dev/null; then
    echo "Updating Ruby gems..."
    gem update
fi

if command -v composer &> /dev/null; then
    echo "Updating Composer packages..."
    composer global update
fi

if command -v go &> /dev/null; then
    echo "Updating Go packages..."
    go install $(go list -m all | awk '{print $1}')@latest
fi

if command -v cargo &> /dev/null; then
    echo "Checking Cargo package manager..."

    # Ensure cargo-update is installed first
    if ! cargo install --list | grep -q "cargo-update"; then
        echo "cargo-update not found. Installing..."
        cargo install cargo-update
    fi

    echo "Updating Cargo-installed packages..."
    cargo install-update -a || echo "Error updating Cargo packages"
fi

if command -v luarocks &> /dev/null; then
    echo "Updating LuaRocks packages..."
    luarocks install luarocks
fi

# Conda Package Updates
if command -v conda &> /dev/null; then
    echo "Updating Conda and all Conda packages..."
    conda update -n base -c defaults conda -y && conda update --all -y
fi

# Container and Virtualization
if command -v docker &> /dev/null; then
    echo "Updating Docker images..."
    docker images --format "{{.Repository}}" | xargs -L1 docker pull
fi

if command -v podman &> /dev/null; then
    echo "Updating Podman images..."
    podman images --format "{{.Repository}}" | xargs -L1 podman pull
fi

if command -v minikube &> /dev/null; then
    echo "Updating Minikube..."
    minikube update-check
fi

echo "All package updates completed!"
