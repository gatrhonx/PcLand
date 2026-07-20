#!/usr/bin/env bash
set -euo pipefail

WALLPAPER="$1"

# 1. Aplicar wallpaper
awww img "$WALLPAPER" \
    --transition-type grow \
    --transition-duration 1.2 \
    --transition-fps 164

# 2. Generar paleta de colores
# matugen image "$WALLPAPER" \
#    --config "$HOME/.config/wallpaper-selector/matugen.toml"

# 3. Recargar Waybar
#pkill -SIGUSR2 waybar 2>/dev/null || true

# 4. Sincronizar SDDM
#bash "$HOME/.config/wallpaper-selector/sync_sddm.sh" "$WALLPAPER"

# 5. Guardar último wallpaper
#echo "$WALLPAPER" > "$HOME/.config/wallpaper-selector/last.txt"
