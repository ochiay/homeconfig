#!/usr/bin/bash

popup=$1

# Найдём адрес первого окна с классом "quake"


win=$(hyprctl clients | awk '
    /Window/ { addr = $2 }
    /class:[ \t]*quake/ { print addr }
' | head -n 1)

if [ -n "$win" ]; then
    hyprctl dispatch killwindow "address:0x$win"
else
    # Иначе — запускаем новое
    $popup --class quake
fi
