#!/usr/bin/env bash

popup=$1

# Получаем ID текущего рабочего стола
current_ws=$(hyprctl activeworkspace -j | jq '.id')

# Ищем первое окно с классом "quake"
win=$(hyprctl clients -j | jq -r '.[] | select(.class == "quake") | .address' | head -n 1)
    
if [ -z "$win" ]; then
    $popup --class quake
    exit 0
fi

# Узнаём, на каком WS окно сейчас

win_ws=$(hyprctl clients -j | jq -r --arg addr "$win" '.[] | select(.address==$addr) | .workspace.id')

if [ "$win_ws" -eq "$current_ws" ]; then
    # Окно на текущем WS — убиваем/сворачиваем
    hyprctl dispatch movetoworkspacesilent special:quake,"address:$win"
    
else
    # Окно есть, но на другом WS — переносим на текущий и фокусируем
    hyprctl dispatch movetoworkspace "$current_ws","address:$win"
    hyprctl dispatch focuswindow "address:$win"
fi

