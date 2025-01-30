#!/usr/bin/env xonsh

import sys

def handle_error(name, msg):
    print(f"Error updating {name}: {msg}", file=sys.stderr)

print("Starting package updates...")

# System Package Managers (requiring sudo)
if which('apt'):
    print("Updating APT packages...")
    try:
        ![sudo apt update]
        ![sudo apt upgrade -y]
        ![sudo apt autoremove -y]
    except:
        handle_error("APT", "update failed")
elif which('dpkg'):
    print("Updating DPKG packages...")
    try:
        ![sudo dpkg --configure -a]
    except:
        handle_error("DPKG", "configuration failed")
elif which('dnf'):
    print("Updating DNF packages...")
    try:
        ![sudo dnf upgrade --refresh -y]
    except:
        handle_error("DNF", "update failed")
elif which('yum'):
    print("Updating YUM packages...")
    try:
        ![sudo yum update -y]
    except:
        handle_error("YUM", "update failed")
elif which('pacman'):
    print("Updating Pacman packages...")
    try:
        ![sudo pacman -Syu --noconfirm]
    except:
        handle_error("Pacman", "update failed")
elif which('zypper'):
    print("Updating Zypper packages...")
    try:
        ![sudo zypper refresh]
        ![sudo zypper update -y]
    except:
        handle_error("Zypper", "update failed")
elif which('emerge'):
    print("Updating Portage packages...")
    try:
        ![sudo emerge --sync]
        ![sudo emerge -uDN @world]
    except:
        handle_error("Portage", "update failed")
elif which('xbps-install'):
    print("Updating XBPS packages...")
    try:
        ![sudo xbps-install -Su]
    except:
        handle_error("XBPS", "update failed")
elif which('apk'):
    print("Updating APK packages...")
    try:
        ![sudo apk update]
        ![sudo apk upgrade]
    except:
        handle_error("APK", "update failed")
elif which('pkgtool'):
    print("Updating Slackware packages...")
    try:
        ![sudo slackpkg update]
        ![sudo slackpkg upgrade-all]
    except:
        handle_error("Slackware", "update failed")

# Update Snap packages (requires sudo)
if which('snap'):
    print("Updating Snap packages...")
    try:
        ![sudo snap refresh]
    except:
        handle_error("Snap", "update failed")

# Update and upgrade Homebrew
if which('brew'):
    print("Updating Homebrew...")
    try:
        ![brew update]
        ![brew upgrade]
        ![brew cleanup]
    except:
        handle_error("Homebrew", "update failed")

# Update Flatpak packages
if which('flatpak'):
    print("Updating Flatpak...")
    try:
        ![flatpak update -y]
    except:
        handle_error("Flatpak", "update failed")

# Update Nix packages
if which('nix-env'):
    print("Updating Nix...")
    try:
        ![nix-channel --update]
        ![nix-env -u]
        ![nix-collect-garbage -d]
    except:
        handle_error("Nix", "update failed")

# Programming Language Package Managers
if which('npm'):
    print("Updating NPM packages...")
    try:
        ![npm update -g]
    except:
        handle_error("NPM", "update failed")

if which('pip'):
    print("Updating PIP packages...")
    try:
        for pkg in $(pip list --outdated --format=freeze).split('\n'):
            if pkg:
                pkg_name = pkg.split('==')[0]
                ![pip install -U @(pkg_name)]
    except:
        handle_error("PIP", "update failed")

if which('yarn'):
    print("Updating Yarn packages...")
    try:
        ![yarn global upgrade]
    except:
        handle_error("Yarn", "update failed")

if which('pnpm'):
    print("Updating PNPM packages...")
    try:
        ![pnpm update -g]
    except:
        handle_error("PNPM", "update failed")

if which('gem'):
    print("Updating Ruby gems...")
    try:
        ![gem update]
    except:
        handle_error("Ruby Gems", "update failed")

if which('cargo'):
    print("Updating Cargo packages...")
    try:
        ![cargo install-update -a]
    except:
        handle_error("Cargo", "update failed")

# Container and Virtualization
if which('docker'):
    print("Updating Docker images...")
    try:
        for line in $(docker images).split('\n')[1:]:
            if line:
                image = line.split()[0]
                ![docker pull @(image)]
    except:
        handle_error("Docker", "update failed")

if which('podman'):
    print("Updating Podman images...")
    try:
        for line in $(podman images).split('\n')[1:]:
            if line:
                image = line.split()[0]
                ![podman pull @(image)]
    except:
        handle_error("Podman", "update failed")

print("All package updates completed!") 