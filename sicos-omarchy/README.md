# SicOS Setup for Omarchy

Este directorio contiene los scripts y configuraciones necesarios para transformar una instalación estándar de **[Omarchy](https://github.com/basecamp/omarchy)** en tu entorno de trabajo **SicOS**, preservando tus atajos de teclado habituales, aplicaciones y configuraciones clave sin entrar en conflicto con el sistema de actualizaciones de Omarchy.

---

## 🎯 ¿Qué hace este instalador?

1. **Gestión de paquetes (`01-packages.sh`)**:
   - **Desinstala aplicaciones innecesarias de Omarchy**: `foot`, `evince`, `imv`, `pinta`, `xournalpp`, `cliamp`, `tobi-try` (usando `omarchy-pkg-drop` o pacman).
   - **Instala las aplicaciones de SicOS**: `kitty`, `zed`, `firefox`, `google-chrome`, `yazi`, `qmmp`, `vlc`, `papers`, `feh`, `hyprshot`, `satty`, `lazyssh-bin`, `insync`, `buttermanager`, `opencode`, `antigravity-cli`, etc.
2. **Aplicaciones por defecto (`02-default-apps.sh`)**:
   - Establece **Kitty** como emulador de terminal predeterminado mediante `omarchy-default-terminal kitty` (`~/.config/xdg-terminals.list`).
   - Establece **Firefox** como navegador por defecto.
   - Aplica asociaciones MIME en `~/.config/mimeapps.list` (Zed para código/texto, Papers para PDF, Feh para imágenes, VLC para vídeo, QMMP para música).
3. **Migración de atajos de teclado (`03-keybindings.sh`)**:
   - Genera y aplica `~/.config/hypr/bindings.lua` desvinculando colisiones de Omarchy e implementando todos tus atajos de SicOS (`Ctrl+Alt+T`, `Super+Q`, `Super+W`, `Super+T`, `Super+F`, `Super+Return` submap para mover ventanas, `Super+M` magic workspace, layouts `F1..F4`, redimensionamiento con flechas, etc.).
4. **Sincronización de dotfiles (`04-dotfiles-sync.sh`)**:
   - Copia configuraciones optimizadas para **Kitty**, **Zed**, **Yazi** (con plugins `wise-enter` y `mount`), y **QMMP** (con la skin clásica de Winamp `winamp_classic.wsz`).

---

## 🚀 Uso

En el sistema Omarchy recién instalado, ejecuta:

```bash
cd omarchy
chmod +x *.sh
./setup.sh
```

O si prefieres ejecutar los pasos individualmente:

```bash
./01-packages.sh       # Gestión de paquetes
./02-default-apps.sh   # Aplicaciones por defecto
./03-keybindings.sh    # Atajos de teclado
./04-dotfiles-sync.sh  # Dotfiles de aplicaciones
```

---

## ⌨️ Resumen de Atajos Principales Migrados

| Atajo | Acción |
| :--- | :--- |
| `Ctrl + Alt + T` | Abrir terminal **Kitty** |
| `Super + Y` | Abrir **Yazi** en Kitty |
| `Super + T` | Abrir editor **Zed** |
| `Super + W` | Abrir navegador **Firefox** |
| `Super + P` | Abrir **Firefox** en ventana privada |
| `Super + Q` | Cerrar ventana activa |
| `Super + E` | Abrir explorador **Nautilus** |
| `Super + F` | Alternar ventana flotante / mosaico |
| `Super + G` | Abrir WebApp **Gemini AI** |
| `Super + C` | Abrir **Lazyssh** en Kitty |
| `Super + Ctrl + Up` | Pantalla completa (Fullscreen) |
| `Super + Return` | Modo submap para mover ventana (flechas = movimiento, Super+flechas = salto de monitor) |
| `Ctrl + Alt + Left/Right` | Cambiar a workspace anterior / siguiente |
| `Ctrl + Alt + Shift + Left/Right` | Mover ventana a workspace anterior / siguiente |
| `Super + M` | Workspace especial (Magic / Scratchpad) |
| `Super + F1..F4` | Cambiar layouts en caliente (Dwindle, Master, Scrolling, Monocle) |
| `Print` | Captura de región con anotación (**Satty**) |
| `Super + Print` | Captura de región directa al portapapeles |
| `Ctrl + Alt + L` | Bloquear pantalla |
| `Ctrl + Alt + Delete` | Salir de la sesión Hyprland |
| `Super + K` | Mostrar el buscador / cheatsheet interactivo de atajos de Omarchy |
