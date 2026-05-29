# SicOS - CachyOS/Arch Linux Edition

A complete, opinionated Hyprland-based desktop environment for Arch Linux and derivatives (CachyOS). This repository provides a installation script of the [SicOS module available for NixOS](https://github.com/egara/nixos-config) in order to convert an existing Arch base system into SicOS. Due to some limitations, only certain features of the NixOS SicOS module have been implemented.

## 🌟 Features

- **Hyprland Tiling WM**: Modern Wayland compositor with stunning animations
- **Custom SDDM Theme**: Minimalist, terminal-inspired login screen with dynamic clock and power management
- **Waybar Status Bar**: Beautiful status bar showing workspaces, system stats, and media control
- **Walker App Launcher**: Fast application launcher integrated with dmenu-style search
- **SwayNC Notifications**: Modern notification center with blur effects
- **Hyprlock Screen Saver**: Custom lock screen with profile picture and time display
- **Wlogout Menu**: Elegant shutdown/logout menu with animations
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

The script will:

1. Install all required dependencies via AUR helper
2. Create necessary directory structures for configurations
3. Copy Hyprland, Waybar, and other configuration files to your home directory
4. Set up GTK/Qt themes and icons (Adwaita-dark/Kvantum)
5. Configure SDDM theme for login screen customization
6. Fix hardcoded paths from NixOS environment to Arch/CachyOS
7. Install additional scripts and utilities

## 🎮 Key Bindings

These are some of the most useful key binds needed to start.

| Shortcut | Action | Description |
|----------|--------|-------------|
| `Mod` | Walker | Open Walker launcher |
| `Mod + S` | SicOS Menu | Open the SicOS menu with some custom tools implemented |
| `Mod + E` | File Manager | Open Thunar |
| `Ctrl + Alt + T` | Terminal | Launch Kitty terminal |

You can find all the keybinds within the SicOS Menu.

## 🎨 Theming & Customization

SicOS supports full theming with Base16 color schemes and dark mode using 
Adwaita-dark and Kvantum for QT applications.

### Custom Configuration Files

You can override any default configuration. These are  examples of files that 
you can tweak and modify:

| Component | Config File Path |
|-----------|------------------|
| Hyprland | `~/.config/hypr/hyprland.conf` |
| Waybar | `~/.config/waybar/config.jsonc` and `~/.config/waybar/style.css` |

## 📁 Repository Structure

```
arch-sicos/
├── config-files/          # Core configuration files for Hyprland, Waybar, etc.
│   ├── hyprland.conf      # Main Hyprland compositor configuration
│   ├── hyprlock.conf      # Lock screen settings and appearance
│   └── ...                 (waybar, swaync, wlogout configs)
├── scripts/               # Utility and automation scripts
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
2. **Start Hyprland**: Log out and select "Hyprland" from your display manager.
3. **Explore Features**: Use `Mod + S` to access the SicOS settings menu for wallpapers, themes, and utilities.

## 🛠️ Troubleshooting

- **Docker Access**: After setup, add your user to the docker group: `sudo usermod -aG $USER docker`, then log out/in.
- **Theme Issues**: If themes don't apply correctly, check that Qt5ct/Qt6ct and Kvantum are installed and configured properly.

## 📜 License

GNU v3 License - See LICENSE file for details.

## 👤 Credits

SicOS was originally developed by Eloy García Almadén as a NixOS module. This 
Arch/CachyOS edition is based on his configuration and adapted for non-Nix 
environments based on Arch Linux.
