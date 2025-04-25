#!/bin/bash
#
# 切换 waybar 布局结构

CONFIG_FILE="$HOME/.config/waybar/config"

show_layout() {
    echo "top"
    echo "bottom"
    echo "left"
    echo "right"
}
switch_layout() {
    local select_layout="$1"
    [[ -z "$select_layout" ]] && notify-send "Error: invalid layout[$select_layout]" && exit 1
    sed -i 's/"position".*$/"position" : '\"${select_layout}\",'/' ${CONFIG_FILE}
}


select_layout=$(show_layout | wofi --dmenu )
switch_layout "$select_layout"

