# dotfiles
i3wm +polybar +picom +mpd dotfiles configuration

## 快速安装

使用 curl 或者 wget 命令快速下载 `i3config`命令:
```
curl -L -o i3config https://raw.githubusercontent.com/switchToLinux/dotfiles/main/i3config

wget -O i3config https://raw.githubusercontent.com/switchToLinux/dotfiles/main/i3config

chmod +x i3config
./i3config

```

## 测试通过发行版

验证Linux系统发行版分支:
- [debian 12](https://www.debian.org/)
- [fedora 38](https://fedoraproject.org/)
- [openSUSE leap 15.5](https://get.opensuse.org/leap/)
- [Arch Linux](https://archlinux.org/)
- [Ubuntu](https://www.ubuntu.com)


## 系统信息

|Distro|[openSUSE](https://www.opensuse.org/)|
|:---:|:---:|
|WM|[i3wm](https://github.com/i3/i3)|
|DM|[lightdm](https://github.com/canonical/lightdm)|
|Bar|[Polybar](https://github.com/polybar/polybar)|
|Menu|[Rofi](https://github.com/davatorium/rofi)-[rofi-themes](https://github.com/adi1090x/rofi)|
|Compositor|[Picom](https://github.com/yshui/picom)|
|Terminal|[konsole](https://konsole.kde.org) / [kitty](https://sw.kovidgoyal.net/kitty/) / [xfce4-terminal](https://gitlab.xfce.org/apps/xfce4-terminal) |
|Widgets|[eww,ElKowars wacky widgets](https://github.com/elkowar/eww)|
|Music/Player|[mpd](https://github.com/MusicPlayerDaemon/MPD)-[ncmpcpp](https://github.com/ncmpcpp/ncmpcpp)|
|File Manager|[Thunar](https://gitlab.xfce.org/xfce/thunar)|
|Terminal File Manager|[ranger](https://github.com/ranger/ranger) written in Python/ [yazi](https://github.com/sxyazi/yazi) written in Rust.|
|Shell|[Zsh](https://www.zsh.org/)-[oh-my-zsh](https://ohmyz.sh/)|
|wallpaper| [feh](https://github.com/derf/feh)-[variety](https://github.com/varietywalls/variety)|
|Xresources-themes| [Xresources-themes](https://github.com/janoamaral/Xresources-themes)|
|clipboard| [clipmenu](https://github.com/cdown/clipmenu) |
|locker| [i3lock-color](https://github.com/Raymo111/i3lock-color)|
|screensaver| [XScreenSaver](https://www.jwz.org/xscreensaver)|
|audio| [pulseaudio](https://www.freedesktop.org/wiki/Software/PulseAudio/) |


> i3wm 推荐编译源码版本，通常自带版本比较低，有些新功能不支持.
> 
> eww是一个适用于所有wm的组件,可以定制一些小组件功能，但对于不同分辨率切换有些让人头疼.
>
> variety可以动态设置壁纸，但它底层还是依赖feh 的。
>
> 也许给i3wm再添加个屏保更有趣一点，我们就选择使用 `XScreenSaver` 作为屏保程序，这个比之前使用的`xautolock`更有趣一些，内置了很多的动画效果。



## TODO

- [x] 配置i3wm文件
- [x] 集成 polybar_themes 项目到 i3wm环境
- [x] 配置 picom 合成器，优化透明效果
- [x] 配置 mpd 音乐播放器(编译源码安装mpd过程问题较多，暂自行安装 mpd/mpc/ncmpcpp)
- [x] 配置 ncmpcpp 音乐播放器客户端
- [x] 配置 ranger 文件浏览器
- [ ] 集成 `Eww` 配置("平替"polybar_themes)，`Eww`支持`X11`和`Wayland`协议。
- [x] 配置 dunst 通知管理
- [x] 配置 rofi 启动器
- [x] 配置 ~/.Xresources 主题
- [x] 配置 rofi 主题(包含启动器、小插件和powermenu)
- [x] 锁屏工具选择`i3lock-color`版本替换原有的i3lock
- [ ] rofi主题优化，自适应分辨率(字体大小、布局)
- [ ] 实现锁屏切换选择，可选 xscreensaver /i3lock / betterlockscreen 等等可用锁屏软件
- [x] 支持 `ArchLinux` / `Manjaro` 发行版的软件编译安装及配置
- [x] i3wm 浮动视频小窗口的位置动态根据屏幕分辨率调整
- [x] 支持选择 lightdm/sddm/gdm等不同的显示管理器安装与切换
- [ ] 支持根据不同显示管理器的主题切换功能
- [x] 支持定制`firefox`页面主题`userChrome.css`
- [ ] 增加[polybar-scripts](https://github.com/polybar/polybar-scripts)的支持
- [x] 动态背景(视频或屏保效果)设置实现(`i3wall`)


## 关于配置快捷键

如果你喜欢使用bindcode 或者不知道某个键对应的名称，可以执行 `xmodmap -pke`命令查看。

## 安装说明
对于每个人的配置使用方式无法做到统一，你喜欢这样，他喜欢那样，一个项目无法满足所有人都喜好。

- 安装软件: 对于一些有必要(`需要最新版`)源码编译方式安装的软件，本项目会实现自动编译安装方法。
- 配置文件: 一种方式是`copy模式`(复制项目配置文件到目标目录),另一种方式是`link模式`(通过软链接)方式使用配置。
- 分辨率适配: 识别`主屏幕分辨率`后自动修改与本项目相关的配置信息(如 dpi/font_size等等)，达到最佳适配效果。

配置文件的两种使用模式的差异:
- `copy模式`源配置文件与目标目录解耦，不受源配置文件的变化影响，但缺点是无法进行变更跟踪和维护。
- `link模式`通过git版本管理，可以跟踪配置变更，本项目采用这种`link模式`。

## i3wm需要dm么？

使用`i3wm`是否还需要加一个显示管理器(比如 `lightdm`、`sddm`或`gdm`)呢？

答案是这不是必要的，但有了`DM`时使用桌面会很方便，比如登录管理(greetings)或`用户自动登录`等。

有的用户对此作出评论为:
> 如果在犹豫是否安装DM,那就试一试没有DM时的情况(`If in doubt, try without`).


`i3config`工具会提供`显示管理器DM`的安装选择功能，并自动根据选择配置使用`i3wm`作为默认的窗口管理器。

如果你希望可以使用最精简的`Linux`桌面系统，那可以通过这种方式安装`显示管理器DM`吧。

流行的几款DM:
- lightdm :轻量级，以Debian12为例，安装后占用空间 100MB左右。
- sddm : 现代、直观的用户界面、良好的可定制性、支持多个桌面环境。以Debian12为例，安装后占用空间2GB左右，安装包690左右。
- gdm : 优点：与GNOME桌面紧密集成、功能丰富、支持GNOME的高级特性、可扩展性好。缺点：相对较高的系统资源占用、对于非GNOME桌面的兼容性可能较差。以Debian12为例，安装后占用空间900MB左右，安装包400+左右。


### 切换显示管理器说明

如果我们使用`lightdm`时，我们需要做到操作如下:
```sh
# 自启动lightdm
sudo systemctl enable lightdm.service

# 禁止gettty服务
sudo systemctl disable getty@.service

```

## 鸣谢

本项目只是聚合菜单工具，将其他作者开发的项目融合在一起，并且提供自动编译安装模块，方便用户使用和少出错。

在此，感谢本项目所使用的相关项目作者！感谢开源社区！
