#!/usr/bin/env bash
# =============================================================================
# 04-dotfiles-sync.sh - Sincronización de Dotfiles de Aplicaciones SicOS
# =============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
USER_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}"

echo "==> [4/4] Sincronizando dotfiles de aplicaciones (Kitty, Zed, Yazi, QMMP)..."

# 1. Kitty
echo " -> Sincronizando configuración de Kitty..."
mkdir -p "$USER_CONFIG/kitty"
cp -r "$SCRIPT_DIR/config/kitty/"* "$USER_CONFIG/kitty/"

# 2. Zed Editor
echo " -> Sincronizando configuración de Zed..."
mkdir -p "$USER_CONFIG/zed"
cp -r "$SCRIPT_DIR/config/zed/"* "$USER_CONFIG/zed/"

# 3. Yazi
echo " -> Sincronizando configuración y plugins de Yazi..."
mkdir -p "$USER_CONFIG/yazi"
cp -r "$SCRIPT_DIR/config/yazi/"* "$USER_CONFIG/yazi/"

# Instalar plugins de Yazi si el gestor de paquetes de Yazi (ya) está disponible
if command -v ya >/dev/null 2>&1; then
    echo " -> Añadiendo plugins de Yazi (smart-enter / mount)..."
    ya pkg add yazi-rs/plugins:mount || true
    ya pkg add jaam8/wise-enter.yazi || ya pkg add yazi-rs/plugins:smart-enter || true
fi

# 4. QMMP (Configuración y Skin Winamp Classic)
echo " -> Sincronizando configuración y skins de QMMP..."
mkdir -p "$USER_CONFIG/qmmp/skins"
cp -r "$SCRIPT_DIR/config/qmmp/"* "$USER_CONFIG/qmmp/"

echo "==> Sincronización de dotfiles completada."
