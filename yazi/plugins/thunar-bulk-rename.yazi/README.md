# thunar-bulk-rename.yazi

<!--toc:start-->

- [thunar-bulk-rename.yazi](#thunar-bulk-renameyazi)
  - [Requirements](#requirements)
  - [Installation](#installation)
    - [Linux](#linux)
  - [Usage](#usage)
  <!--toc:end-->

This plugin is a workaround for bulk-rename using thunar. Because by default,
thunar needs list of file paths, but yazi only return path to a temporary file
(`bulk-1729616414909095`) if we use `bulk-rename` openner.
It will show this in thunar. Not really what we want.

![thunar-bulk-rename-yazi](statics/2024-10-23-00-32-12.png)

## Requirements

- [yazi >= v25.2.7](https://github.com/sxyazi/yazi)
- [Thunar](https://archlinux.org/packages/extra/x86_64/thunar/)

## Installation

### Linux

```sh
git clone https://github.com/boydaihungst/thunar-bulk-rename.yazi ~/.config/yazi/plugins/thunar-bulk-rename.yazi
```

or

```sh
ya pack -a boydaihungst/thunar-bulk-rename
```

## Usage

Replace all `rename` keybinding with this to your `keymap.toml`:
Press `r` to rename, if you select or visual select any file it will open thunar,
but if you didn't select any file it will open normal rename command.

```toml
[manager]
  keymap = [
    { on = "r", run = ["escape --visual", "plugin --sync thunar-bulk-rename"], desc = "Rename selected file(s) (via thunar)" },
  # if you use yazi >= v0.4
  #{ on = "r", run = ["escape --visual", "plugin thunar-bulk-rename"], desc = "Rename selected file(s) (via thunar)" },
  ]
```
