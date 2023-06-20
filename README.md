# dotfiles
i3wm +polybar +picom +mpd dotfiles configuration

## 快速安装

```
curl -sSL -o i3config https://raw.githubusercontent.com/switchToLinux/dotfiles/main/i3config
chmod +x i3config
./i3config
```

## 信息

|Distro|[openSUSE](https://www.opensuse.org/)|
|:---:|:---:|
|WM|[i3wm](https://github.com/i3/i3)|
|Bar|[Polybar](https://github.com/polybar/polybar)|
|Menu|[Rofi](https://github.com/davatorium/rofi)|
|Compositor|[Picom](https://archlinux.org/packages/community/x86_64/picom/)|
|Terminal|[konsole](https://konsole.kde.org)|
|Widgets|[eww,ElKowars wacky widgets](https://github.com/elkowar/eww)|
|Music/Player|[mpd](https://archlinux.org/packages/extra/x86_64/mpd/)-[ncmpcpp](https://archlinux.org/packages/community/x86_64/ncmpcpp/)|
|File Manager|[Thunar](https://archlinux.org/packages/extra/x86_64/thunar/)|
|Shell|[Zsh](https://archlinux.org/packages/extra/x86_64/zsh/)|
|wallpaper| [feh](https://github.com/derf/feh)-[variety](https://github.com/varietywalls/variety)|
|Xresources-themes| [Xresources-themes](https://github.com/janoamaral/Xresources-themes)|


> i3wm 推荐编译源码版本，通常自带版本比较低，有些新功能不支持.
> 
> eww是一个适用于所有wm的组件,可以定制一些小组件功能，但对于不同分辨率切换有些让人头疼.
>
> variety可以动态设置壁纸，但它底层还是依赖feh 的。



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


## 关于配置快捷键

如果你喜欢使用bindcode 或者不知道某个键对应的名称，可以执行 `xmodmap -pke`命令查看。