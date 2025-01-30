#!/usr/bin/env xonsh

import os
import sys
import subprocess
from threading import Thread
import time

# Request sudo privileges upfront
print("Requesting administrator privileges...")
try:
    subprocess.run(['sudo', '-v'], check=True)
except subprocess.CalledProcessError:
    print("Failed to obtain administrator privileges. Exiting.", file=sys.stderr)
    sys.exit(1)

# Keep sudo timestamp updated in the background
def keep_sudo():
    while True:
        try:
            subprocess.run(['sudo', '-n', 'true'], check=False)
            time.sleep(60)
            os.kill(os.getpid(), 0)
        except:
            break

Thread(target=keep_sudo, daemon=True).start()

def handle_error(name, msg):
    print(f"Error updating {name}: {msg}", file=sys.stderr)

print("Starting package updates...")

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

# Update Snap packages
if which('snap'):
    print("Updating Snap packages...")
    try:
        ![sudo snap refresh]
    except:
        handle_error("Snap", "update failed")

# System Package Managers
if which('apt'):
    print("Updating APT packages...")
    try:
        ![sudo apt update]
        ![sudo apt upgrade -y]
        ![sudo apt autoremove -y]
    except:
        handle_error("APT", "update failed")
elif which('dnf'):
    print("Updating DNF packages...")
    try:
        ![sudo dnf upgrade --refresh -y]
    except:
        handle_error("DNF", "update failed")

# Programming Language Package Managers
if which('pip'):
    print("Updating PIP packages...")
    try:
        for pkg in $(pip list --outdated --format=freeze).split('\n'):
            if pkg:
                pkg_name = pkg.split('==')[0]
                ![pip install -U @(pkg_name)]
    except:
        handle_error("PIP", "update failed")

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

print("All package updates completed!") 