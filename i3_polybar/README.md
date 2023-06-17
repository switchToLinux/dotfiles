# I3wm+polybar

## 快捷键列表

- 打开 vscode : $mod+c
- 打开 terminal : $mod+Enter
- 打开 google-chrome :  $mod+g
- 隐藏/显示 顶部bar ： $mod + n
- 隐藏/显示 底部bar ： $mod + m
- 工作区双屏切换: $mod+x
- 系统退出: $mod+l
- 显示菜单: $mod+d
- 显示窗口列表菜单: $mod+Tab
- 切换窗口布局类型(split/stacking/tabbed): $mod+e/w/s
- 切换垂直/水平方向布局窗口: $mod+v
- 焦点窗口的焦点切换到父节点: $mod+a
- 焦点窗口的焦点切换到子节点: $mod+shift+a
- 全屏显示当前焦点窗口: $mod+f
- 关闭焦点窗口: $mod+q
- 暂存工作区-暂存当前窗口: $mod+shift+minus(减号)
- 暂存工作区-显示暂存窗口: $mod+minus (多个暂存窗口会逐个切换)
- 浮动窗口-切换焦点窗口悬浮/普通 : $mod+shift+space
- 浮动窗口-移动浮动窗口上下左右: $mod + 方向键
- 浮动窗口Sticky-焦点窗口切换: $mod+Shift+s
- 浮动窗口Sticky-切换为置顶悬浮小窗口: $mod+shifqt+p (512x512 => position 854,300 )
- 浮动窗口Sticky-切换为置顶悬浮小窗口: $mod+shift+o (512x256 => position 800,500 )
- 配置-重新加载: $mod+Shift+c
- 配置-i3wm重启: $mod+Shift+r
- 锁屏操作: $mod+l
- 重启系统: $mod+Shift+l
- 窗口resize模式: $mod+r
- 窗口resize模式: `方向键`调整，确认按`Enter`,取消按`Esc`

## 4K等高分辨率配置
> DPI（Dots Per Inch，每英寸点数）是指在显示器上每英寸的像素数量。它表示显示器的像素密度。

对于高分辨率显示内容太小情况，需要修改文件`~/.Xresources`内容`Xft.dpi: 192`，默认值`基准DPI`为`96`，缩放`2.0`倍就是`192`，当然可以根据自己分辨率动态调整，比如缩放`1.5`倍就是`144`。

缩放倍数计算可以这样理解：
- 基准DPI数值 适用于 1920x1080 分辨率显示效果。
- 4K分辨率(3860x2160) 的DPI应该是 2160/1080 的缩放scale倍数。

这样理解起来相对简单了。使用 `xrandr`命令设置时会用到 `scale`参数。

## 动态调整gaps
> 可以通过 `i3-msg`动态调整 gaps 配置窗口边距信息，但下次重启i3后并不会保存当前变更。

动态调整gaps的语法规则如下:
```sh
# Inner gaps: space between two adjacent windows (or split containers).
gaps inner current|all set|plus|minus|toggle <gap_size_in_px>
# Outer gaps: space along the screen edges.
gaps outer|horizontal|vertical|top|right|bottom|left current|all set|plus|minus|toggle <gap_size_in_px>
```

示例:
```sh
i3-msg gaps outer all set 10
```
执行后所有窗口立即产生变化。

## clipboard剪切板

使用[clipmenud](https://github.com/cdown/clipmenu) 解决剪切板问题。

依赖安装:
- xsel
- [clipnotify](https://github.com/cdown/clipnotify.git)  : 安装到 /usr 目录



