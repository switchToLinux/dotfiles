#!/bin/bash

WAYBAR_HOME="$HOME/.config/waybar"

# waybar 操作菜单
show_menu() {
    echo theme  切换waybar主题
    echo color  切换waybar颜色搭配
    echo arrow  切换waybar分隔符
    echo layout  切换waybar位置
}


str_action=$(show_menu | wofi --dmenu | awk '{ print $1 }' )
case "$str_action" in
    theme)
        bash ${WAYBAR_HOME}/scripts/switch_waybar_theme.sh
        ;;
    arrow)
        bash ${WAYBAR_HOME}/scripts/auto_color.sh
        ;;
    color)
        bash ${WAYBAR_HOME}/scripts/switch_waybar_color.sh
        ;;
    layout)
        bash ${WAYBAR_HOME}/scripts/switch_waybar_layout.sh
        ;;
    *)
        echo "Error: invalid action[$str_action]"
        exit 1
        ;;
esac

# 重新加载 Waybar
if pidof waybar >/dev/null 2>&1; then
    killall -SIGUSR2 waybar
else
    nohup waybar >/dev/null 2>&1 &
fi



