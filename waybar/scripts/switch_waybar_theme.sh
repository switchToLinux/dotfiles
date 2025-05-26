#!/bin/bash

# waybar主题切换脚本
# 根据 ~/.config/waybar/configs 目录下的配置文件名(xxx.json格式)列表切换主题(只获取 xxx ，不要后缀), 并根据文件名同步修改软链接 stycle.css 文件关联到 styles目录对应 .css文件
# 使用 wofi 选择主题进行切换

THEME_FILE=$HOME/.config/waybar/themes.json

# 定义 waybar 配置文件目录和样式文件目录
config_dir="$HOME/.config/waybar/configs"
styles_dir="$HOME/.config/waybar/styles"
script_dir="$HOME/.config/waybar/scripts"
color_dir="$HOME/.config/waybar/colors"

# 定义 waybar 配置文件和样式文件的软链接路径
config_link="$HOME/.config/waybar/config"
style_link="$HOME/.config/waybar/style.css"
color_link="$HOME/.config/waybar/color.css"

show_themes() {
    jq -r '.themes[] | .name' $THEME_FILE
}


switch_theme() {
    # 使用 wofi 选择主题
    selected_theme=$(show_themes | wofi --dmenu --prompt="选择 waybar 主题")
    [[ -z "$selected_theme" ]] && echo "未选择主题，退出" && exit 1
    selected_config=$(jq -r '.themes[] | select(.name == "'"$selected_theme"'") | .config' $THEME_FILE)
    selected_style=$(jq -r '.themes[] | select(.name == "'"$selected_theme"'") |.style' $THEME_FILE)
    selected_color=$(jq -r '.themes[] | select(.name == "'"$selected_theme"'") |.color' $THEME_FILE)

    echo "debug: $selected_theme $selected_config $selected_style $selected_color"
    [[ ! -f  "$config_dir/$selected_config" ]] && echo "未找到对应的配置文件 $selected_config，退出" && exit 1
    [[ ! -f  "$styles_dir/$selected_style" ]] && echo "未找到对应的样式文件 $selected_style，退出" && exit 1
    if [[ ! -z "$selected_color" && "$selected_color" != "null" ]] ; then
        [[ ! -f  "$color_dir/$selected_color" ]] && echo "未找到对应的颜色文件，退出" && exit 1
        [[ -f  "$color_link" ]] && rm "$color_link"
        cp -f "$color_dir/$selected_color" "$color_link"
    fi
    cp "$config_dir/$selected_config" "$config_link"
    cp "$styles_dir/$selected_style" "$style_link"
    
    sed -i "s/\"selected_theme\": \".*\"/\"selected_theme\": \"$selected_theme\"/" "$THEME_FILE"

    # 执行脚本
    echo "执行脚本"
    for script in $(jq -r '.themes[] | select(.name == "'"$selected_theme"'") | .scripts[]' $THEME_FILE) ; do
        chmod +x $script_dir/${script} 
        $script_dir/${script} >/dev/null 2>&1
    done
    
    notify-send "已切换到 $selected_theme 主题"
    echo "已切换到 $selected_theme 主题"
}

show_config() {
    for file in "$config_dir"/*.json; do
        if [ -f "$file" ]; then
            config_name="${file##*/}"
            config_name="${config_name%.*}"
            echo "$config_name"
        fi
    done
}

show_styles() {
    for file in "$styles_dir"/*.css; do
        if [ -f "$file" ]; then
            style_name="${file##*/}"
            style_name="${style_name%.*}"
            echo "$style_name"
        fi
    done
}

switch_config() {
    # 使用 wofi 选择主题
    selected_config=$(show_themes | wofi --dmenu --prompt="选择 waybar 主题")

    if [ -z "$selected_config" ]; then
        echo "未选择主题，退出"
        exit 1
    fi

    # 修改 waybar 配置文件软链接
    if [ -L "$config_link" ]; then
        rm "$config_link"
    fi
    cp "$config_dir/$selected_config.json" "$config_link"

    echo "已切换到 $selected_config 主题"
}

switch_style() {
    # 使用 wofi 选择样式
    selected_style=$(show_styles | wofi --dmenu --prompt="选择 waybar 样式")
    if [ -z "$selected_style" ]; then
        echo "未选择样式，使用默认样式"
        selected_style="default"
    else
        # 修改样式文件软链接
        if [ -L "$style_link" ]; then
            rm "$style_link"
        fi
        if [ ! -f "$styles_dir/$selected_style.css" ]; then
            echo "样式文件 $selected_style.css 不存在，使用默认样式"
            selected_style="default"
        fi
        cp "$styles_dir/$selected_style.css" "$style_link"
        echo "已切换到 $selected_style 样式"
    fi
}

# 主流程

action="${1:-theme}"
case "$action" in
    "config")
        switch_config
        ;;
    "style")
        switch_style
        ;;
    "theme")
        switch_theme
        ;;
    *)
        switch_config && switch_style
        ;;
esac


