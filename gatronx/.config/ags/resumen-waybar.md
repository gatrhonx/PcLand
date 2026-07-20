# Progreso Waybar - Resumen para continuar

## Contexto
Usuario en Arch Linux + Hyprland, configurando waybar desde cero (ya tenía un config base con un bug de JSON). Se decidió trabajar en dos fases:

- **Fase 1 (completada en este chat):** dejar waybar 100% funcional y bonito con las capacidades nativas de waybar (json + css).
- **Fase 2 (pendiente, para otro chat):** implementar "burbujas" estilo GNOME quick-settings (popups con sliders interactivos al hacer click en volumen/red). Esto **no es posible con waybar nativo**, requiere **eww** o **ags (Aylur's GTK Shell)**, que es un sistema de widgets aparte. Es un proyecto más grande, no solo tocar config.jsonc/style.css.

## Decisiones de diseño tomadas
- Paleta: **Catppuccin Mocha**
- Estilo de módulos: barra **continua** (sin "pastillas"/cajitas individuales), pero con separación sutil entre módulos (línea delgada `border-left`, no fondo propio por módulo)
- Barra **flotante** (con margen respecto a los bordes de pantalla, vía `"margin"` en config.jsonc, no CSS)
- Transparencia del fondo: **media** (`rgba(30, 30, 46, 0.65)`)
- Colores de acento por módulo (Catppuccin Mocha):
  - Workspace activo → mauve `#cba6f7`
  - Reloj → rosewater `#f5e0dc`
  - Volumen → green `#a6e3a1` (hover: teal `#94e2d5`)
  - Red → blue `#89b4fa` (hover: sky `#89dceb`)
  - CPU → peach `#fab387`
  - Memoria → yellow `#f9e2af` 
  - pero que el usuario cambio a su gusto

## Módulos configurados
- `hyprland/workspaces`: con `persistent-workspaces` (solo el 1 fijo)
- `clock`: formato 24h, tooltip con calendario
- `pulseaudio`:
  - Solo ícono en formato (`{icon}`)
  - Tooltip muestra `Volumen: {volume}%`
  - Scroll para subir/bajar (`scroll-step: 5`)
  - `smooth-scrolling-threshold: 1` agregado para reducir (no eliminar del todo) el parpadeo del tooltip al hacer scroll — **limitación conocida de GTK**, no 100% arreglable vía config/CSS
  - Click abre **pwvucontrol** (instalado vía AUR con yay, tras resolver un problema de mirrors con `sudo pacman -Syyu`)
- `custom/network`: reemplaza el módulo nativo `network` porque el usuario quería ver el **nombre de la conexión** (NetworkManager), no la IP. Implementado con script bash + `nmcli` (`~/.config/waybar/scripts/network.sh`), `return-type: json`, `interval: 5`. Click abre **nm-connection-editor** (instalado vía pacman)
- `cpu`, `memory`: formato simple con ícono

## Módulos guardados para el futuro (comentados en config, no activos)
- `battery`
- `bluetooth`

## Pendiente / Próxima sesión (Fase 2)
- Investigar e implementar **eww** o **ags** para lograr:
  - Al hacer click en el ícono de volumen: popup/burbuja con un **slider deslizable** real (no solo tooltip)
  - Al hacer click en el ícono de red: popup tipo "quick settings" de GNOME con lista de redes disponibles
- Definir cómo integrar esos popups visualmente con la paleta Catppuccin Mocha y el estilo ya definido (barra continua, flotante, transparencia media)
- Evaluar si además quieren agregar **blur real** (glass effect) vía `layerrule` de Hyprland sobre la superficie de waybar (transparencia ya está lista, blur sería el siguiente paso opcional)

## Archivos actuales (fase 1, ya entregados)
- `config.jsonc`
- `style.css`
- `network.sh` (script para el módulo custom/network, va en `~/.config/waybar/scripts/`)

## Notas técnicas relevantes
- El campo `"margin"` en config.jsonc controla si la barra es flotante (no se hace por CSS)
- Waybar convierte nombres de módulo tipo `custom/network` en selector CSS `#custom-network` (guión en vez de barra)
- El usuario tuvo un problema instalando paquetes AUR por mirrors desincronizados — se resolvió con `sudo pacman -Syyu` antes de reintentar `yay -S <paquete>`
