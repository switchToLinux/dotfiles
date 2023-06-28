# rofi
> 当前配置已经`弃用`!使用`i3config`的`select_rofi_themes`选项安装更多主题和插件。

## 配置方法

官方配置文档：
- https://davatorium.github.io/rofi/CONFIG/
- https://github.com/davatorium/rofi/blob/next/doc/rofi-theme.5.markdown

配置最简单的方式是直接选择主题方案，例如:
```
configuration {
  modes: [ combi ];
  combi-modes: [ window, drun, run ];
}

@theme "fancy2"
/* Insert theme modifications after this */

```


