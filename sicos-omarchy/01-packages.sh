#!/usr/bin/env bash
# =============================================================================
# 01-packages.sh - Gestión de Paquetes para SicOS en Omarchy
# =============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> [1/4] Gestionando paquetes del sistema..."

# Paquetes de Omarchy a desinstalar (reemplazados por tus herramientas de SicOS)
OMARCHY_DROP_PKGS=(
    foot
    evince
    imv
    pinta
    xournalpp
    cliamp
    tobi-try
)

# Paquetes esenciales de SicOS a instalar
SICOS_INSTALL_PKGS=(
    # Terminal y Editores
    kitty
    zed
    
    # Navegadores
    firefox
    google-chrome
    
    # Gestor de archivos y CLI
    yazi
    unar
    
    # Multimedia
    qmmp
    vlc
    papers
    feh
    
    # Capturas y herramientas Wayland
    hyprshot
    satty
    pamixer
    brightnessctl
    playerctl
    
    # Productividad / Herramientas
    lazyssh-bin
    fastfetch
    yadm
    ansible
    udiskie
    insync
    buttermanager
    wallpaperdownloader
    
    # Asistentes IA
    opencode
    antigravity-cli
)

# Función para desinstalar paquetes usando omarchy-pkg-drop si existe, o pacman/aur
drop_package() {
    local pkg="$1"
    if pacman -Qq "$pkg" >/dev/null 2>&1; then
        echo " -> Eliminando paquete prescindible: $pkg"
        if command -v omarchy-pkg-drop >/dev/null 2>&1; then
            omarchy-pkg-drop "$pkg" || true
        else
            sudo pacman -Rns --noconfirm "$pkg" || true
        fi
    else
        echo " -> Paquete no instalado, omitiendo: $pkg"
    fi
}

# Función para instalar paquetes usando omarchy-pkg-add, paru o yay
add_packages() {
    local pkgs=("$@")
    echo " -> Instalando paquetes requeridos de SicOS..."
    if command -v omarchy-pkg-add >/dev/null 2>&1; then
        omarchy-pkg-add "${pkgs[@]}"
    elif command -v yay >/dev/null 2>&1; then
        yay -S --needed --noconfirm "${pkgs[@]}"
    elif command -v paru >/dev/null 2>&1; then
        paru -S --needed --noconfirm "${pkgs[@]}"
    else
        echo "Error: No se encontró ni omarchy-pkg-add ni un AUR helper (yay/paru)."
        exit 1
    fi
}

# 1. Desinstalar paquetes no deseados
echo "--- Desinstalando aplicaciones innecesarias de Omarchy ---"
for pkg in "${OMARCHY_DROP_PKGS[@]}"; do
    drop_package "$pkg"
done

# 2. Instalar paquetes de SicOS
echo "--- Instalando aplicaciones habituales de SicOS ---"
add_packages "${SICOS_INSTALL_PKGS[@]}"

echo "==> Gestión de paquetes completada con éxito."
