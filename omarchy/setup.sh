#!/usr/bin/env bash
# =============================================================================
# setup.sh - Orquestador Principal de SicOS en Omarchy
# =============================================================================
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "   _____ _      ____   ____ "
echo "  / ___/(_)____/ __ \ / ___/"
echo "  \__ \/ / ___/ / / / \__ \ "
echo " ___/ / / /__/ /_/ / ___/ / "
echo "/____/_/\___/\____/ /____/  "
echo "    Omarchy Customizer      "
echo ""

# Comprobación básica de entorno
if ! command -v hyprctl >/dev/null 2>&1 && ! command -v omarchy >/dev/null 2>&1; then
    echo "Aviso: No parece que estés en un entorno Hyprland / Omarchy activo."
    read -r -p "¿Deseas continuar de todos modos? [s/N]: " resp
    if [[ ! "$resp" =~ ^[sSyY]$ ]]; then
        echo "Operación cancelada."
        exit 0
    fi
fi

# 1. Paquetes
bash "$SCRIPT_DIR/01-packages.sh" || true

# 2. Aplicaciones por defecto
bash "$SCRIPT_DIR/02-default-apps.sh" || true

# 3. Atajos de teclado
bash "$SCRIPT_DIR/03-keybindings.sh" || true

# 4. Sincronización de Dotfiles
bash "$SCRIPT_DIR/04-dotfiles-sync.sh" || true

echo ""
echo "=================================================="
echo " ✅ ¡Personalización de SicOS en Omarchy completada!"
echo "=================================================="
echo " - Terminal por defecto: Kitty"
echo " - Navegador por defecto: Firefox"
echo " - Atajos de teclado migrados en ~/.config/hypr/bindings.lua"
echo " - Pulsa 'SUPER + K' dentro de Omarchy para ver el cheatsheet"
echo "=================================================="
