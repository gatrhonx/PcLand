#!/usr/bin/env bash

# Detecta la conexión activa (nombre real puesto en NetworkManager)
con_info=$(nmcli -t -f NAME,TYPE,DEVICE connection show --active | head -n1)

if [ -z "$con_info" ]; then
    echo '{"text":"Desconectado ⚠","tooltip":"Sin conexión activa","class":"disconnected"}'
    exit 0
fi

name=$(echo "$con_info" | cut -d: -f1)
type=$(echo "$con_info" | cut -d: -f2)
device=$(echo "$con_info" | cut -d: -f3)

if [ "$type" = "802-11-wireless" ]; then
    signal=$(nmcli -t -f active,signal dev wifi | grep '^yes' | cut -d: -f2)

    # Ícono según intensidad de señal (igual que el format-icons original)
    if [ "$signal" -ge 80 ]; then
        icon="󰤨"
    elif [ "$signal" -ge 60 ]; then
        icon="󰤥"
    elif [ "$signal" -ge 40 ]; then
        icon="󰤢"
    elif [ "$signal" -ge 20 ]; then
        icon="󰤟"
    else
        icon="󰤯"
    fi

    tooltip="Wi-Fi: ${name}\nSeñal: ${signal}%\nInterfaz: ${device}"
else
    icon="󰈀"
    ip=$(nmcli -g IP4.ADDRESS device show "$device" 2>/dev/null | cut -d/ -f1 | head -n1)
    tooltip="Conexión: ${name}\nIP: ${ip}\nInterfaz: ${device}"
fi

echo "{\"text\":\"${icon} ${name}\",\"tooltip\":\"${tooltip}\",\"class\":\"connected\"}"
