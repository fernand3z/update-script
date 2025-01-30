#!/usr/bin/env nu
# vim: syntax=sh
# -*- mode: sh -*-

def handle_error [name: string, msg: string] {
    echo $"Error updating ($name): ($msg)"
}

echo "Starting package updates..."

# System Package Managers (requiring sudo)
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
} else if (which emerge | is-empty) == false {
    echo "Updating Portage packages..."
    try { 
        sudo emerge --sync
        sudo emerge -uDN @world
    } catch { 
        handle_error "Portage" $error.msg
    }
} else if (which xbps-install | is-empty) == false {
    echo "Updating XBPS packages..."
    try { 
        sudo xbps-install -Su
    } catch { 
        handle_error "XBPS" $error.msg
    }
} else if (which apk | is-empty) == false {
    echo "Updating APK packages..."
    try { 
        sudo apk update
        sudo apk upgrade
    } catch { 
        handle_error "APK" $error.msg
    }
} else if (which pkgtool | is-empty) == false {
    echo "Updating Slackware packages..."
    try { 
        sudo slackpkg update
        sudo slackpkg upgrade-all
    } catch { 
        handle_error "Slackware" $error.msg
    }
}

# Update Snap packages (requires sudo)
if (which snap | is-empty) == false {
    echo "Updating Snap packages..."
    try { 
        sudo snap refresh
    } catch { 
        handle_error "Snap" $error.msg
    }
}

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
}

# Update Flatpak packages
if (which flatpak | is-empty) == false {
    echo "Updating Flatpak..."
    try { 
        flatpak update -y
    } catch { 
        handle_error "Flatpak" $error.msg
    }
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

if (which yarn | is-empty) == false {
    echo "Updating Yarn packages..."
    try { 
        yarn global upgrade
    } catch { 
        handle_error "Yarn" $error.msg
    }
}

if (which pnpm | is-empty) == false {
    echo "Updating PNPM packages..."
    try { 
        pnpm update -g
    } catch { 
        handle_error "PNPM" $error.msg
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
