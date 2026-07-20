#!/usr/bin/env bash
set -euo pipefail

WALLPAPER="$1"
SDDM_THEME_DIR="/usr/share/sddm/themes/Sugar-Candy"
MATUGEN_COLORS="$HOME/.config/matugen/colors.json"

# 1. Copiar imagen al tema SDDM
sudo cp "$WALLPAPER" "$SDDM_THEME_DIR/Backgrounds/wallpaper.jpg"

# 2. Extraer colores
ACCENT=$(jq -r '.colors.light.primary'      "$MATUGEN_COLORS")
BG=$(jq    -r '.colors.light.background'    "$MATUGEN_COLORS")
FG=$(jq    -r '.colors.light.on_background' "$MATUGEN_COLORS")

# 3. Actualizar theme.conf
sudo tee "$SDDM_THEME_DIR/theme.conf" > /dev/null <<CONF
[General]
background=$SDDM_THEME_DIR/Backgrounds/wallpaper.jpg
AccentColor=$ACCENT
BackgroundColor=$BG
TextColor=$FG
CONF
