#!/usr/bin/env bash
# =============================================================================
# 01-packages.sh - Gestión de Paquetes para SicOS en Omarchy
# =============================================================================

echo "==> [1/4] Gestionando paquetes del sistema..."

# 1. Detectar Helper de AUR (Omarchy incluye yay)
if command -v yay >/dev/null 2>&1; then
    AUR_HELPER="yay"
elif command -v paru >/dev/null 2>&1; then
    AUR_HELPER="paru"
else
    echo " -> AUR helper no encontrado. Instalando yay..."
    sudo pacman -Sy --needed --noconfirm base-devel git || true
    git clone https://aur.archlinux.org/yay.git /tmp/yay-build || true
    if [[ -d /tmp/yay-build ]]; then
        (cd /tmp/yay-build && makepkg -si --noconfirm) || true
        rm -rf /tmp/yay-build
    fi
    AUR_HELPER="yay"
fi

echo " -> Gestor de paquetes: $AUR_HELPER"

# Actualizar base de datos de paquetes local
echo " -> Actualizando índices de paquetes..."
sudo pacman -Sy || true

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

# 3. Lista completa de paquetes para SicOS
# yay resuelve automáticamente si el paquete está en repositorios oficiales o en AUR
SICOS_PKGS=(
    # Terminal y Editores
    kitty
    zed
    
    # Navegadores
    firefox
    google-chrome
    
    # Gestor de archivos y utilidades
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
    opencode-bin
    antigravity-cli
)

# Función para desinstalar paquetes de forma segura sin abortar
drop_package() {
    local pkg="$1"
    if pacman -Qq "$pkg" >/dev/null 2>&1; then
        echo " -> Eliminando paquete prescindible: $pkg"
        if command -v omarchy-pkg-drop >/dev/null 2>&1; then
            omarchy-pkg-drop "$pkg" 2>/dev/null || sudo pacman -Rns --noconfirm "$pkg" 2>/dev/null || true
        else
            sudo pacman -Rns --noconfirm "$pkg" 2>/dev/null || true
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

# --- Paso 2: Instalar paquetes uno a uno de forma resiliente ---
echo "--- Instalando aplicaciones de SicOS con $AUR_HELPER ---"
FAILED_PKGS=()

for pkg in "${SICOS_PKGS[@]}"; do
    echo " -> Instalando: $pkg"
    if $AUR_HELPER -S --needed --noconfirm "$pkg" 2>/dev/null; then
        echo "    ✅ $pkg instalado correctamente."
    else
        # Intentar fallbacks conocidos si falló el nombre principal
        installed_fallback=false
        case "$pkg" in
            opencode-bin)
                echo "    Intentando fallback: opencode..."
                if $AUR_HELPER -S --needed --noconfirm opencode 2>/dev/null; then
                    installed_fallback=true
                fi
                ;;
            lazyssh-bin)
                echo "    Intentando fallback: lazyssh..."
                if $AUR_HELPER -S --needed --noconfirm lazyssh 2>/dev/null; then
                    installed_fallback=true
                fi
                ;;
            zed)
                echo "    Intentando fallback: zed-preview-bin..."
                if $AUR_HELPER -S --needed --noconfirm zed-preview-bin 2>/dev/null; then
                    installed_fallback=true
                fi
                ;;
            hyprshot)
                echo "    Intentando fallback: hyprshot-git..."
                if $AUR_HELPER -S --needed --noconfirm hyprshot-git 2>/dev/null; then
                    installed_fallback=true
                fi
                ;;
        esac

        if [[ "$installed_fallback" == "true" ]]; then
            echo "    ✅ $pkg instalado mediante fallback."
        else
            echo "    ⚠️ No se pudo encontrar/instalar '$pkg' (se continuará con el resto)."
            FAILED_PKGS+=("$pkg")
        fi
    fi
done

if (( ${#FAILED_PKGS[@]} > 0 )); then
    echo ""
    echo "Aviso: Los siguientes paquetes opcionales no pudieron instalarse automáticamente:"
    for p in "${FAILED_PKGS[@]}"; do
        echo " - $p"
    done
    echo "Puedes revisarlos o instalarlos manualmente más adelante si los necesitas."
fi

echo "==> Paso de paquetes finalizado."
exit 0
