#!/bin/bash

# 获取所有监视器的列表和当前工作区所在的显示器
num_monitors=$(hyprctl monitors | grep  '^Monitor' | awk '{print $2}' | wc -l)
current_monitor=$(hyprctl activewindow | grep -oP '(?<=monitor: )\S+')


# 检查是否有多个显示器
if [[ $num_monitors -gt 1 ]]; then
    # 如果有多个监视器，计算下一个监视器的索引
    next_monitor_index=$(( (current_monitor + 1) % num_monitors ))
    # 移动当前工作区到下一个监视器
    hyprctl dispatch movecurrentworkspacetomonitor $next_monitor_index
else
    hyprctl dispatch swapnext
fi
