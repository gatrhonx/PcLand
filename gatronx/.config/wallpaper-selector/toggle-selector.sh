#!/usr/bin/env bash

if pgrep -f "wallpaper-selector.py" > /dev/null; then
    pkill -f "wallpaper-selector.py"
    sleep 0.2
else
    # Inicia la app en background
    nohup python3 "$HOME/.config/wallpaper-selector/wallpaper-selector.py" > /dev/null 2>&1 &
    sleep 1.5
    
    # Obtén el window ID y aplica reglas por dirección (más confiable)
    WIN_ID=$(hyprctl clients -j | jq -r '.[] | select(.title == "wallpaper-selector") | .address' | head -1)
    
    if [ -n "$WIN_ID" ]; then
        hyprctl dispatch togglefloating address:"$WIN_ID"
        sleep 0.2
        hyprctl dispatch centerwindow address:"$WIN_ID"
        hyprctl dispatch movewindowpixel exact -32 -32 address:"$WIN_ID"  # Ajusta si necesita offset
    fi
fi
