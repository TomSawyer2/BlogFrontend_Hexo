---
title: HTML Entry
date: 2022-01-30 13:20:00
categories:
- 微前端
- 学习笔记
tags:
- 微前端
- 学习笔记
---

# HTML Entry

## 简介

HTML Entry 是用于解决 JS Entry 侵入性、耦合性太强的问题的。

JS Entry 在 Single-SPA 和 qiankun 框架中得到了广泛的使用，但在修改打包配置这一步骤中就出现了侵入性强的问题。这一步骤使得按需加载、首屏资源加载优化、CSS 独立打包等等常见优化选项消失，因而会带来性能问题。同时，微应用更新发布后需要手动修改主应用中有关微应用的配置，非常麻烦。因而 qiankun 框架更新后选择了 HTML Entry。

## 实现

使用 import-html-entry 实现

1. 通过 http 请求加载指定地址的首屏内容，然后解析模版得到 template、scripts、entry、styles

```js
{
  template: 经过处理的脚本，link、script 标签都被注释掉了,
  scripts: [脚本的http地址 或者 { async: true, src: xx } 或者 代码块],
  styles: [样式的http地址],
 	entry: 入口脚本的地址，要不是标有 entry 的 script 的 src，要不就是最后一个 script 标签的 src
}
```

2. 远程加载样式内容，将模板中注释掉的 link 标签替换为相应的 style 元素，再向外暴露 Promise 对象

```js
{
  // template 是 link 替换为 style 后的 template
 template: embedHTML,
 // 静态资源地址
 assetPublicPath,
 // 获取外部脚本，最终得到所有脚本的代码内容
 getExternalScripts: () => getExternalScripts(scripts, fetch),
 // 获取外部样式文件的内容
 getExternalStyleSheets: () => getExternalStyleSheets(styles, fetch),
 // 脚本执行器，让 JS 代码(scripts)在指定 上下文 中运行
 execScripts: (proxy, strictGlobal) => {
  if (!scripts.length) {
   return Promise.resolve();
  }
  return execScripts(entry, scripts, proxy, { fetch, strictGlobal });
 }
}
```

qiankun 框架使用 Promise 中的 template、assetPublicPath 和 execScripts，将 template 通过 DOM 操作加入主应用，再执行 execScripts 方法得到微应用的生命周期函数。
