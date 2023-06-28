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


## 系统信息

|Distro|[openSUSE](https://www.opensuse.org/)|
|:---:|:---:|
|WM|[i3wm](https://github.com/i3/i3)|
|Bar|[Polybar](https://github.com/polybar/polybar)|
|Menu|[Rofi](https://github.com/davatorium/rofi)-[rofi-themes](https://github.com/adi1090x/rofi)|
|Compositor|[Picom](https://github.com/yshui/picom)|
|Terminal|[konsole](https://konsole.kde.org)|
|Widgets|[eww,ElKowars wacky widgets](https://github.com/elkowar/eww)|
|Music/Player|[mpd](https://github.com/MusicPlayerDaemon/MPD)-[ncmpcpp](https://github.com/ncmpcpp/ncmpcpp)|
|File Manager|[Thunar](https://gitlab.xfce.org/xfce/thunar)|
|Shell|[Zsh](https://www.zsh.org/)-[oh-my-zsh](https://ohmyz.sh/)|
|wallpaper| [feh](https://github.com/derf/feh)-[variety](https://github.com/varietywalls/variety)|
|Xresources-themes| [Xresources-themes](https://github.com/janoamaral/Xresources-themes)|
|clipboard| [clipmenu](https://github.com/cdown/clipmenu) |
|locker| [i3lock-color](https://github.com/Raymo111/i3lock-color)|
|screensaver| [XScreenSaver](https://www.jwz.org/xscreensaver)|

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
- [ ] 集成 eww 配置
- [x] 配置 dunst 通知管理
- [x] 配置 rofi 启动器
- [x] 配置 ~/.Xresources 主题
- [x] 配置 rofi 主题(包含启动器、小插件和powermenu)
- [x] 锁屏工具选择`i3lock-color`版本替换原有的i3lock
- [ ] rofi主题优化，自适应分辨率(字体大小、布局)


## 关于配置快捷键

如果你喜欢使用bindcode 或者不知道某个键对应的名称，可以执行 `xmodmap -pke`命令查看。

## 鸣谢

本项目只是聚合菜单工具，将其他作者开发的项目融合在一起，并且提供自动编译安装模块，方便用户使用和少出错。

在此，感谢本项目所使用的相关项目作者！感谢开源社区！
