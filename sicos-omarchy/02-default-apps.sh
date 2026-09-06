#!/usr/bin/env bash
# =============================================================================
# 02-default-apps.sh - Configuración de Aplicaciones por Defecto en Omarchy
# =============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
USER_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}"

echo "==> [2/4] Configurando aplicaciones por defecto..."

# 1. Establecer Kitty como emulador de terminal por defecto
echo " -> Configurando Kitty como terminal por defecto..."
if command -v omarchy-default-terminal >/dev/null 2>&1; then
    omarchy-default-terminal kitty || true
else
    mkdir -p "$USER_CONFIG"
    cat > "$USER_CONFIG/xdg-terminals.list" <<EOF
# Terminal emulator preference order for xdg-terminal-exec
kitty.desktop
EOF
fi

# 2. Establecer Firefox como navegador web por defecto
echo " -> Configurando Firefox como navegador web por defecto..."
if command -v xdg-settings >/dev/null 2>&1; then
    xdg-settings set default-web-browser firefox.desktop || true
fi

# 3. Aplicar asociaciones MIME personalizadas (mimeapps.list)
echo " -> Instalando asociaciones de archivo (mimeapps.list)..."
mkdir -p "$USER_CONFIG"
cp "$SCRIPT_DIR/config/mimeapps.list" "$USER_CONFIG/mimeapps.list"

# Actualizar base de datos de escritorio si existe el comando
if command -v update-desktop-database >/dev/null 2>&1; then
    update-desktop-database "$HOME/.local/share/applications" 2>/dev/null || true
fi

echo "==> Aplicaciones por defecto configuradas con éxito."
