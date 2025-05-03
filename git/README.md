# 如何使用

全局安装配置使用方法如下：

安装

```bash
npm install -g cz-git commitizen
```

配置

```bash
cp ./git/default_commitlintrc.js ~/.commitlintrc.js
echo -e '{\n    "path": "cz-git",\n    "useEmoji": true\n}' > ~/.czrc
```

这样就可以在`git`管理的项目中通过`cz`使用了。

这里提供了三种配置示例文件，你可以根据自己需求配置，但通常还是建议使用默认的英文配置。

