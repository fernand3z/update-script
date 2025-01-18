# Update Script

This repository provides a simple script to update packages across multiple package managers, tailored for different shell environments. The script supports the following shells:

- **Zsh**
- **Bash**
- **Fish**
- **NuShell**

The installation process automatically detects your shell and sets up the appropriate script.

---

## Features

- Updates and cleans up popular package managers like:
  - **Homebrew**
  - **Flatpak**
  - **Nix**
  - **Paru**
  - **Yay**
  - System package managers (**apt**, **dnf**, or **pacman**).
- Automatically installs the script relevant to your shell.
- Lightweight and easy to set up.

---

## Installation Guide

### Step 1: Clone the Repository

Clone the repository into your system:

```bash
git clone https://github.com/fernand3z/update-script.git
cd update-script
```

### Step 2: Run the Installation Script

The installation script detects your shell and installs the corresponding update script:

```bash
./install.sh
```

- The appropriate script will be copied to `~/scripts/update_packages`.
- If your shell is not detected automatically, you can manually choose the desired script from the `scripts/` folder.

### Step 3: Add Alias to Your Shell Configuration

Add an alias to your shell's configuration file for convenient access.

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

Save and reload your shell configuration. For example, in Zsh:

```bash
source ~/.zshrc
```

### Step 4: Run the Script

Use the `upgrade` command to update your packages:

```bash
upgrade
```

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

Feel free to fork the repository and submit a pull request with any improvements or additional features.

---

## License

This project is licensed under the [MIT License](LICENSE).

