-- =============================================================================
-- ~/.config/hypr/bindings.lua
-- SicOS Keybindings for Omarchy
-- =============================================================================
-- Este archivo mapea todos los atajos de teclado de SicOS a Omarchy sin romper
-- las actualizaciones del sistema. Utiliza hl.unbind para eliminar colisiones
-- con los defaults de Omarchy y o.bind/hl.bind para registrar tus acciones.
-- =============================================================================

-- ==========================================
-- 1. APLICACIONES PRINCIPALES
-- ==========================================

-- Terminal (Kitty)
hl.bind("CTRL + ALT + T", hl.dsp.exec_cmd("uwsm app -- kitty"), { description = "Terminal (Kitty)" })

-- Gestor de Archivos CLI (Yazi en Kitty)
o.bind("SUPER + Y", "File Manager (Yazi)", "uwsm app -- kitty yazi")

-- Editor de Texto / Código (Zed)
-- En Omarchy SUPER+T viene asignado a Toggle Float, lo desvinculamos primero:
hl.unbind("SUPER + T")
o.bind("SUPER + T", "Editor (Zed)", "uwsm app -- zeditor")

-- Navegador Web (Firefox)
-- En Omarchy SUPER+W viene asignado a Cerrar Ventana, lo desvinculamos primero:
hl.unbind("SUPER + W")
o.bind("SUPER + W", "Navegador Web (Firefox)", "uwsm app -- firefox")

-- Navegador Web Privado (Firefox Private)
-- En Omarchy SUPER+P viene asignado a Pseudo Window, lo desvinculamos primero:
hl.unbind("SUPER + P")
o.bind("SUPER + P", "Firefox (Ventana Privada)", "uwsm app -- firefox --private-window")

-- Cerrar Ventana Activa (SUPER + Q)
-- En Omarchy SUPER+Q viene asignado a la calculadora, lo desvinculamos primero:
hl.unbind("SUPER + Q")
o.bind("SUPER + Q", "Cerrar Ventana", hl.dsp.window.close())

-- Gestor de Archivos Gráfico (Nautilus)
o.bind("SUPER + E", "Explorador de Archivos (Nautilus)", "uwsm app -- nautilus")

-- Alternar Ventana Flotante (SUPER + F)
-- En Omarchy SUPER+F viene asignado a Fullscreen, lo desvinculamos primero:
hl.unbind("SUPER + F")
o.bind("SUPER + F", "Alternar Flotante / Mosaico", hl.dsp.window.float({ action = "toggle" }))

-- Gemini WebApp (SUPER + G)
-- En Omarchy SUPER+G viene asignado a Grouping, lo desvinculamos primero:
hl.unbind("SUPER + G")
o.bind("SUPER + G", "Gemini AI", "uwsm app -- google-chrome-stable --app='https://gemini.google.com/'")

-- Lazyssh en Kitty (SUPER + C)
o.bind("SUPER + C", "Lazyssh", "uwsm app -- kitty --override term=xterm-256color -e lazyssh")

-- Menú / Lanzador de aplicaciones (SUPER / Walker o Menú de Omarchy)
-- Si Walker está instalado, SUPER_L lo abre; de lo contrario SUPER+SPACE abre el menú Omarchy
hl.bind("SUPER + SUPER_L", hl.dsp.exec_cmd("walker || omarchy-menu toggle"), { description = "Lanzador de Aplicaciones" })

-- ==========================================
-- 2. MANEJO DE VENTANAS Y PANTALLA COMPLETA
-- ==========================================

-- Maximizar / Pantalla Completa
o.bind("SUPER + CTRL + UP", "Pantalla Completa", hl.dsp.window.fullscreen({ mode = "fullscreen" }))

-- Modo Pseudo Ventana y Dividir Layout
hl.bind("SUPER + KP_Multiply", hl.dsp.window.pseudo(), { description = "Pseudo Ventana" })
hl.bind("SUPER + KP_Divide", hl.dsp.layout("togglesplit"), { description = "Cambiar Split de Ventana" })

-- Redimensionar Ventanas con SUPER + ALT + Flechas
hl.bind("SUPER + ALT + Right", hl.dsp.window.resize({ x = 20, y = 0, relative = true }), { repeating = true, description = "Redimensionar Derecha" })
hl.bind("SUPER + ALT + Left", hl.dsp.window.resize({ x = -20, y = 0, relative = true }), { repeating = true, description = "Redimensionar Izquierda" })
hl.bind("SUPER + ALT + Up", hl.dsp.window.resize({ x = 0, y = -20, relative = true }), { repeating = true, description = "Redimensionar Arriba" })
hl.bind("SUPER + ALT + Down", hl.dsp.window.resize({ x = 0, y = 20, relative = true }), { repeating = true, description = "Redimensionar Abajo" })

-- Mover foco entre ventanas con SUPER + Flechas
hl.bind("SUPER + Left", hl.dsp.focus({ direction = "l" }), { description = "Mover Foco Izquierda" })
hl.bind("SUPER + Right", hl.dsp.focus({ direction = "r" }), { description = "Mover Foco Derecha" })
hl.bind("SUPER + Up", hl.dsp.focus({ direction = "u" }), { description = "Mover Foco Arriba" })
hl.bind("SUPER + Down", hl.dsp.focus({ direction = "d" }), { description = "Mover Foco Abajo" })

-- ==========================================
-- 3. SUBMAP PARA MOVER VENTANAS (SUPER + RETURN)
-- ==========================================
-- Desvinculamos SUPER + RETURN (que en Omarchy abre el terminal por defecto)
hl.unbind("SUPER + RETURN")
hl.bind("SUPER + RETURN", hl.dsp.submap("moveWindow"), { description = "Modo Mover Ventana" })
hl.define_submap("moveWindow", function()
    -- Movimiento fluido dentro del mismo monitor
    hl.bind("Right", hl.dsp.window.move({ direction = "r" }), { repeating = true, description = "Mover Ventana Derecha" })
    hl.bind("Left", hl.dsp.window.move({ direction = "l" }), { repeating = true, description = "Mover Ventana Izquierda" })
    hl.bind("Up", hl.dsp.window.move({ direction = "u" }), { repeating = true, description = "Mover Ventana Arriba" })
    hl.bind("Down", hl.dsp.window.move({ direction = "d" }), { repeating = true, description = "Mover Ventana Abajo" })

    -- Salto entre monitores
    hl.bind("SUPER + Right", hl.dsp.window.move({ monitor = "r" }), { description = "Saltar a Monitor Derecho" })
    hl.bind("SUPER + Left", hl.dsp.window.move({ monitor = "l" }), { description = "Saltar a Monitor Izquierdo" })
    hl.bind("SUPER + Up", hl.dsp.window.move({ monitor = "u" }), { description = "Saltar a Monitor Superior" })
    hl.bind("SUPER + Down", hl.dsp.window.move({ monitor = "d" }), { description = "Saltar a Monitor Inferior" })

    -- Salir del submap
    hl.bind("Escape", hl.dsp.submap("reset"))
end)

-- ==========================================
-- 4. ESPACIOS DE TRABAJO (WORKSPACES)
-- ==========================================

-- Cambiar de workspace relativo con CTRL + ALT + Flechas
hl.bind("CTRL + ALT + Left", hl.dsp.focus({ workspace = "r-1" }), { desc = "Workspace Anterior" })
hl.bind("CTRL + ALT + Right", hl.dsp.focus({ workspace = "r+1" }), { desc = "Workspace Siguiente" })

-- Mover ventana activa a workspace relativo con CTRL + ALT + SHIFT + Flechas
hl.bind("CTRL + ALT + SHIFT + Left", hl.dsp.window.move({ workspace = "r-1" }), { desc = "Mover Ventana a Workspace Anterior" })
hl.bind("CTRL + ALT + SHIFT + Right", hl.dsp.window.move({ workspace = "r+1" }), { desc = "Mover Ventana a Workspace Siguiente" })

-- Workspace Mágico / Scratchpad
o.bind("SUPER + M", "Workspace Mágico", hl.dsp.workspace.toggle_special("magic"))
hl.bind("CTRL + ALT + SHIFT + M", hl.dsp.window.move({ workspace = "special:magic" }), { description = "Mover Ventana a Workspace Mágico" })

-- ==========================================
-- 5. CAMBIAR LAYOUTS EN CALIENTE (F1 - F4)
-- ==========================================

hl.bind("SUPER + F1", function()
    hl.config({ general = { layout = "dwindle" } })
    hl.exec_cmd('omarchy-notification-send "Dwindle Layout" "Binary Tree layout activado"')
end, { description = "Activar Layout Dwindle" })

hl.bind("SUPER + F2", function()
    hl.config({ general = { layout = "master" } })
    hl.exec_cmd('omarchy-notification-send "Master Layout" "Master window layout activado"')
end, { description = "Activar Layout Master" })

hl.bind("SUPER + F3", function()
    hl.config({ general = { layout = "scrolling" } })
    hl.exec_cmd('omarchy-notification-send "Scrolling Layout" "Scrolling layout activado"')
end, { description = "Activar Layout Scrolling" })

hl.bind("SUPER + F4", function()
    hl.config({ general = { layout = "monocle" } })
    hl.exec_cmd('omarchy-notification-send "Monocle Layout" "Monocle layout activado"')
end, { description = "Activar Layout Monocle" })

-- ==========================================
-- 6. CAPTURAS DE PANTALLA Y SISTEMA
-- ==========================================

-- Captura de pantalla de región con Satty
hl.unbind("PRINT")
hl.bind("Print", hl.dsp.exec_cmd("omarchy-notification-send 'Screenshot' 'Selecciona la región' && hyprshot -m region --raw | satty --filename - --early-exit --copy-command wl-copy --initial-tool arrow --output-filename ~/Pictures/screenshot-$(date '+%Y%m%d-%H:%M:%S').png"), { description = "Captura de región con Satty" })
hl.bind("SUPER + Print", hl.dsp.exec_cmd("hyprshot -m region --clipboard-only"), { description = "Captura de región directa al portapapeles" })

-- Bloqueo de pantalla
o.bind("CTRL + ALT + L", "Bloquear Pantalla", "omarchy-system-lock")

-- Salir de sesión
hl.bind("CTRL + ALT + Delete", hl.dsp.exit(), { description = "Cerrar Sesión Hyprland" })
