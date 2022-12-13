---
title: Electron
date: 2022-01-17 13:20:00
categories:
- Electron
- Vue
- 学习笔记
tags:
- Electron
- Vue
- 学习笔记
---

# Electron

## 简介

Electron 可以用前端写桌面端。就是把浏览器那套搬到桌面上。系统方面支持 Windows、MacOS、Linux。

## 启动

平时使用 Vue 比较多，因此选择使用 electron-vue 启动项目。

```js
vue init simulatedgreg/electron-vue my-project
cd my-project
cnpm install
npm run dev
```

四步即可启动使用 Vue 搭建的 Electron 项目。

**注意**：启动项目后若提示不能安装 Vue-devtools，则应将`/src/main/index.dev.js`文件改为如下格式：

```js
/**
 * This file is used specifically and only for development. It installs
 * `electron-debug` & `vue-devtools`. There shouldn't be any need to
 *  modify this file, but it can be used to extend your development
 *  environment.
 */

/* eslint-disable */

// Install `electron-debug` with `devtron`
require("electron-debug")({ showDevTools: true });
import { BrowserWindow } from "electron";

// Install `vue-devtools`
require("electron").app.on("ready", () => {
  let installExtension = require("electron-devtools-installer");
  // installExtension.default(installExtension.VUEJS_DEVTOOLS)
  //   .then(() => {})
  //   .catch(err => {
  //     console.log('Unable to install `vue-devtools`: \n', err)
  //   })
  BrowserWindow.addDevToolsExtension("node_modules/vue-devtools/vender"); //手动加载vue-devtools，前提是 npm install vue-devtools --save-dev
});

// Require `main` process to boot app
require("./index");
```

同时运行`npm install vue-devtools --save-dev`手动安装调试工具。

## 项目配置文件

由于`/renderer`文件夹内部就是常见 Vue 项目的框架，该咋开发咋开发，因此仅注意一些特殊的配置文件。

在`/src/main/index.js`中可以找到项目的启动部分，其中有关于项目启动、项目关闭、项目更新等等信息。

## 注意点

Electron-vue 这个脚手架在项目打包时有几个比较离谱的 bug。
运行`npm run build`

1. 报错`Unresolved node modules: vue`，很离谱，不能用 cnpm 安装依赖，必须用 npm 重新安装一遍。
2. 报错`SyntaxError: Identifier 'tasks' has already been declared`，需要进入`/.electron-vue/build.js`，找到四个 tasks 变量，并把后面两个名字改了。
3. 报错`UnhandledPromiseRejectionWarning: ReferenceError: Multispinner is not defined`，需要手动安装`npm i  multispinner --save`，并在`build.js`前面加入`const Multispinner = require('multispinner')`
4. 报错各种 github 下载不了：在`C:\Users\62728\AppData\Local\electron-builder\Cache`这个位置下对应文件夹内放入对应资源包。
5. 安装后白屏：将`webpack.renderer.config.js`内的第 22 行改为：`let whiteListedModules = ['vue', 'vue-router', 'axios', 'vuex', 'vue-electron']`。
