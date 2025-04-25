#!/usr/bin/env bash

################################
# dependencies commands:
#   - swww
#   - wofi
#   - mako : notify-send
#
# options dependencies commands:
#   - hyprpaper
#   - mpvpaper
#   - zenity
#   - swaybg
#
################################

# Check if the required commands are available
check_dependencies() {
    # Check if the required commands are available
    if ! command -v wofi &>/dev/null; then
        notify-send "Error: wofi is not installed"
        echo "Error: wofi is not installed"
        exit 1
    fi
    if ! command -v mako &>/dev/null; then
        notify-send "Error: mako is not installed"
        echo "Error: mako is not installed"
        exit 1
    fi
}

check_dependencies

# Set the wallpaper directory from .env file
DEFAULT_WALLPAPER_DIR=~/.config/hypr/wallpapers/
WALLPAPER_DIR=""

# 存放 壁纸目录列表 # 
env_file=~/.wallpaper.cfg

get_wallpaper_dir() {
    if [ -f "$env_file" ]; then
        selected_dir=$( (cat "$env_file" && echo "..." ) | wofi -dmenu -p "Select Wallpaper Directory" --sort-order alphabetical)
    else
        selected_dir="..."
    fi
    if [[ "$selected_dir" == "..." ]] ; then 
        if command -v zenity &>/dev/null; then   # 通过对话框设置选择新目录
            selected_dir=$(zenity --file-selection --directory)
        else
            selected_dir=$(wofi -dmenu -p "Select Wallpaper Directory" --sort-order alphabetical)
        fi
    fi
    [[ -z "$selected_dir" ]]  && notify-send "Error: No wallpaper directory selected" && exit 1
    # 检查目录是否存在
    if [ ! -d "$selected_dir" ]; then
        notify-send "Error: $selected_dir is not a directory"
        exit 1
    fi
    # 如果目录为新增的目录，则将其添加到 .env 文件中
    if ! grep -q "^$selected_dir$" "$env_file" 2>/dev/null; then
        echo "$selected_dir" >> "$env_file"
    fi
    echo "$selected_dir"
}

# 判断可用的壁纸命令 #
get_wallpaper_command() {
    command -v swww > /dev/null 2>&1  && echo "swww"
    command -v hyprpaper > /dev/null 2>&1 && echo "hyprpaper"
    command -v swaybg > /dev/null 2>&1 && echo "swaybg"
    command -v mpvpaper > /dev/null 2>&1 && echo "mpvpaper"
}

prepare_command() {
    case $1 in
        "swww")
            ps -ef |grep swww-daemon |grep -v grep >/dev/null  ||  nohup swww-daemon -q >/dev/null 2>&1 &
            pkill -9 swaybg
            pkill -9 hyprpaper
            pkill -9 mpvpaper
            ;;
        "hyprpaper")
            ps -ef |grep hyprpaper |grep -v grep >/dev/null  ||  nohup hyprpaper &
            pkill -9 swaybg
            pkill -9 swww-daemon
            pkill -9 mpvpaper
            ;;
        "swaybg")
            pkill -9 swww-daemon
            pkill -9 hyprpaper
            pkill -9 mpvpaper
            ;;
        "mpvpaper")
            pkill -9 swww-daemon
            pkill -9 hyprpaper
            pkill -9 swaybg
            ;;
    esac
}

set_mpvpaper() {
    # mpvpaper if exists 
    if command -v mpvpaper > /dev/null 2>&1; then
        # 获取当前壁纸mp4/mkv/mov 等视频文件，找到了就使用 mpvpaper ，没有则向下继续执行
        current_wallpaper=$(find "$WALLPAPER_DIR" \( -iname "*.mp4" -o -iname "*.mkv" -o -iname "*.mov" -o -iname "*.avi" \) | shuf -n 1)
        mpvpaper -fvs -o "no-audio loop" "*" "$current_wallpaper"
    fi
}

set_swww() {
    # Get a random wallpaper that is not the current one
    WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" -o -iname "*.webp" \) | shuf -n 1)

    # 如果支持 swww 命令，则使用 swww 命令来设置壁纸
    if command -v swww > /dev/null 2>&1; then
        # transition-type : simple | fade | left | right | top | bottom | wipe | grow | center | outer | random | wave
        swww img "$WALLPAPER" --transition-type random --transition-bezier .43,1.19,1,.4 --transition-fps 60
        notify-send "Wallpaper changed to $WALLPAPER"
        # swww img --transition-type=wipe --transition-angle=30 --transition-step=90 "$WALLPAPER"
    fi
}

set_hyprpaper() {
    # 如果不支持 swww 命令，则使用 hyprpaper 命令来设置壁纸
    if ! command -v hyprpaper &> /dev/null; then
        notify-send "Error: hyprpaper command not found"
        echo "Error: hyprpaper command not found"
        exit 1
    fi
    # Get a random wallpaper that is not the current one
    WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" -o -iname "*.webp" \) | shuf -n 1)
    # Apply the selected wallpaper
    hyprctl hyprpaper unload all
    hyprctl hyprpaper preload "$WALLPAPER"

    # Apply the wallpaper to the wallpaper layer
    for monitor in $(hyprctl monitors| awk '/^Monitor/{ print $2 }') ; do
        hyprctl hyprpaper wallpaper "$monitor,$WALLPAPER"
    done
    notify-send "Wallpaper changed to $WALLPAPER"
}

usage() {
    echo "Usage: $0 [-d <wallpaper_directory>] [-c <wallpaper_command>]"
    echo "  -d <wallpaper_directory>: Specify the wallpaper directory"
    echo "  -c <wallpaper_command>: Specify the wallpaper command (swww, hyprpaper, swaybg, mpvpaper)"
    exit 1
}

# 处理命令行参数
while getopts "d:c:" opt; do
    case $opt in
        d)
            WALLPAPER_DIR="$OPTARG"
            if [ ! -d "$WALLPAPER_DIR" ]; then
                notify-send "Error: $WALLPAPER_DIR is not a directory"
                exit 1
            fi
            ;;
        c)
            SELECTED_COMMAND="$OPTARG"
            if ! echo "$(get_wallpaper_command)" | grep -q "$SELECTED_COMMAND"; then
                notify-send "Error: Invalid wallpaper command: $SELECTED_COMMAND"
                exit 1
            fi
            ;;
        \?)
            usage
            ;;
    esac
done

# 如果没有指定目录，使用 wofi 选择
if [ -z "$WALLPAPER_DIR" ]; then
    WALLPAPER_DIR=$(get_wallpaper_dir)
    [[ "$?" -ne "0" ]] && exit 1
fi

# 如果没有指定命令，使用 wofi 选择
if [ -z "$SELECTED_COMMAND" ]; then
    SELECTED_COMMAND=$(get_wallpaper_command | wofi -dmenu -p "Select Wallpaper Command")
    [[ -z "$SELECTED_COMMAND" ]] && notify-send "Error: No wallpaper command selected" && exit 1
    # 生成自动更新壁纸脚本 #
    echo "#!/bin/bash" > ~/.config/hypr/scripts/update_wallpaper.sh
    echo "~/.config/hypr/scripts/random_wallpaper.sh -d $WALLPAPER_DIR -c $SELECTED_COMMAND" >> ~/.config/hypr/scripts/update_wallpaper.sh
    chmod +x ~/.config/hypr/scripts/update_wallpaper.sh
fi

case $SELECTED_COMMAND in
    "swww")
        prepare_command $SELECTED_COMMAND
        set_swww
        ;;
    "hyprpaper")
        prepare_command $SELECTED_COMMAND
        set_hyprpaper
        ;;
    "swaybg")
        prepare_command $SELECTED_COMMAND
        WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" -o -iname "*.webp" \) | shuf -n 1)
        swaybg -i "$WALLPAPER" -m fill
        notify-send "Wallpaper changed to $WALLPAPER"
        ;;
    "mpvpaper")
        prepare_command $SELECTED_COMMAND
        set_mpvpaper
        ;;
    *)
        notify-send "Notice: Wallpaper command not found"
        exit 1
        ;;
esac
