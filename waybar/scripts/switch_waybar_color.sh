#!/bin/bash
# 替换当前主题的颜色方案

# 配置文件路径
STYLE_FILE="$HOME/.config/waybar/style.css"
COLOR_FILE="$HOME/.config/waybar/color.css"  # 默认为空

COLORS_DIR="$HOME/.config/waybar/colors"

show_colors() {
    # 通过目录下的 .css 文件获取颜色方案
    ls -1 "$COLORS_DIR" | grep -E '^auto_.*\.css$' | sed 's/\.css$//'
}

switch_color() {
    local select_color=""
    select_color=$(show_colors | wofi --dmenu)
    [[ -z "$select_color" ]] && notify-send "Error: invalid color[$select_color]" && exit 1
    # 替换配置文件中的颜色方案
    # sed -i 's#^.*"../waybar/colors/.*css.*$#@import "../waybar/colors/'$select_color'.css";#' ${STYLE_FILE}
    [[ -f "$COLOR_FILE" ]] && rm "$COLOR_FILE"
    cp -f "$COLORS_DIR/$select_color.css" "$COLOR_FILE"
    
    echo "select color: $select_color"
}

switch_color
