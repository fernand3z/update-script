#!/usr/bin/env fish

# Request sudo privileges upfront
echo "Requesting administrator privileges..."
if not sudo -v
    echo "Failed to obtain administrator privileges. Exiting." >&2
    exit 1
end

# Keep sudo timestamp updated in the background
begin
    while true
        sudo -n true
        sleep 60
        if not kill -0 %self
            exit
        end
    end
end &>/dev/null &

function handle_error
    echo "Error updating $argv[1]: $argv[2]" >&2
end

echo "Starting package updates..."

# System Package Managers (requiring sudo)
if type -q apt
    echo "Updating APT packages..."
    if not begin
        sudo apt update
        and sudo apt upgrade -y
        and sudo apt autoremove -y
    end
        handle_error "APT" "update failed"
    end
else if type -q dpkg
    echo "Updating DPKG packages..."
    if not sudo dpkg --configure -a
        handle_error "DPKG" "configuration failed"
    end
else if type -q dnf
    echo "Updating DNF packages..."
    if not sudo dnf upgrade --refresh -y
        handle_error "DNF" "update failed"
    end
else if type -q yum
    echo "Updating YUM packages..."
    if not sudo yum update -y
        handle_error "YUM" "update failed"
    end
else if type -q pacman
    echo "Updating Pacman packages..."
    if not sudo pacman -Syu --noconfirm
        handle_error "Pacman" "update failed"
    end
else if type -q zypper
    echo "Updating Zypper packages..."
    if not begin
        sudo zypper refresh
        and sudo zypper update -y
    end
        handle_error "Zypper" "update failed"
    end
else if type -q emerge
    echo "Updating Portage packages..."
    if not begin
        sudo emerge --sync
        and sudo emerge -uDN @world
    end
        handle_error "Portage" "update failed"
    end
else if type -q xbps-install
    echo "Updating XBPS packages..."
    if not sudo xbps-install -Su
        handle_error "XBPS" "update failed"
    end
else if type -q apk
    echo "Updating APK packages..."
    if not begin
        sudo apk update
        and sudo apk upgrade
    end
        handle_error "APK" "update failed"
    end
else if type -q pkgtool
    echo "Updating Slackware packages..."
    if not begin
        sudo slackpkg update
        and sudo slackpkg upgrade-all
    end
        handle_error "Slackware" "update failed"
    end
end

# Update Snap packages (requires sudo)
if type -q snap
    echo "Updating Snap packages..."
    if not sudo snap refresh
        handle_error "Snap" "update failed"
    end
end

# Update and upgrade Homebrew
if type -q brew
    echo "Updating Homebrew..."
    if not begin
        brew update
        and brew upgrade
        and brew cleanup
    end
        handle_error "Homebrew" "update failed"
    end
end

# Update Flatpak packages
if type -q flatpak
    echo "Updating Flatpak..."
    if not flatpak update -y
        handle_error "Flatpak" "update failed"
    end
end

# Update Nix packages
if type -q nix-env
    echo "Updating Nix..."
    if not begin
        nix-channel --update
        and nix-env -u
        and nix-collect-garbage -d
    end
        handle_error "Nix" "update failed"
    end
end

# Programming Language Package Managers
if type -q npm
    echo "Updating NPM packages..."
    if not npm update -g
        handle_error "NPM" "update failed"
    end
end

if type -q pip
    echo "Updating PIP packages..."
    if not pip list --outdated --format=freeze | string replace -r '^\-e' '' | string split -f 1 = | xargs -n1 pip install -U
        handle_error "PIP" "update failed"
    end
end

if type -q gem
    echo "Updating Ruby gems..."
    if not gem update
        handle_error "Ruby Gems" "update failed"
    end
end

if type -q cargo
    echo "Updating Cargo packages..."
    if not cargo install-update -a
        handle_error "Cargo" "update failed"
    end
end

# Container and Virtualization
if type -q docker
    echo "Updating Docker images..."
    docker images | string match -rv REPOSITORY | string split -f 1 ' ' | while read -l image
        if not docker pull $image
            handle_error "Docker" "failed to update $image"
        end
    end
end

if type -q podman
    echo "Updating Podman images..."
    podman images | string match -rv REPOSITORY | string split -f 1 ' ' | while read -l image
        if not podman pull $image
            handle_error "Podman" "failed to update $image"
        end
    end
end

echo "All package updates completed!"
