# firefox主题使用方法

常规的自定义`firefox`外观样式的方法:
1. 找到`profile`配置文件目录： 菜单-》帮助-》`更多排障信息`，找到`配置文件夹`，点击`打开目录`。
2. 在`配置文件夹`下创建一个`chrome`目录，再在`chrome`目录下新建一个`userChrome.css`配置文件。
3. 在`userChrome.css`配置文件中添加主题配置代码后保存。
4. 重启`firefox`浏览器，查看效果。


## 本主题使用方法

通过软链接方式使用主题配置

`配置文件夹`设置为`$config_path` 为例：
```sh

config_path=~/.mozilla/firefox/am73grlv.default-esr-3

# 创建软链接使用此主题
ln -sf ~/.config/dotfiles/firefox_themes $config_path/chrome

```
这样就完成了，重启`firefox`查看效果。


