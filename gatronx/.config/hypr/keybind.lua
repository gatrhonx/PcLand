local mainMod = "SUPER"
local wallpaper = "awww-daemon"
local fileManager = "nautilus"
local terminal = "kitty"
local menu = "wofi"

-- Atajos para programas
hl.bind(mainMod .. " + " .. "TAB", hl.dsp.exec_cmd("~/.config/wallpaper-selector/toggle-selector.sh")) -- Wallpaper-selector
hl.bind(mainMod .. " + " .. "SPACE", hl.dsp.exec_cmd("pkill rofi || rofi -show drun"))
hl.bind(mainMod .. " + " .. "C", hl.dsp.window.close())
hl.bind(mainMod .. " + " .. "V", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + " .. "P", hl.dsp.exec_cmd("discord"))
hl.bind(mainMod .. " + " .. "F", hl.dsp.exec_cmd("firefox"))
hl.bind(mainMod .. " + " .. "R", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + " .. "Q", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + " .. "E", hl.dsp.exec_cmd(fileManager))

-- - configuracion fn - #
hl.bind(mainMod .. " + " .. "F9", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch exit"))
hl.bind(mainMod .. " + " .. "F6", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
hl.bind(mainMod .. " + " .. "F4", hl.dsp.exec_cmd("wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true})
hl.bind(mainMod .. " + " .. "F5", hl.dsp.exec_cmd("wpctl set-volume -l 0.0 @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true})
hl.bind("Print", hl.dsp.exec_cmd("hyprshot -m output --clipboard-only"))






-- Atajos para Workspaces & windows

-- gesture = 3, "horizontal", "workspace"
hl.bind(mainMod .. " + " .. 1, hl.dsp.focus({ workspace = 1 }))
hl.bind(mainMod .. " + " .. 2, hl.dsp.focus({ workspace = 2 }))
hl.bind(mainMod .. " + " .. 3, hl.dsp.focus({ workspace = 3 }))
hl.bind(mainMod .. " + " .. 4, hl.dsp.focus({ workspace = 4 }))
hl.bind(mainMod .. " + " .. 5, hl.dsp.focus({ workspace = 5 }))
hl.bind(mainMod .. " + " .. 6, hl.dsp.focus({ workspace = 6 }))
hl.bind(mainMod .. " + " .. 7, hl.dsp.focus({ workspace = 7 }))
hl.bind(mainMod .. " + " .. 8, hl.dsp.focus({ workspace = 8 }))
hl.bind(mainMod .. " + " .. 9, hl.dsp.focus({ workspace = 9 }))
hl.bind(mainMod .. " + " .. 0, hl.dsp.focus({ workspace = 10 }))
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })
hl.bind("SUPER + mouse:272", hl.dsp.window.float(), { mouse = true, click = true }) -- Vuelve flotante la ventana
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true, drag = true })   -- Mover dentro del tiling

-- Mover ventana flotante con SUPER + flechas (movimiento relativo en píxeles)
hl.bind("SUPER + left",  hl.dsp.window.move({ x = -20, y = 0, relative = true }))
hl.bind("SUPER + right", hl.dsp.window.move({ x = 20,  y = 0, relative = true }))
hl.bind("SUPER + up",    hl.dsp.window.move({ x = 0,   y = -20, relative = true }))
hl.bind("SUPER + down",  hl.dsp.window.move({ x = 0,   y = 20, relative = true }))


hl.bind(mainMod .. " + SHIFT + 1", hl.dsp.window.move({ workspace = 1 }))
hl.bind(mainMod .. " + SHIFT + 2", hl.dsp.window.move({ workspace = 2 }))
hl.bind(mainMod .. " + SHIFT + 3", hl.dsp.window.move({ workspace = 3 }))
hl.bind(mainMod .. " + SHIFT + 4", hl.dsp.window.move({ workspace = 4 }))
hl.bind(mainMod .. " + SHIFT + 5", hl.dsp.window.move({ workspace = 5 }))
hl.bind(mainMod .. " + SHIFT + 6", hl.dsp.window.move({ workspace = 6 }))
hl.bind(mainMod .. " + SHIFT + 7", hl.dsp.window.move({ workspace = 7 }))
hl.bind(mainMod .. " + SHIFT + 8", hl.dsp.window.move({ workspace = 8 }))
hl.bind(mainMod .. " + SHIFT + 9", hl.dsp.window.move({ workspace = 9 }))
hl.bind(mainMod .. " + SHIFT + 0", hl.dsp.window.move({ workspace = 10 }))

