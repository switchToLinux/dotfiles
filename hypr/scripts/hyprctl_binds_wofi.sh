#!/bin/bash
show_binds() {
    # 获取并处理 hyprctl binds 命令的输出，过滤和格式化
    hyprctl binds | awk -F: '
    # 检查 modmask，用于设置修饰键
    /modmask/ {
        if ($2 == 64) {
            modifier = "MOD+"
        } else if ($2 == 65) {
            modifier = "MOD+SHIFT+"
        } else {
            modifier = ""
        }
    }
    
    # 获取快捷键
    /key:/ {
        gsub(/\s+/, "", $2)
        hotkey = modifier $2
    }
    
    # 获取 dispatcher 命令
    /dispatcher/ {
        if ($2 != "") {
            cmd = $2 " "
        }
    }
    
    # 获取参数，并拼接完整命令
    /arg/ {
        if ($2 != "") {
            cmd = cmd $2
        }
        
        # 打印快捷键和对应的命令
        printf("%-30s %-s\n", hotkey, cmd)
    }' | grep -vE 'XF86|mouse|MOD\+[0-9]|MOD\+SHIFT\+[0-9]' | \
    # 使用 wofi 进行显示，支持排序、搜索
    wofi -W 60% --location "center" --dmenu --prompt "Hyprland 快捷键绑定" --sort-order alphabetical
}

show_binds
