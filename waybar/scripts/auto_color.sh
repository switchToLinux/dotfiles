#!/bin/bash

usage() {
    echo "Usage: $0 [arrow]"
    echo "  arrow: 箭头类型，默认为 null"
    exit 1
}

# 配置文件路径
THEME_FILE=$HOME/.config/waybar/themes.json
CONFIG_FILE="$HOME/.config/waybar/config"
OUTPUT_FILE="$HOME/.config/waybar/styles/autogen_color.css"
ARROW_MODULE_FILE="$HOME/.config/waybar/modules/modules-autogen.json"

left_arr=""
right_arr=""

# 获取 arrow 参数
default_arrow="$1"


selected_theme="$(jq -r '.selected_theme' $THEME_FILE)"
echo "selected_theme: $selected_theme"

# 函数：生成 CSS 规则
generate_css() {
    local module_name=$(echo $1 | sed 's/\//-/g;s/#/\./g;s/^hyprland-//g;s/^group-//g;s/^wlr-//g;' )
    local background=$2
    local color=$3
    {
        echo "#$module_name {"
        echo "    color: $color;"
        echo "    background-color: $background;"
        echo "}"
    } >> "$OUTPUT_FILE"
}

show_arrows() {
    echo  " " # 三角形-triangle
    echo  " " # 半圆
    echo " "  # 直角三角形
    echo  " "   # 三角边线
    echo  " "  # 平行四边形
    echo " "  # 火焰 fire
    echo " "  # 三角缺口
    echo " "  # 三角缺口2
    echo "space space"  # 替换空格用途
}


generate_arrow_module() {
    local m_name="$1"
    local arr=$right_arr
    if [[ "${m_name}" =~ ^custom/arrow1[0-9]$ ]] ; then
        arr=$left_arr
    fi
    {
        echo "  \"$m_name\": {"
        echo "    \"format\": \"$arr\"," 
        echo "    \"tooltip\": false"
        echo "  }," 
    } >> "$ARROW_MODULE_FILE"
}

select_arrow() {
    # 选择 arrow 类型
    # 生成 modules/modules-arrow.json 文件
    # 格式 "X Y"
    local selected_arrow=
    if [[ ! -z "$default_arrow" ]] ; then
        selected_arrow=$default_arrow
    else
        # 强制使用的分割箭头设置, 设置了则不再支持切换箭头#
        selected_arrow=$(jq -r '.themes[] | select(.name == "'"$selected_theme"'") |.arrow' $THEME_FILE)
    fi
    if [[ "$selected_arrow" == "" || "$selected_arrow" == "null" ]] ; then
        selected_arrow=$( show_arrows | wofi --dmenu )
    else
        echo "force arrow:[$selected_arrow]"
    fi
    echo "selected_arrow: [$selected_arrow]"
    if [[  -z "$selected_arrow" ]] ; then
        selected_arrow=" "  # 默认三角形
    fi
    readarray -d ' ' -t arrs <<< $(echo -n "$selected_arrow" )
    echo "arrows: [${arrs[0]} , ${arrs[1]}]"
    local len=${#arrs[@]}
    echo "arrow len:${len}: [$selected_arrow]"
    if [[ "$len" != "2" ]] ; then
        notify-send "Error: arrow format invalid,len:${len}: [$selected_arrow]"
        exit 1
    fi
    if [[ "${arrs[0]}" =~ ^space  ]] ; then
        left_arr=""
        right_arr=""
    else
        left_arr=${arrs[0]}
        right_arr="$(echo -n ${arrs[1]} | sed 's/\n//g')"
    fi
}
# 读取并解析配置文件
# 函数：解析模块并生成 CSS 规则
# 参数：
#   modules_type: 模块类型（left/center/right）
parse_modules() {
    local modules_type=$1
    local current_position=0
    local modules
    echo "type: $modules_type"
    echo "---------------------"
    # 逆序解析右侧模块
    if [[ "$modules_type" == "right" ]]; then
        modules=$(sed 's://.*::g; /\/\*/,/\*\//d' "$CONFIG_FILE" | jq -r '.["modules-right"]')
    elif [[ "$modules_type" == "center" ]]; then
        modules=$(sed 's://.*::g; /\/\*/,/\*\//d' "$CONFIG_FILE" | jq -r '.["modules-center"] | reverse')
    else
        modules=$(sed 's://.*::g; /\/\*/,/\*\//d' "$CONFIG_FILE" | jq -r '.["modules-left"] | reverse')
    fi

    echo "$modules" | jq -r '.[]'
    # 解析模块顺序
    local current_separator_color=""
    local previous_separator_color=""
    local previous_module=""
    readarray -t module_list <<< $(echo "$modules" | jq -r '.[]')
    local len=${#module_list[@]}
    for module in ${module_list[@]} ; do
        echo "module: $module"
        if [[ "$module" =~ ^custom/nope$ ]] ; then  # 空白透明分割模块
            generate_css "$module" "transparent" "transparent"
            current_position=$((current_position + 1))
            continue
        # elif [[ "$module" =~ ^group/.*$ ]]; then  # 分组模块
        #     current_position=$((current_position + 1))
        #     continue
        elif [[ "$module" =~ ^custom/arrow1[0-9]$ ]]; then
            current_separator_color="${module:13:1}"
            generate_arrow_module "$module"
        elif [[ "$module" =~ ^custom/arrow[0-9]$ ]]; then
            current_separator_color="${module:12:1}"
            generate_arrow_module "$module"
        else
            if [[ "$previous_module" != "" ]] ; then
                generate_css "$previous_module" "@color$previous_separator_color" "@foreground"
            fi
            # 功能模块 # 等待下一个分隔符模块再处理
            previous_module="$module"
            current_position=$((current_position + 1))
            continue
        fi
        echo "cur_color: $current_separator_color,  pre_color: $previous_separator_color, previous_module:$previous_module"

        if [[ "$previous_module" != "" ]] ; then
            generate_css "$previous_module" "@color$previous_separator_color" "@foreground"
            previous_module=""
        fi

        if [[ "$current_position" == "0" ]]; then
            # 如果是第一个模块
            generate_css "$module" "transparent" "@color$current_separator_color"
        else
            echo "len:$len , current: $((current_position + 1))"
            if [[ "$len" -eq "$((current_position + 1))" ]] ; then  # 结尾是分隔符模块
                generate_css "$module" "transparent" "@color$previous_separator_color"
            else
                generate_css "$module" "@color$previous_separator_color" "@color$current_separator_color"
            fi
        fi
        previous_separator_color="$current_separator_color"
        current_position=$((current_position + 1))
    done
    if [[ "$previous_module" != "" ]] ; then
        generate_css "$previous_module" "@color$previous_separator_color" "@foreground"
    fi
}

select_arrow

# 清空输出文件
echo > "$OUTPUT_FILE"
echo "{"> "$ARROW_MODULE_FILE"

# 生成左侧样式规则
parse_modules "left"
# 生成中间样式规则
parse_modules "center"
# 生成右侧样式规则（逆序解析）
parse_modules "right"

echo "}" >> "$ARROW_MODULE_FILE"
echo "CSS styles : $OUTPUT_FILE"
echo "module-arrow.json: ${ARROW_MODULE_FILE}"
