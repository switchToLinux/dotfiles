# nvim配置说明

配置说明：
- 既然选择了`neovim`，那就优先选择`Lua`语言进行配置


## 如何使用

1. 安装最新版 [neovim](https://github.com/neovim/neovim) ，如果你的Linux发行版是滚动版本，可能安装包已经是最新版了。
2. 克隆本项目到本地，`git clone https://github.com/switchToLinux/dotfiles.git` 
3. 软链接`dotfiles`下的`nvim`子目录到`~/.config/nvim`目录

OK！ 再次打开`neovim`后就会自动安装插件，等插件安装完成后就可以使用了。

## 快捷键

- 切换文件浏览器: `\`+`e`
- 切换Terminal终端: `Ctrl`+`\`(反斜线)
- 切换窗口焦点: `Ctrl`+`h`/`j`/`k`/`l` 
- 焦点窗口大小调整: `Ctrl`+`方向键` 或 鼠标拖动
- visual模式切换： `v` 或 鼠标选择自动切换
- visual模式缩进: `>`向右缩进选区，`<`向左缩进选区


### Vim常用的默认快捷键

- 三种模式切换:`i`/`a`/`o`/`c`/`s`/(编辑模式)、`r`(替换模式)、`v`(visual模式)、`:`/`/`/`?`/`!`(命令模式)、`Ctrl`+`\`(终端模式)
- 跳转至文件首行:`gg`
- 跳转至文件末行:`G`
- 跳转至当前行首部:`g0`
- 跳转至当前行末尾:`g$`
- 当前代码块折叠/展开: `z`+`a`
- 当前代码块内部全部折叠/展开: `z`+`A`
- 函数定义跳转: `Ctrl`+`]`
- 函数定义返回至调用栈上层: `Ctrl`+`T`
- 撤销上一个操作:`u`
- 撤销所有操作:`U`
- 重做下一个操作:`Ctrl`+`R`
- 复制当前行:`yy`
- 剪切当前行:`dd`
- 粘帖当前行:`p`

## 参考阅读

- [从零开始配置 Neovim](https://martinlwx.github.io/zh-cn/config-neovim-from-scratch/#%E5%AE%89%E8%A3%85%E6%8F%92%E4%BB%B6%E7%AE%A1%E7%90%86%E5%99%A8)
- [awesome-neovim](https://github.com/rockerBOO/awesome-neovim)

---
