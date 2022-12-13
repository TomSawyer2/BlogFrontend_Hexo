---
title: qiankun
date: 2022-01-29 13:20:00
categories:
- 微前端
- qiankun
- 学习笔记
tags:
- 微前端
- qiankun
- 学习笔记
---

# qiankun

## 简介

微前端框架，是 Single-SPA 的二次封装，简单易用，同时已经有大量上线应用，开发者蚂蚁金服，稳定性很好。

## 使用

### 主应用

`npm i qiankun -S`

```js
import { registerMicroApps, start } from "qiankun";

registerMicroApps([
  {
    name: "react app", // app name registered
    entry: "//localhost:7100",
    container: "#yourContainer",
    activeRule: "/yourActiveRule",
  },
  {
    name: "vue app",
    entry: { scripts: ["//localhost:7100/main.js"] },
    container: "#yourContainer2",
    activeRule: "/yourActiveRule2",
  },
]);

start();
```

应用的信息注册完后会随着浏览器 URL 的变化展示不同的应用，同时依次调用生命周期函数。

手动加载应用：

```js
import { loadMicroApp } from "qiankun";

loadMicroApp({
  name: "app",
  entry: "//localhost:7100",
  container: "#yourContainer",
});
```

### 微应用

1. 导出生命周期函数狗子
   通常导出 bootstrap、mount、unmount 三个钩子。

```js
/**
 * bootstrap 只会在微应用初始化的时候调用一次，下次微应用重新进入时会直接调用 mount 钩子，不会再重复触发 bootstrap。
 * 通常我们可以在这里做一些全局变量的初始化，比如不会在 unmount 阶段被销毁的应用级别的缓存等。
 */
export async function bootstrap() {
  console.log("react app bootstraped");
}

/**
 * 应用每次进入都会调用 mount 方法，通常我们在这里触发应用的渲染方法
 */
export async function mount(props) {
  ReactDOM.render(
    <App />,
    props.container
      ? props.container.querySelector("#root")
      : document.getElementById("root")
  );
}

/**
 * 应用每次 切出/卸载 会调用的方法，通常在这里我们会卸载微应用的应用实例
 */
export async function unmount(props) {
  ReactDOM.unmountComponentAtNode(
    props.container
      ? props.container.querySelector("#root")
      : document.getElementById("root")
  );
}

/**
 * 可选生命周期钩子，仅使用 loadMicroApp 方式加载微应用时生效
 */
export async function update(props) {
  console.log("update props", props);
}
```

2. 配置微应用打包工具

```js
const packageName = require("./package.json").name;

module.exports = {
  output: {
    library: `${packageName}-[name]`,
    libraryTarget: "umd",
    jsonpFunction: `webpackJsonp_${packageName}`,
  },
};
```

## 配合 Vue 与 React 使用

主应用与前面一样；
微应用如下：

### Vue

1. 在`/src`下新建`public-path.js`

```js
if (window.__POWERED_BY_QIANKUN__) {
  __webpack_public_path__ = window.__INJECTED_PUBLIC_PATH_BY_QIANKUN__;
}
```

2. 修改入口文件`main.js`

```js
import "./public-path";
import Vue from "vue";
import VueRouter from "vue-router";
import App from "./App.vue";
import routes from "./router";
import store from "./store";

Vue.config.productionTip = false;

let router = null;
let instance = null;
function render(props = {}) {
  const { container } = props;
  router = new VueRouter({
    base: window.__POWERED_BY_QIANKUN__ ? "/app-vue/" : "/",
    mode: "history",
    routes,
  });

  instance = new Vue({
    router,
    store,
    render: (h) => h(App),
  }).$mount(container ? container.querySelector("#app") : "#app");
}

// 独立运行时
if (!window.__POWERED_BY_QIANKUN__) {
  render();
}

export async function bootstrap() {
  console.log("[vue] vue app bootstraped");
}
export async function mount(props) {
  console.log("[vue] props from main framework", props);
  render(props);
}
export async function unmount() {
  instance.$destroy();
  instance.$el.innerHTML = "";
  instance = null;
  router = null;
}
```

3. 修改打包配置`vue.config.js`

```js
const { name } = require("./package");
module.exports = {
  devServer: {
    headers: {
      "Access-Control-Allow-Origin": "*",
    },
  },
  configureWebpack: {
    output: {
      library: `${name}-[name]`,
      libraryTarget: "umd", // 把微应用打包成 umd 库格式
      jsonpFunction: `webpackJsonp_${name}`,
    },
  },
};
```

### React

1. 在`/src`下新建`public-path.js`

```js
if (window.__POWERED_BY_QIANKUN__) {
  __webpack_public_path__ = window.__INJECTED_PUBLIC_PATH_BY_QIANKUN__;
}
```

2. 设置 history 路由的 base

```html
<BrowserRouter basename={window.__POWERED_BY_QIANKUN__ ? '/app-react' : '/'}>
```

3. 修改入口文件`index.js`

```js
import "./public-path";
import React from "react";
import ReactDOM from "react-dom";
import App from "./App";

function render(props) {
  const { container } = props;
  ReactDOM.render(
    <App />,
    container
      ? container.querySelector("#root")
      : document.querySelector("#root")
  );
}

if (!window.__POWERED_BY_QIANKUN__) {
  render({});
}

export async function bootstrap() {
  console.log("[react16] react app bootstraped");
}

export async function mount(props) {
  console.log("[react16] props from main framework", props);
  render(props);
}

export async function unmount(props) {
  const { container } = props;
  ReactDOM.unmountComponentAtNode(
    container
      ? container.querySelector("#root")
      : document.querySelector("#root")
  );
}
```

4. 修改 webpack 配置
   `npm i -D @rescripts/cli`
   项目根目录下新建`.rescripts.js`

```js
const { name } = require("./package");

module.exports = {
  webpack: (config) => {
    config.output.library = `${name}-[name]`;
    config.output.libraryTarget = "umd";
    config.output.jsonpFunction = `webpackJsonp_${name}`;
    config.output.globalObject = "window";

    return config;
  },

  devServer: (_) => {
    const config = _;

    config.headers = {
      "Access-Control-Allow-Origin": "*",
    };
    config.historyApiFallback = true;
    config.hot = false;
    config.watchContentBase = false;
    config.liveReload = false;

    return config;
  },
};
```

修改`package.json`

```json
-   "start": "react-scripts start",
+   "start": "rescripts start",
-   "build": "react-scripts build",
+   "build": "rescripts build",
-   "test": "react-scripts test",
+   "test": "rescripts test",
-   "eject": "react-scripts eject"
```

## 非 webpack 应用使用

1. 确保资源均为绝对路径
2. 声明 entry 入口

```html
<script src="//yourhost/entry.js" entry></script>
```

3. 在`entry.js`内部声明 lifecycles

```js
const render = ($) => {
  $("#purehtml-container").html("Hello, render with jQuery");
  return Promise.resolve();
};

((global) => {
  global["purehtml"] = {
    bootstrap: () => {
      console.log("purehtml bootstrap");
      return Promise.resolve();
    },
    mount: () => {
      console.log("purehtml mount");
      return render($);
    },
    unmount: () => {
      console.log("purehtml unmount");
      return Promise.resolve();
    },
  };
})(window);
```
