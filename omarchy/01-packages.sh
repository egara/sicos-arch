#!/usr/bin/env bash
# =============================================================================
# 01-packages.sh - Gestión de Paquetes para SicOS en Omarchy
# =============================================================================
set -uo pipefail

echo "==> [1/4] Gestionando paquetes del sistema..."

# 1. Detectar Helper de AUR (Omarchy trae yay instalado)
if command -v yay >/dev/null 2>&1; then
    AUR_HELPER="yay"
elif command -v paru >/dev/null 2>&1; then
    AUR_HELPER="paru"
else
    echo " -> AUR helper no encontrado. Instalando yay..."
    sudo pacman -S --needed --noconfirm base-devel git
    git clone https://aur.archlinux.org/yay.git /tmp/yay-build
    (cd /tmp/yay-build && makepkg -si --noconfirm)
    rm -rf /tmp/yay-build
    AUR_HELPER="yay"
fi

echo " -> Utilizando gestor AUR: $AUR_HELPER"

# 2. Paquetes de Omarchy a desinstalar
OMARCHY_DROP_PKGS=(
    foot
    evince
    imv
    pinta
    xournalpp
    cliamp
    tobi-try
)

# 3. Paquetes Oficiales de Arch Linux (Repositorios Oficiales)
OFFICIAL_PKGS=(
    kitty
    firefox
    yazi
    unar
    qmmp
    vlc
    papers
    feh
    satty
    pamixer
    brightnessctl
    playerctl
    fastfetch
    yadm
    ansible
    udiskie
)

# 4. Paquetes de AUR
AUR_PKGS=(
    google-chrome
    zed
    hyprshot
    lazyssh-bin
    insync
    buttermanager
    wallpaperdownloader
    opencode
    antigravity-cli
)

# Función para desinstalar paquetes de forma segura
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

# --- Paso 1: Desinstalar paquetes no deseados ---
echo "--- Desinstalando aplicaciones innecesarias de Omarchy ---"
for pkg in "${OMARCHY_DROP_PKGS[@]}"; do
    drop_package "$pkg"
done

# --- Paso 2: Instalar paquetes de repositorios oficiales con pacman ---
echo "--- Instalando paquetes oficiales de Arch con pacman ---"
sudo pacman -S --needed --noconfirm "${OFFICIAL_PKGS[@]}" || {
    echo "Aviso: Algunos paquetes oficiales fallaron al instalarse en lote. Probando uno a uno..."
    for pkg in "${OFFICIAL_PKGS[@]}"; do
        sudo pacman -S --needed --noconfirm "$pkg" || echo " ⚠️  No se pudo instalar $pkg"
    done
}

# --- Paso 3: Instalar paquetes de AUR con yay/paru ---
echo "--- Instalando paquetes desde AUR con $AUR_HELPER ---"
for pkg in "${AUR_PKGS[@]}"; do
    echo " -> Procesando AUR: $pkg"
    $AUR_HELPER -S --needed --noconfirm "$pkg" || {
        echo " ⚠️  Advertencia: Falló la instalación de AUR para '$pkg'. Intentando alternativas si existen..."
        case "$pkg" in
            zed)
                $AUR_HELPER -S --needed --noconfirm zed-preview-bin || $AUR_HELPER -S --needed --noconfirm zeditor || true
                ;;
            opencode)
                $AUR_HELPER -S --needed --noconfirm opencode-bin || true
                ;;
            *)
                echo " ❌ No se pudo instalar el paquete AUR: $pkg"
                ;;
        esac
    }
done

echo "==> Gestión de paquetes completada."
