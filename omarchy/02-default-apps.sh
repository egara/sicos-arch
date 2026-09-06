#!/usr/bin/env bash
# =============================================================================
# 02-default-apps.sh - Configuración de Aplicaciones por Defecto en Omarchy
# =============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Detectar el usuario real y su home (incluso con sudo)
TARGET_USER="${SUDO_USER:-$USER}"
TARGET_HOME=$(getent passwd "$TARGET_USER" | cut -d: -f6)
TARGET_HOME="${TARGET_HOME:-$HOME}"
USER_CONFIG="$TARGET_HOME/.config"

echo "==> [2/4] Configurando aplicaciones por defecto para $TARGET_USER..."

# 1. Establecer Kitty como emulador de terminal por defecto
echo " -> Configurando Kitty como terminal por defecto..."
mkdir -p "$USER_CONFIG"
cat > "$USER_CONFIG/xdg-terminals.list" <<EOF
# Terminal emulator preference order for xdg-terminal-exec
kitty.desktop
EOF

if command -v omarchy-default-terminal >/dev/null 2>&1; then
    sudo -u "$TARGET_USER" omarchy-default-terminal kitty 2>/dev/null || true
fi

# 2. Establecer Firefox como navegador web por defecto
echo " -> Configurando Firefox como navegador web por defecto..."
if command -v xdg-settings >/dev/null 2>&1; then
    sudo -u "$TARGET_USER" xdg-settings set default-web-browser firefox.desktop 2>/dev/null || true
fi

# 3. Aplicar asociaciones MIME personalizadas (mimeapps.list)
echo " -> Instalando asociaciones de archivo en $USER_CONFIG/mimeapps.list..."
cp "$SCRIPT_DIR/config/mimeapps.list" "$USER_CONFIG/mimeapps.list"

# Ajustar propietarios si se ejecutó con sudo
if [[ -n "${SUDO_USER:-}" ]]; then
    chown "$TARGET_USER:" "$USER_CONFIG/xdg-terminals.list" "$USER_CONFIG/mimeapps.list"
fi

# Actualizar base de datos de escritorio
if command -v update-desktop-database >/dev/null 2>&1; then
    update-desktop-database "$TARGET_HOME/.local/share/applications" 2>/dev/null || true
fi

echo "==> Aplicaciones por defecto configuradas con éxito."
