#!/bin/csh -f

# Error handling function
alias handle_error 'echo "Error updating $1: $2" > /dev/stderr'

echo "Starting package updates..."

# Update and upgrade Homebrew
which brew > /dev/null
if ($status == 0) then
    echo "Updating Homebrew..."
    brew update && brew upgrade && brew cleanup
    if ($status) then
        handle_error "Homebrew" "update failed"
    endif
endif

# Update Flatpak packages
which flatpak > /dev/null
if ($status == 0) then
    echo "Updating Flatpak..."
    flatpak update -y
    if ($status) then
        handle_error "Flatpak" "update failed"
    endif
endif

# Update Snap packages
which snap > /dev/null
if ($status == 0) then
    echo "Updating Snap packages..."
    sudo snap refresh
    if ($status) then
        handle_error "Snap" "update failed"
    endif
endif

# Update Nix packages
which nix-env > /dev/null
if ($status == 0) then
    echo "Updating Nix..."
    nix-channel --update && nix-env -u && nix-collect-garbage -d
    if ($status) then
        handle_error "Nix" "update failed"
    endif
endif

# System Package Managers
which apt > /dev/null
if ($status == 0) then
    echo "Updating APT packages..."
    sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y
    if ($status) then
        handle_error "APT" "update failed"
    endif
else
    which dpkg > /dev/null
    if ($status == 0) then
        echo "Updating DPKG packages..."
        sudo dpkg --configure -a
        if ($status) then
            handle_error "DPKG" "configuration failed"
        endif
    else
        which dnf > /dev/null
        if ($status == 0) then
            echo "Updating DNF packages..."
            sudo dnf upgrade --refresh -y
            if ($status) then
                handle_error "DNF" "update failed"
            endif
        endif
    endif
endif

# Programming Language Package Managers
which npm > /dev/null
if ($status == 0) then
    echo "Updating NPM packages..."
    npm update -g
    if ($status) then
        handle_error "NPM" "update failed"
    endif
endif

which pip > /dev/null
if ($status == 0) then
    echo "Updating PIP packages..."
    pip list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1 | xargs -n1 pip install -U
    if ($status) then
        handle_error "PIP" "update failed"
    endif
endif

which gem > /dev/null
if ($status == 0) then
    echo "Updating Ruby gems..."
    gem update
    if ($status) then
        handle_error "Ruby Gems" "update failed"
    endif
endif

which cargo > /dev/null
if ($status == 0) then
    echo "Updating Cargo packages..."
    cargo install-update -a
    if ($status) then
        handle_error "Cargo" "update failed"
    endif
endif

# Container and Virtualization
which docker > /dev/null
if ($status == 0) then
    echo "Updating Docker images..."
    foreach image (`docker images | grep -v REPOSITORY | awk '{print $1}'`)
        docker pull $image
        if ($status) then
            handle_error "Docker" "failed to update $image"
        endif
    end
endif

which podman > /dev/null
if ($status == 0) then
    echo "Updating Podman images..."
    foreach image (`podman images | grep -v REPOSITORY | awk '{print $1}'`)
        podman pull $image
        if ($status) then
            handle_error "Podman" "failed to update $image"
        endif
    end
endif

echo "All package updates completed!" 