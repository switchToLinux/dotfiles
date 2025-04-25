#!/bin/bash

# 使用 wofi 显示电源菜单

show_menu() {

    # 增加图标到第一列文字前面
    echo "6.💤 休眠 Suspend"
    echo "5.⏻ 关机 Shutdown"
    echo "4.🔄 重启 Reboot"
    echo "3.❌ 注销 Logout"
    echo "2.🔒 锁屏 Lock"
    echo "1.🚫 取消 Cancel"
}

# 显示菜单并获取用户选择
CHOICE=$(show_menu | wofi --dmenu --prompt "Power Menu:" --center  --sort-order alphabetical  | awk '{print $3}')

echo "choice: $CHOICE"
# 执行相应操作
case "$CHOICE" in
  "Shutdown")
    systemctl poweroff
    ;;
  "Suspend")
    systemctl suspend
    ;;
  "Reboot")
    systemctl reboot
    ;;
  "Logout")
    hyprctl dispatch exit
    ;;
  "Lock")
    hyprlock --immediate
    ;;
  "Cancel")
    exit 0
    ;;
  *)
    exit 1
    ;;
esac
