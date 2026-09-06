#!/usr/bin/env bash
# =============================================================================
# 04-dotfiles-sync.sh - Sincronización de Dotfiles de Aplicaciones SicOS
# =============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Detectar el usuario real y su home
TARGET_USER="${SUDO_USER:-$USER}"
TARGET_HOME=$(getent passwd "$TARGET_USER" | cut -d: -f6)
TARGET_HOME="${TARGET_HOME:-$HOME}"
USER_CONFIG="$TARGET_HOME/.config"

echo "==> [4/4] Sincronizando dotfiles de aplicaciones en $USER_CONFIG..."

# 1. Kitty
echo " -> Sincronizando Kitty en $USER_CONFIG/kitty..."
mkdir -p "$USER_CONFIG/kitty"
cp -r "$SCRIPT_DIR/config/kitty/"* "$USER_CONFIG/kitty/"

# 2. Zed Editor
echo " -> Sincronizando Zed en $USER_CONFIG/zed..."
mkdir -p "$USER_CONFIG/zed"
cp -r "$SCRIPT_DIR/config/zed/"* "$USER_CONFIG/zed/"

# 3. Yazi
echo " -> Sincronizando Yazi en $USER_CONFIG/yazi..."
mkdir -p "$USER_CONFIG/yazi"
cp -r "$SCRIPT_DIR/config/yazi/"* "$USER_CONFIG/yazi/"

# Instalar plugins de Yazi como el usuario destino
if command -v ya >/dev/null 2>&1; then
    echo " -> Añadiendo plugins de Yazi..."
    sudo -u "$TARGET_USER" ya pkg add yazi-rs/plugins:mount 2>/dev/null || true
    sudo -u "$TARGET_USER" ya pkg add jaam8/wise-enter.yazi 2>/dev/null || sudo -u "$TARGET_USER" ya pkg add yazi-rs/plugins:smart-enter 2>/dev/null || true
fi

# 4. QMMP (Configuración y Skin Winamp Classic)
echo " -> Sincronizando QMMP en $USER_CONFIG/qmmp..."
mkdir -p "$USER_CONFIG/qmmp/skins"
cp -r "$SCRIPT_DIR/config/qmmp/"* "$USER_CONFIG/qmmp/"

# Corregir propietarios si se ejecutó con sudo
if [[ -n "${SUDO_USER:-}" ]]; then
    chown -R "$TARGET_USER:" "$USER_CONFIG/kitty" "$USER_CONFIG/zed" "$USER_CONFIG/yazi" "$USER_CONFIG/qmmp"
fi

echo "==> Sincronización de dotfiles completada."
