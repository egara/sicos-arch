#!/usr/bin/env bash

# SicOS Setup Script for CachyOS / Arch Linux
# --------------------------------------------------
# This script migrates your NixOS SicOS configuration
# to a CachyOS/Arch Linux system.
#
# Author: Eloy García Almadén / Gemini CLI
# --------------------------------------------------

set -e

# --- Configuration ---
USER_HOME=$(eval echo "~$USER")
SICOS_CONF_DIR="$USER_HOME/.config/sicos"
HYPR_CONF_DIR="$USER_HOME/.config/hypr"
REPO_ROOT=$(pwd)

echo "   _____ _      ____   ____ "
echo "  / ___/(_)____/ __ \ / ___/"
echo "  \__ \/ / ___/ / / / \__ \ "
echo " ___/ / / /__/ /_/ / ___/ / "
echo "/____/_/\___/\____/ /____/  "
echo "    Setup for CachyOS       "
echo ""

# --- Command-line arguments & Shell Choice ---
SHELL_CHOICE=""

for arg in "$@"; do
    case $arg in
        --shell=waybar)
            SHELL_CHOICE="waybar"
            shift
            ;;
        --shell=dms|--shell=dank-material-shell)
            SHELL_CHOICE="dank-material-shell"
            shift
            ;;
    esac
done

if [ -z "$SHELL_CHOICE" ]; then
    echo "------------------------------------------"
    echo " Choose your preferred desktop bar/shell: "
    echo " 1) DankMaterialShell (DMS) [Default]"
    echo " 2) Waybar + SwayNC"
    echo "------------------------------------------"
    read -r -p "Enter choice [1/2, default: 1]: " user_choice
    case "$user_choice" in
        2)
            SHELL_CHOICE="waybar"
            ;;
        *)
            SHELL_CHOICE="dank-material-shell"
            ;;
    esac
fi

echo "Selected desktop shell option: $SHELL_CHOICE"
echo ""

# 1. Install Dependencies
echo "[1/7] Installing dependencies..."

# Check for AUR helper
if command -v paru >/dev/null 2>&1; then
    AUR_HELPER="paru"
elif command -v yay >/dev/null 2>&1; then
    AUR_HELPER="yay"
else
    echo "AUR helper not found. Installing paru first..."
    sudo pacman -S --needed base-devel git
    git clone https://aur.archlinux.org/paru.git /tmp/paru
    (cd /tmp/paru && makepkg -si --noconfirm)
    AUR_HELPER="paru"
fi

# Package list based on SicOS NixOS module (Migrated to GTK apps & DMS/Waybar options)
PACKAGES=(
    # Desktop Environment & Shells
    hyprland
    hypridle
    hyprlock
    waybar
    swaync
    dms-shell-hyprland
    quickshell
    cava
    matugen
    gnome-menus
    upower
    accountsservice
    wlogout
    walker
    elephant-all
    uwsm
    swww
    sqlite
    # File Manager & GTK Tools (Migrated from Thunar to Nautilus)
    kitty
    nautilus
    file-roller
    gvfs
    tumbler
    brightnessctl
    pamixer
    playerctl
    network-manager-applet
    blueman
    polkit-gnome
    udiskie
    hyprshot
    satty
    fastfetch
    jq
    libnotify
    curl
    pavucontrol
    wl-clipboard
    grim
    slurp
    chromium
    papers
    yay
    yadm
    ripgrep
    fd
    # GTK Themes, Icons & Cursors
    papirus-icon-theme
    adw-gtk-theme
    bibata-cursor-theme
    gnome-themes-extra
    # QT/KDE Theming (Definitive Arch fix using Kvantum)
    qt5ct
    qt6ct
    kvantum
    kvantum-qt5
    breeze breeze-icons
    # Fonts
    ttf-jetbrains-mono-nerd
    noto-fonts
    noto-fonts-emoji
    noto-fonts-cjk
    nerd-fonts
    # Audio (Helvum replacing Carla; PipeWire replacing VLC for pop sound)
    helvum
    calf
    jack_mixer
    audacity
    qmmp
    mixxx
    spotify
    pipewire
    pipewire-jack
    # AI
    opencode
    antigravity-cli
    lmstudio-bin
    # K8s
    kubectl
    kubie
    # Other
    terminaltexteffects-git
    libqalculate
    socat
    libinput
    yad
    bc
    imagemagick
    telegram-desktop
    insync
    yazi
    zed
    lazyssh-bin
    buttermanager
    wallpaperdownloader
    cheatsheet-git
    libreoffice-fresh
    unarchiver
    7zip
    keepassxc
    # Docker
    docker docker-compose docker-buildx
    # SDDM Theme dependencies
    qt6-declarative qt6-svg qt6-5compat
)

echo "Updating sources and installing packages with $AUR_HELPER..."
sudo pacman -Syu
$AUR_HELPER -S --needed --noconfirm "${PACKAGES[@]}"

# 2. Prepare Directory Structure
echo "[2/7] Preparing directory structure..."
mkdir -p "$HYPR_CONF_DIR"
mkdir -p "$USER_HOME/.config/waybar"
mkdir -p "$USER_HOME/.config/swaync"
mkdir -p "$USER_HOME/.config/walker"
mkdir -p "$USER_HOME/.config/zed"
mkdir -p "$USER_HOME/.config/wlogout/icons"
mkdir -p "$USER_HOME/.config/elephant"
mkdir -p "$USER_HOME/.config/kitty"
mkdir -p "$USER_HOME/.config/gtk-3.0"
mkdir -p "$USER_HOME/.config/gtk-4.0"
mkdir -p "$USER_HOME/.config/qt5ct"
mkdir -p "$USER_HOME/.config/qt6ct"
mkdir -p "$USER_HOME/.config/Kvantum"
mkdir -p "$USER_HOME/.config/qmmp"
mkdir -p "$USER_HOME/.config/DankMaterialShell"
mkdir -p "$USER_HOME/.local/state/DankMaterialShell"
mkdir -p "$SICOS_CONF_DIR/scripts"
mkdir -p "$SICOS_CONF_DIR/wallpapers"
mkdir -p "$SICOS_CONF_DIR/themes"
mkdir -p "$SICOS_CONF_DIR/screensaver"

# Save chosen shell preference
echo "$SHELL_CHOICE" > "$SICOS_CONF_DIR/shell_choice"

# 3. Copy Configuration Files
echo "[3/7] Copying configuration files..."

# Hyprland & core configs
cp "$REPO_ROOT/config-files/hyprland.lua" "$HYPR_CONF_DIR/"
cp "$REPO_ROOT/config-files/hyprlock.conf" "$HYPR_CONF_DIR/"
cp "$REPO_ROOT/config-files/hypridle.conf" "$HYPR_CONF_DIR/"
cp "$REPO_ROOT/config-files/pop-sound.mp3" "$HYPR_CONF_DIR/"
cp "$REPO_ROOT/config-files/user.jpg" "$HYPR_CONF_DIR/"

# Kitty
if [ -d "$REPO_ROOT/config-files/kitty" ]; then
    cp -r "$REPO_ROOT/config-files/kitty/"* "$USER_HOME/.config/kitty/"
fi

# Waybar
cp "$REPO_ROOT/config-files/waybar/"* "$USER_HOME/.config/waybar/"

# SwayNC
cp "$REPO_ROOT/config-files/swaync/"* "$USER_HOME/.config/swaync/"

# Walker
cp -r "$REPO_ROOT/config-files/walker/"* "$USER_HOME/.config/walker/"

# Wlogout
cp "$REPO_ROOT/config-files/wlogout/layout" "$USER_HOME/.config/wlogout/"
cp "$REPO_ROOT/config-files/wlogout/style.css" "$USER_HOME/.config/wlogout/"
cp "$REPO_ROOT/config-files/wlogout/icons/"* "$USER_HOME/.config/wlogout/icons/"

# Elephant
cp -r "$REPO_ROOT/config-files/elephant/"* "$USER_HOME/.config/elephant/"

# Zed editor
cp -r "$REPO_ROOT/config-files/zed/"* "$USER_HOME/.config/zed/"

# Qmmp
cp -r "$REPO_ROOT/config-files/qmmp/"* "$USER_HOME/.config/qmmp/"

# mimeapps list
cp -r "$REPO_ROOT/config-files/mimeapps.list"* "$USER_HOME/.config/mimeapps.list"

# Yazi
ya pkg add jaam8/wise-enter || true
ya pkg add yazi-rs/plugins:mount || true

cp -r "$REPO_ROOT/config-files/yazi/"* "$USER_HOME/.config/yazi/"

# Scripts
cp "$REPO_ROOT/scripts/"* "$SICOS_CONF_DIR/scripts/"

# 4. Supplemental Assets
echo "[4/7] Supplementing missing assets..."
cp -r "$REPO_ROOT/wallpapers/"* "$SICOS_CONF_DIR/wallpapers/"
cp -r "$REPO_ROOT/screensaver/"* "$SICOS_CONF_DIR/screensaver/"

# SDDM Theme Installation
echo "Installing SDDM theme..."
sudo mkdir -p /usr/share/sddm/themes/sicos
sudo cp "$REPO_ROOT/sddm-theme/metadata.desktop" /usr/share/sddm/themes/sicos/
sudo cp "$REPO_ROOT/sddm-theme/theme.conf" /usr/share/sddm/themes/sicos/
# Select Main.qml based on theme preference
sudo cp "$REPO_ROOT/sddm-theme/Main-dark.qml" /usr/share/sddm/themes/sicos/Main.qml

# Configure SDDM to use the theme
echo "Configuring SDDM..."
sudo mkdir -p /etc/sddm.conf.d
sudo bash -c "cat << 'EOF' > /etc/sddm.conf.d/sicos.conf
[Theme]
Current=sicos
EOF"

# Clear SDDM cache
echo "Cleaning SDDM cache..."
sudo rm -rf /var/lib/sddm/.cache

# 5. Fix Paths, Executability and Commands
echo "[5/7] Customizing configurations for the new environment..."

# Replace hardcoded home paths /home/egarcia with current $HOME
echo "Fixing hardcoded home paths..."
find "$USER_HOME/.config" -type f -not -path '*/.*' -exec sed -i "s|/home/egarcia|$USER_HOME|g" {} +

# Polkit agent symlink for PATH availability
echo "Creating polkit-gnome agent symlink..."
sudo ln -sf /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 /usr/bin/polkit-gnome-authentication-agent-1

# Handle awww vs swww
echo "Aliasing awww to swww for compatibility..."
sudo ln -sf /usr/bin/awww /usr/bin/swww
sudo ln -sf /usr/bin/awww-daemon /usr/bin/swww-daemon

# Set GTK themes
echo "Setting GTK themes..."
cat << 'EOF' > "$USER_HOME/.config/gtk-3.0/settings.ini"
[Settings]
gtk-application-prefer-dark-theme=true
gtk-cursor-theme-name=Bibata-Modern-Classic
gtk-cursor-theme-size=24
gtk-font-name=JetBrainsMono Nerd Font Mono 10
gtk-icon-theme-name=Papirus-Dark
gtk-theme-name=adw-gtk3
EOF
cp "$USER_HOME/.config/gtk-3.0/settings.ini" "$USER_HOME/.config/gtk-4.0/settings.ini"

# Force Adwaita-dark in GTK4 via CSS import
cat << 'EOF' > "$USER_HOME/.config/gtk-4.0/gtk.css"
/**
 * GTK 4 reads the theme configured by gtk-theme-name, but ignores it.
 * It does however respect user CSS, so import the theme from here.
**/
@import url("file:///usr/share/themes/Adwaita-dark/gtk-4.0/gtk.css");
EOF

# Set QT themes (qt5ct and qt6ct using Kvantum)
echo "Setting QT themes (using Kvantum)..."
QT_CONF="[Appearance]
icon_theme=Papirus-Dark
style=kvantum
standard_dialogs=default
custom_palette=false"

echo "$QT_CONF" > "$USER_HOME/.config/qt5ct/qt5ct.conf"
echo "$QT_CONF" > "$USER_HOME/.config/qt6ct/qt6ct.conf"

# Set Kvantum theme to Dark
cat << 'EOF' > "$USER_HOME/.config/Kvantum/kvantum.kvconfig"
[General]
theme=KvFlatDark
EOF

# Force Dark Mode for KDE apps
echo "Configuring KDE apps dark mode (kdeglobals)..."
cat << 'EOF' > "$USER_HOME/.config/kdeglobals"
[General]
ColorScheme=BreezeDark
Name=Breeze Dark

[KDE]
lookAndFeelPackage=org.kde.breezedark.desktop

[Colors:Window]
BackgroundNormal=30,31,41
ForegroundNormal=205,214,244

[Colors:View]
BackgroundNormal=30,31,41
ForegroundNormal=205,214,244

[Icons]
Theme=Papirus-Dark
EOF

# Also set via gsettings for apps that use it
if command -v gsettings >/dev/null 2>&1; then
    gsettings set org.gnome.desktop.interface gtk-theme "adw-gtk3" || true
    gsettings set org.gnome.desktop.interface icon-theme "Papirus-Dark" || true
    gsettings set org.gnome.desktop.interface cursor-theme "Bibata-Modern-Classic" || true
    gsettings set org.gnome.desktop.interface cursor-size 24 || true
    gsettings set org.gnome.desktop.interface font-name "JetBrainsMono Nerd Font Mono 10" || true
    gsettings set org.gnome.desktop.interface color-scheme "prefer-dark" || true
fi

# Set Environment Variables for session
echo "Setting environment variables..."
sudo mkdir -p /etc/environment.d
sudo bash -c "cat << 'EOF' > /etc/environment.d/99-sicos.conf
QT_QPA_PLATFORMTHEME=qt6ct
QT_STYLE_OVERRIDE=kvantum
XCURSOR_THEME=Bibata-Modern-Classic
XCURSOR_SIZE=24
EOF"

# Install Insync integration script to /usr/bin
echo "Installing Insync integration script to /usr/bin..."
sudo cp "$REPO_ROOT/scripts/insync-integration.sh" /usr/bin/insync-integration.sh
sudo chmod +x /usr/bin/insync-integration.sh

# Replace NixOS-specific update/clean scripts with Arch versions
echo "Replacing NixOS maintenance scripts with Arch versions..."
cat << 'EOF' > "$SICOS_CONF_DIR/scripts/nixos-update.sh"
#!/usr/bin/env bash
echo "Updating Arch Linux system (paru -Syu)..."
paru -Syu
EOF

cat << 'EOF' > "$SICOS_CONF_DIR/scripts/nixos-clean.sh"
#!/usr/bin/env bash
echo "Cleaning package cache..."
sudo pacman -Sc --noconfirm
paru -Sc --noconfirm
echo "Cleaning journals..."
sudo journalctl --vacuum-time=2d
EOF

# 6. Set Permissions
echo "[6/7] Setting executable permissions on scripts..."
chmod +x "$SICOS_CONF_DIR/scripts/"*.sh

# 7. Final Setup & Services
echo "[7/7] Finalizing services..."

# Enable system services
sudo systemctl enable --now upower.service || true
sudo systemctl enable --now accounts-daemon.service || true

# Enable Docker
echo "Configuring Docker..."
sudo systemctl enable --now docker.socket || true
sudo usermod -aG docker "$USER" || true

# Enable hypridle service
systemctl --user enable --now hypridle.service || true

# Enable DMS user service if selected
if [ "$SHELL_CHOICE" = "dank-material-shell" ]; then
    echo "Enabling DankMaterialShell user service..."
    systemctl --user enable dms.service || true
fi

# Enable SDDM service
echo "Enabling SDDM..."
sudo systemctl enable sddm || true

# Initial wallpaper daemon start
swww-daemon & sleep 1
swww img "$SICOS_CONF_DIR/wallpapers/sicos-dark.jpg" || true

echo ""
echo "--------------------------------------------------"
echo " SicOS Setup Complete!"
echo " Selected Shell: $SHELL_CHOICE"
echo "--------------------------------------------------"
echo " To start SicOS:"
echo " 1. Logout and select Hyprland (UWSM) in your DM."
echo " 2. Or run: uwsm start hyprland-uwsm.desktop"
echo "--------------------------------------------------"
