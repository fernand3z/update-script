# Universal Package Updater

The **Universal Package Updater** is a powerful, all-in-one script designed to automate updates across multiple package managers. Whether you're using **Homebrew**, **Flatpak**, **Nix**, **Paru**, **Yay**, or system-level package managers like **apt**, **dnf**, or **pacman**, this script ensures your system is up-to-date effortlessly.

## Why Use Universal Package Updater?
- **Cross-Shell Support**: Works seamlessly with Zsh, Bash, Fish, and NuShell.
- **Time-Saving**: Updates all supported package managers with a single command.
- **User-Friendly**: Easy to set up and use, even for beginners.
- **Customizable**: Tailored to detect your shell environment and install the relevant script.
- **Lightweight**: Minimal resource usage while handling essential updates.

---

## Key Features
- Updates popular package managers:
  - **Homebrew**: macOS and Linux users' go-to package manager.
  - **Flatpak**: Manage universal Linux apps.
  - **Nix**: For reproducible builds and package management.
  - **Paru** and **Yay**: Arch Linux AUR helpers.
  - System-level package managers: **apt**, **dnf**, **pacman**.
- Automatic cleanup after updates to free up disk space.
- Compatible with multiple shell environments.

---

## Installation Guide

### Step 1: Clone the Repository
Clone the repository into your system:

```bash
git clone https://github.com/fernand3z/update-script.git
cd update-script
```

### Step 2: Run the Installation Script
The installation script automatically detects your shell and installs the corresponding script:

`I.` Run the command to make `install.sh` executable.
```bash
chmod +x install.sh
```
`II.` Run the command to install
```bash
./install.sh
```

- The appropriate script will be copied to `~/scripts/update_packages`.
- If your shell is not detected, manually choose the script from the `scripts/` folder.

### Step 3: Add Alias to Your Shell Configuration
To simplify usage, add an alias to your shell configuration
(e.g., `nano ~/.zshrc` for Zsh):

#### For Zsh:
```zsh
alias upgrade="~/scripts/update_packages"
```

#### For Bash:
```bash
alias upgrade="~/scripts/update_packages"
```

#### For Fish:
```fish
alias upgrade="~/scripts/update_packages"
```

#### For NuShell:
```nu
alias upgrade = ~/scripts/update_packages
```

Save and reload your shell configuration (e.g., `source ~/.zshrc` for Zsh).

### Step 4: Run the Script
Use the `upgrade`command to update all your package managers effortlessly:

```bash
upgrade
```

---

##  Benefits

### **Automate Package Manager Updates with Ease**
The Universal Package Updater streamlines the process of keeping your tools and system updated. Say goodbye to manually running multiple commands for each package manager. Our script does the heavy lifting for you.

### **Supports Multiple Environments**
Whether you're a macOS, Linux, or Arch Linux user, this script has you covered. It’s perfect for developers, sysadmins, and tech enthusiasts.

### **Simplify System Maintenance**
No more forgetting to update a package manager. Keep your system clean and secure with built-in cleanup routines and regular updates.

### **Optimized for Developers**
Developers often juggle multiple environments and package managers. This script simplifies your workflow, ensuring all your tools are up-to-date with a single command.

---

## Folder Structure

```plaintext
update-script/
├── scripts/
│   ├── update_packages.zsh
│   ├── update_packages.fish
│   ├── update_packages.nu
│   ├── update_packages.sh
├── install.sh
└── README.md
```

---

## Contributing
Contributions are welcome! If you have ideas for improvements or want to add support for more package managers, feel free to fork the repository and submit a pull request.

---

## License
This project is licensed under the [MIT License](LICENSE).

---

- **Update Package Managers Automatically**
- **All-in-One Update Script**
- **Cross-Shell Package Manager Updater**
- **Automate System Updates**
- **Best Linux Package Updater**
- **Homebrew, Flatpak, Nix, APT, DNF Updates**
- **Effortless Software Updates**
- **Developer-Friendly Update Tool**
