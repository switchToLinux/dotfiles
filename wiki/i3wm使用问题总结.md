# i3wm使用总结

在使用i3wm过程中也会发现一些问题，有些问题可以解决的，我就将方法总结分享在这里了。

## i3wm使用环境变量问题

i3 启动时并不会加载 ~/.bashrc 之类的shell环境变量，因此使用一些自定义环境变量就需要换种方式，比如封装一个shell脚本，如下示例:

```bash
#!/usr/bin/env bash
# i3-wm wrapper script file: i3.sh
# 主动加载环境变量文件
. ~/.bashrc

i3 $@

```
这样才可以导入环境变量。

我们以`i3-sensible-terminal`这个脚本为例，正常情况下，我在`.xprofile`/`.profile`/`.bashrc`/`.zshrc`所有环境变量文件配置了`$TERMINAL`变量：
```sh
export TERMINAL=konsole
```

但重启也是无法在`i3`配置文件中直接读取到`$TERMINAL`环境变量:
```
bindsym $mod+Return workspace $ws1; exec --no-startup-id i3-sensible-terminal
```
每次启动都是找到第一个可用终端，而不是 $TERMINAL 指定终端。

通过上面方法将`i3`包装成一个脚本，比如`/usr/bin/i3.sh`(内容跟上面一致)， 修改`/usr/share/xsessions/i3.desktop`文件，内容如下:
```
[Desktop Entry]
Name=i3
Comment=improved dynamic tiling window manager
Exec=/usr/bin/i3.sh
TryExec=/usr/bin/i3.sh
Type=Application
X-LightDM-DesktopName=i3
DesktopNames=i3
Keywords=tiling;wm;windowmanager;window;manager;
```

这样，重新登录 i3wm 后，`i3-sensible-terminal`就可以读取到`$TERMINAL`环境变量了。

> 说明: 目前这个方法是可行的，但由于改动的内容过多，我还是将 `$TERMINAL` 变量设置在了 `i3`的配置文件中更容易一些。

## 最后

没有完美的桌面，有的只是不断完善、更加好用的桌面，但这都离不开开源世界、离不开每个人的帮助。
