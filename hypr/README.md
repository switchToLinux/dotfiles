# 配置Hyprland使用说明

前提说明
- 系统：Arch Linux
- 显示管理器: sddm
- 窗口管理器：Hyprland
- 终端： xfce4-terminal
- 编辑器：neovim
- 状态栏：waybar
- 启动器：wofi
- 通知：mako
- 锁屏：hyprlock
- 截图工具： flameshot
- 文件管理器：thunar
- 浏览器：firefox
- 动态壁纸：[swww (支持GIF动画)](https://github.com/LGFae/swww) / [mpvpaper(支持 视频壁纸 )](https://github.com/GhostNaN/mpvpaper) / hyprpaper (仅支持图片壁纸)

  plasma插件安装:
  - 插件管理器：plasma-discover
  - 浏览器: plasma-browser-integration


## 参考资源

- HYPRCURSOR图标主题: [hyprcursor-themes](https://sakshatshinde.github.io/hyprcursor-themes/)


## Bugs问题待解决
>记录一些被发现但无法解决的问题，方便以后跟踪解决方案。




## FAQ

wayland框架协议的问题还是有很多的，所以这里列出一些常见的问题和解决办法。


### 输入法引发的SUPER键未释放问题

**现象描述：**在使用Fcitx5输入法时，如果在 Configure > Addons 页面的 **Wayland Input method frontend** 配置对话框中启用了 **Keep virtual keyboard object for V2 Protocol(Need restart)** 选项后，会出现 Super按键一直被按住的问题。

比如，打开Terminal的快捷键为*Super+Enter*，如果触发了SUPER按键被锁住问题，则只需要按 Enter 键 即可打开 Terminal 终端。

**可能原因分析：**

**V2 Protocol 和虚拟键盘冲突**： 启用 **Keep virtual keyboard object for V2 Protocol** 后，Fcitx5 会尝试保持虚拟键盘对象，这可能会干扰键盘事件的正常传递，导致 **Super** 键被误判为持续按下。



**解决方案**

**禁用 "Keep virtual keyboard object for V2 Protocol"**： 禁用它来解决按键锁住的问题，具体操作如下：

- 打开 **Fcitx5** 的配置界面，进入 **Configure > Addons** 页。
- 取消选中 **Keep virtual keyboard object for V2 Protocol(Need restart)** 选项。
- 重启 **Fcitx5**（或者直接重启系统）以使设置生效。



### 如何解决应用软件缩放导致文字的像素化问题

当某些软件的文字或图标在适配显示器显示时被缩放后引起的像素化现象，解决的办法大致如下：

1. 禁止默认的缩放。
2. 尽可能在应用软件的内部完成缩放设置。



大部分不支持 Wayland 的应用（比如一些老旧的 GTK+ 或 Qt 应用）都可以通过 **XWayland** 来运行。**XWayland** 是一个兼容层，允许 X11 应用在 Wayland 环境中运行。在使用xwayland时，会导致文字的像素化问题。

解决方案可以是这样的：
1. 先禁止xwayland的缩放，然后再启动xwayland应用后只是界面的文字显示很小。
2. 然后再启动xwayland应用后，再修改应用内部的缩放比例，让应用内部的文字显示正常。

具体的操作步骤如下：
1. [禁止xwayland的缩放](https://wiki.hyprland.org/Configuring/XWayland/)，在hyprland的配置文件中添加以下内容：
  ```
  # unscale XWayland # 防止缩放导致文字的像素化问题
  xwayland {
    force_zero_scaling = true
  }
  ```
2. 启动xwayland应用后，再修改应用内部的缩放比例，让应用内部的文字显示正常。

