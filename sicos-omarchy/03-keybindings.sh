#!/usr/bin/env bash
# =============================================================================
# 03-keybindings.sh - Instalación de Atajos de Teclado SicOS en Omarchy
# =============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HYPR_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/hypr"

echo "==> [3/4] Instalando atajos de teclado de SicOS en Omarchy..."

mkdir -p "$HYPR_CONFIG_DIR"

# Realizar backup si ya existe bindings.lua y difiere
if [[ -f "$HYPR_CONFIG_DIR/bindings.lua" ]]; then
    BACKUP_FILE="$HYPR_CONFIG_DIR/bindings.lua.backup.$(date +%s)"
    echo " -> Creando backup del archivo actual en $BACKUP_FILE"
    cp "$HYPR_CONFIG_DIR/bindings.lua" "$BACKUP_FILE"
fi

# Copiar nuevo bindings.lua
echo " -> Copiando bindings.lua a $HYPR_CONFIG_DIR/bindings.lua"
cp "$SCRIPT_DIR/config/bindings.lua" "$HYPR_CONFIG_DIR/bindings.lua"

# Recargar configuración de Hyprland si la sesión está activa
if command -v hyprctl >/dev/null 2>&1 && [[ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]]; then
    echo " -> Recargando configuración de Hyprland en caliente..."
    hyprctl reload || true
fi

echo "==> Atajos de teclado instalados y listos."
