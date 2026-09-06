#!/usr/bin/env bash
# =============================================================================
# 03-keybindings.sh - Instalación de Atajos de Teclado SicOS en Omarchy
# =============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Detectar el usuario real y su directorio home (incluso si se ejecuta con sudo)
TARGET_USER="${SUDO_USER:-$USER}"
TARGET_HOME=$(getent passwd "$TARGET_USER" | cut -d: -f6)
TARGET_HOME="${TARGET_HOME:-$HOME}"
HYPR_CONFIG_DIR="$TARGET_HOME/.config/hypr"

echo "==> [3/4] Instalando atajos de teclado de SicOS en Omarchy..."
echo " -> Usuario destino: $TARGET_USER"
echo " -> Directorio destino: $HYPR_CONFIG_DIR"

mkdir -p "$HYPR_CONFIG_DIR"

# Realizar backup si ya existe bindings.lua
if [[ -f "$HYPR_CONFIG_DIR/bindings.lua" ]]; then
    BACKUP_FILE="$HYPR_CONFIG_DIR/bindings.lua.backup.$(date +%s)"
    echo " -> Creando copia de seguridad en $BACKUP_FILE"
    cp "$HYPR_CONFIG_DIR/bindings.lua" "$BACKUP_FILE"
fi

# Copiar nuevo bindings.lua
echo " -> Copiando $SCRIPT_DIR/config/bindings.lua -> $HYPR_CONFIG_DIR/bindings.lua"
cp "$SCRIPT_DIR/config/bindings.lua" "$HYPR_CONFIG_DIR/bindings.lua"

# Corregir permisos si se ejecutó con sudo
if [[ -n "${SUDO_USER:-}" ]]; then
    chown -R "$TARGET_USER:" "$HYPR_CONFIG_DIR/bindings.lua"
fi

# Recargar configuración de Hyprland si la sesión está activa
if command -v hyprctl >/dev/null 2>&1 && [[ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]]; then
    echo " -> Recargando configuración de Hyprland en caliente..."
    hyprctl reload || true
fi

echo "==> Atajos de teclado instalados exitosamente en: $HYPR_CONFIG_DIR/bindings.lua"
