#!/usr/bin/bash

APP=$1
CLASS=$2

readarray -t wins < <(hyprctl clients | awk -v class="$CLASS" '
    $1 == "Window" { addr = $2 }
    $1 == "class:" && $2 == class { print addr }
')

# Если нет окон — запускаем
if [ ${#wins[@]} -eq 0 ]; then
    $APP &
    exit
fi

# Получить текущее активное окно
current=$(hyprctl activewindow | awk '$1 == "Window" { print $2 }')

# Найдём индекс текущего в списке
current_idx=-1
for i in "${!wins[@]}"; do
    if [[ "${wins[$i]}" == "$current" ]]; then
        current_idx=$i
        break
    fi
done

# Вычисляем следующий индекс
if [ $current_idx -ge 0 ]; then
    next_idx=$(( (current_idx + 1) % ${#wins[@]} ))
    next="${wins[$next_idx]}"
else
    next="${wins[0]}"
fi

# Переключаемся
hyprctl dispatch focuswindow "address:0x$next"
