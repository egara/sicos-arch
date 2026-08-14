# SicOS - CachyOS/Arch Linux Edition

A complete, opinionated Hyprland-based desktop environment for Arch Linux and derivatives (CachyOS). This repository provides an installation script of the [SicOS module available for NixOS](https://github.com/egara/nixos-config) in order to convert an existing Arch base system into SicOS.

## 🌟 Features

- **Hyprland Tiling WM**: Modern Wayland compositor with custom Lua configuration and smooth animations
- **Desktop Shell Options**: Choose interactively between **DankMaterialShell (DMS)** [Default] or **Waybar + SwayNC**
- **GTK Applications**: Migrated from Qt/KDE to GTK equivalents (Nautilus, Polkit-GNOME, Helvum, PipeWire `pw-play`)
- **Custom SDDM Theme**: Minimalist, terminal-inspired login screen with dynamic clock and power management
- **Walker App Launcher**: Fast application launcher integrated with dmenu-style search
- **Hyprlock Screen Saver**: Custom lock screen with profile picture and time display
- **Wlogout Menu**: Elegant shutdown/logout menu with blur animations
- **Elephant Menu System**: Advanced menu system for themes, wallpapers, and utilities

## 📦 Installation

### Prerequisites

- Arch Linux or CachyOS installation
- AUR helper (recommended: `paru` or `yay`)
- Root access (`sudo`)

### Setup Script

Clone this repository and run the setup script:

```bash
git clone https://github.com/egara/arch-sicos.git
cd arch-sicos
chmod +x setup-sicos-cachyos.sh
./setup-sicos-cachyos.sh
```

When launched, the script will prompt you to select your preferred desktop shell:
1. **DankMaterialShell (DMS)** (Default)
2. **Waybar + SwayNC**

You can also pass `--shell=dms` or `--shell=waybar` for automated installations:

```bash
./setup-sicos-cachyos.sh --shell=dms
```

The script will:

1. Install all required dependencies via AUR helper (including GTK components and selected shell)
2. Create necessary directory structures for configurations
3. Copy Hyprland, DMS / Waybar, and other configuration files to your home directory
4. Set up GTK/Qt themes and icons (Adwaita-dark/Kvantum)
5. Configure SDDM theme for login screen customization
6. Set up polkit-gnome agent symlink and fix environment paths
7. Install additional scripts and utilities (`start-shell.sh`, `theme-switcher.sh`, etc.)

## 🎮 Key Bindings

These are some of the most useful key binds needed to start.

| Shortcut | Action | Description |
|----------|--------|-------------|
| `Mod` | Walker | Open Walker launcher |
| `Mod + S` | SicOS Menu | Open the SicOS menu with custom tools |
| `Mod + E` | File Manager | Open Nautilus |
| `Mod + Y` | Terminal File Manager | Open Yazi |
| `Ctrl + Alt + T` | Terminal | Launch Kitty terminal |
| `Print` | Screenshot | Take a region screenshot with Satty editor |

You can find all the keybinds within the SicOS Menu (`Mod + S`).

## 🎨 Theming & Customization

SicOS supports full theming with Base16 color schemes and dark mode using 
Adwaita-dark and Kvantum for QT applications.

### Custom Configuration Files

You can override any default configuration:

| Component | Config File Path |
|-----------|------------------|
| Hyprland | `~/.config/hypr/hyprland.lua` |
| Shell Launcher | `~/.config/sicos/scripts/start-shell.sh` |
| Shell Choice | `~/.config/sicos/shell_choice` |
| Waybar | `~/.config/waybar/config.jsonc` and `~/.config/waybar/style.css` |
| DankMaterialShell | `~/.config/DankMaterialShell/settings.json` |

## 📁 Repository Structure

```
arch-sicos/
├── config-files/          # Core configuration files for Hyprland, Waybar, etc.
│   ├── hyprland.lua       # Main Hyprland compositor configuration (Lua)
│   ├── hyprlock.conf      # Lock screen settings and appearance
│   └── ...                 (waybar, swaync, wlogout configs)
├── scripts/               # Utility and automation scripts
│   ├── start-shell.sh          # Launcher for DMS or Waybar
│   ├── theme-switcher.sh       # Dynamic UI theme switcher
│   ├── welcome-animation.sh    # Boot animation script
│   ├── sicos-settings.sh       # Main menu launcher for utilities
│   ├── screensaver.sh          # Screensaver functionality
│   └── ...                     (various helper scripts)
├── sddm-theme/            # Custom SDDM login theme files (.qml, .desktop)
├── wallpapers/            # Desktop wallpaper assets (light/dark variants)
├── setup-sicos-cachyos.sh # Main installation script for Arch/CachyOS conversion
```

## 🚀 Quick Start Guide

1. **Install Dependencies**: Run the setup script to install all packages automatically.
2. **Start Hyprland**: Log out and select "Hyprland (UWSM)" from your display manager.
3. **Explore Features**: Use `Mod + S` to access the SicOS settings menu for wallpapers, themes, and utilities.

## 🛠️ Troubleshooting

- **Docker Access**: After setup, add your user to the docker group: `sudo usermod -aG docker $USER`, then log out/in.
- **Theme Issues**: If themes don't apply correctly, check that Qt5ct/Qt6ct and Kvantum are installed and configured properly.

## 📜 License

GNU v3 License - See LICENSE file for details.

## 👤 Credits

SicOS was originally developed by Eloy García Almadén as a NixOS module. This 
Arch/CachyOS edition is based on his configuration and adapted for non-Nix 
environments based on Arch Linux.
