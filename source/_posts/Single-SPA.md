---
title: Single-SPA
date: 2022-01-28 13:20:00
categories:
- 微前端
- Single-SPA
- 学习笔记
tags:
- 微前端
- Single-SPA
- 学习笔记
---

# Single-SPA

## 简介

[Single-SPA 文档](https://zh-hans.single-spa.js.org/docs/getting-started-overview)

Single-SPA 是一个将多个 SPA 应用合为一体的 JS 微前端框架，即可以在一个页面中使用多个前端框架，同时独立部署每一个 SPA。

Single-SPA 包括 Applications 和 Single-SPA-Config 配置，前者即对应各个 SPA，后者用于向每个 Application 注册名称、执行函数、判断执行状态的函数。

Application 与 Single-SPA-Config 示例

```js
//main.js
import * as singleSpa from "single-spa";
const name = "app1";
/* loading 是一个返回 promise 的函数，用于 加载/解析 应用代码。
 * 它的目的是为延迟加载提供便利 —— single-spa 只有在需要时才会下载应用程序的代码。
 * 在这个示例中，在 webpack 中支持 import ()并返回 Promise，但是 single-spa 可以使用任何返回 Promise 的加载函数。
 */
const app = () => import("./app1/app1.js");
/* Single-spa 配置顶级路由，以确定哪个应用程序对于指定 url 是活动的。
 * 您可以以任何您喜欢的方式实现此路由。
 * 一种有用的约定是在url前面加上活动应用程序的名称，以使顶层路由保持简单。
 */
const activeWhen = "/app1";
singleSpa.registerApplication({ name, app, activeWhen });
singleSpa.start();

//app1.js
let domEl;
export function bootstrap(props) {
  return Promise.resolve().then(() => {
    domEl = document.createElement("div");
    domEl.id = "app1";
    document.body.appendChild(domEl);
  });
}
export function mount(props) {
  return Promise.resolve().then(() => {
    // 在这里通常使用框架将ui组件挂载到dom。请参阅https://single-spa.js.org/docs/ecosystem.html。
    domEl.textContent = "App 1 is mounted!";
  });
}
export function unmount(props) {
  return Promise.resolve().then(() => {
    // 在这里通常是通知框架把ui组件从dom中卸载。参见https://single-spa.js.org/docs/ecosystem.html
    domEl.textContent = "";
  });
}
```

## 脚手架-Single-SPA-CLI

```bash
npm install --global create-single-spa

create-single-spa --framework react --dir my-dir --moduleType root-config
```

### webpack-config-single-spa

用于定制 webpack 配置

```bash
npm install --save-dev webpack-config-single-spa webpack-merge
```

```js
const webpackMerge = require("webpack-merge");
const singleSpaDefaults = require("webpack-config-single-spa");
module.exports = (webpackConfigEnv) => {
  const defaultConfig = singleSpaDefaults({
    // The name of the organization this application is written for
    orgName: "name-of-company",
    // The name of the current project. This usually matches the git repo's name
    projectName: "name-of-project",
    // See https://webpack.js.org/guides/environment-variables/#root for explanation of webpackConfigEnv
    webpackConfigEnv,
  });
  return webpackMerge.smart(defaultConfig, {
    // modify the webpack config however you'd like to by adding to this object
  });
};
```

### webpack-config-single-spa-ts

```bash
npm install --save-dev webpack-config-single-spa-ts webpack-merge
```

```js
const webpackMerge = require("webpack-merge");
const singleSpaDefaults = require("webpack-config-single-spa-ts");
module.exports = (webpackConfigEnv) => {
  const defaultConfig = singleSpaDefaults({
    // The name of the organization this application is written for
    orgName: "name-of-company",
    // The name of the current project. This usually matches the git repo's name
    projectName: "name-of-project",
    // See https://webpack.js.org/guides/environment-variables/#root for explanation of webpackConfigEnv
    webpackConfigEnv,
  });
  return webpackMerge.smart(defaultConfig, {
    // modify the webpack config however you'd like to by adding to this object
  });
};

const singleSpaTs = require("webpack-config-single-spa-ts");
// Alternatively, you may modify a webpack config directly
const myOtherWebpackConfig = {
  /* ... */
};
const finalConfig = singleSpaDefaults.modifyConfig(myOtherWebpackConfig);
```

### webpack-config-single-spa-react-ts

```bash
npm install --save-dev webpack-config-single-spa-react-ts webpack-merge
```

```js
const webpackMerge = require("webpack-merge");
const singleSpaDefaults = require("webpack-config-single-spa-react-ts");
module.exports = (webpackConfigEnv) => {
  const defaultConfig = singleSpaDefaults({
    // The name of the organization this application is written for
    orgName: "name-of-company",
    // The name of the current project. This usually matches the git repo's name
    projectName: "name-of-project",
    // See https://webpack.js.org/guides/environment-variables/#root for explanation of webpackConfigEnv
    webpackConfigEnv,
  });
  return webpackMerge.smart(defaultConfig, {
    // modify the webpack config however you'd like to by adding to this object
  });
};
```

## 相关配置

所有微前端应用共享的 HTML 页面和调用注册应用的 JS 用于启动 Single-SPA。

index.html 只用于调用 registerApplication()，别的不用管。

注册应用

```js
// single-spa-config.js
import { registerApplication, start } from 'single-spa';

// Simple usage
registerApplication(
  'app2',
  () => import('src/app2/main.js'),
  (location) => location.pathname.startsWith('/app2'),
  { some: 'value' }
);

// Config with more expressive API
registerApplication({
  name: 'app1', // 应用的名称
  app: () => import('src/app1/main.js'), // 加载函数，也可以是已解析应用
  activeWhen: '/app1', // 激活函数
  customProps: {
    some: 'value',
  }
);

start(); // 挂载应用
```

注册两个路由

```js
<div id="single-spa-application:app-name"></div>
<div id="single-spa-application:other-app"></div>
```

## 构建应用

Single-SPA 应用没有 HTML 页面，仅仅控制不同 SPA 的展示。

在前序过程中已经创建并注册了应用程序，之后需要注册应用的生命周期。

```js
function bootstrap(props) {
  const {
    name, // 应用名称
    singleSpa, // singleSpa实例
    mountParcel, // 手动挂载的函数
    customProps, // 自定义属性
  } = props; // Props 会传给每个生命周期函数
  return Promise.resolve();
}
```

### 下载-load

懒加载注册的应用，这个部分不要执行任何操作。

### 初始化

各个生命周期函数在应用首次挂载前执行一次。

### 挂载-mount

根据 URL 确定激活的路由，创建 DOM，展示内容，但是**子路由的改变不会触发 mount**。

### 卸载-unmount

清理 DOM。

### 移除-unload

以后再使用该应用需要重新初始化。

### 全局配置

```js
export function bootstrap(props) {...}
export function mount(props) {...}
export function unmount(props) {...}

// 统一配置各生命周期函数的超时时间
export const timeouts = {
  bootstrap: {
    millis: 5000, // 控制台输出警告的毫秒数
    dieOnTimeout: true,
    warningMillis: 2500, // 警告打印的间隔毫秒数
  },
  mount: {
    millis: 5000,
    dieOnTimeout: false,
    warningMillis: 2500,
  },
  unmount: {
    millis: 5000,
    dieOnTimeout: true,
    warningMillis: 2500,
  },
  unload: {
    millis: 5000,
    dieOnTimeout: true,
    warningMillis: 2500,
  },
};
```

## 拆分应用

如果一个应用提前规划好分成哪几个 Application，那么就没有必要拆分，此处是重构老项目时需要考虑的部分。

- 一个仓库一个 build 包，通过 script 调用
- 使用 npm 包
- 动态加载模块

## 迁移现有应用

1. 创建 Single-SPA 配置文件；
2. 将 SPA 应用转换为注册应用；
3. 调整 HTML 文件，使 Single-SPA 配置生效。

## Parcel

指与框架无关的组件，可以被应用手动挂载，大小不限，只要可以导出生命周期事件即可，这块暂时不用，之后看文档。

## 布局引擎

顶层的路由

```bash
npm install --save single-spa-layout@beta
```

```html
<html>
  <head>
    <template id="single-spa-layout">
      <single-spa-router>
        <nav class="topnav">
          <application name="@organization/nav"></application>
        </nav>
        <div class="main-content">
          <route path="settings">
            <application name="@organization/settings"></application>
          </route>
          <route path="clients">
            <application name="@organization/clients"></application>
          </route>
        </div>
        <footer>
          <application name="@organization/footer"></application>
        </footer>
      </single-spa-router>
    </template>
  </head>
</html>
```

```js
import { registerApplication, start } from "single-spa";
import {
  constructApplications,
  constructRoutes,
  constructLayoutEngine,
} from "single-spa-layout";
const routes = constructRoutes(document.querySelector("#single-spa-layout"));
const applications = constructApplications({
  routes,
  loadApp({ name }) {
    return System.import(name);
  },
});
const layoutEngine = constructLayoutEngine({ routes, applications });
applications.forEach(registerApplication);
start();
```

### HTML Layout

```html
<!-- index.ejs -->
<html>
  <head>
    <template>
      <single-spa-router>
        <div class="main-content">
          <route path="settings">
            <application name="settings"></application>
          </route>
        </div>
      </single-spa-router>
    </template>
  </head>
</html>
```

### JSON Layout

```js
const layout = {
  routes: [
    {
      type: "route",
      path: "settings",
      routes: [{ type: "application", name: "settings" }],
    },
  ],
};
```

### Layout 元素

`<template>`内部定义 Layout；
`<single-spa-router>`路由标签，参数设置如下：

```json
{
  "mode": "hash|history",
  "base": "/",
  "disableWarnings": false,
  "containerEl": "#container",
  "routes": []
}
```

`<route>`具体路由，示例如下：

```html
<route path="clients">
  <application name="clients"></application>
</route>
<route default>
  <application name="clients"></application>
</route>
```

```js
{
  "type": "route",
  "path": "clients",
  "routes": [
    { "type": "application", "name": "clients" }
  ],
  "default": false
}
```

照着 vue-router 理解即可。

### Props

JSON：

```js
import { constructRoutes } from 'single-spa-layout';
constructRoutes({
  routes: [
    { type: "application", name: "nav" props: { title: "Title" } },
    { type: "route", path: "settings" props: { otherProp: "Some value" } },
  ]
})
```

HTML：

```html
<application name="settings" props="authToken,loggedInUser"></application>
```

```js
import { constructRoutes } from "single-spa-layout";
const data = {
  props: {
    authToken: "fds789dsfyuiosodusfd",
    loggedInUser: fetch("/api/logged-in-user").then((r) => r.json()),
  },
};
const routes = constructRoutes(
  document.querySelector("#single-spa-template"),
  data
);
```

### 加载状态

```html
<application name="topnav" loader="topNav"></application>
<application name="topnav" loader="settings"></application>
```

```js
import { constructRoutes } from 'single-spa-layout';
// You may also use Angular, Vue, etc.
const settingsLoader = singleSpaReact({...})
const data = {
  loaders: {
    topNav: `<nav class="placeholder"></nav>`,
    settings: settingsLoader
  }
}
const routes = constructRoutes(document.querySelector('#single-spa-template'), data)
```

### 默认路由

```html
<single-spa-router>
  <route path="cart"></route>
  <route path="product-detail"></route>
  <route default>
    <h1>404 Not Found</h1>
  </route>
</single-spa-router>
```

```html
<single-spa-router>
  <route path="cart"></route>
  <route path="product-detail/:productId">
    <route path="reviews"></route>
    <route path="images"></route>
    <route default>
      <h1>Unknown product page</h1>
    </route>
  </route>
  <route default>
    <h1>404 Not Found</h1>
  </route>
</single-spa-router>
```

```html
<single-spa-router>
  <route path="product-detail/:productId">
    <div class="product-content">
      <route path="reviews"></route>
      <route path="images"></route>
    </div>
    <!-- The reviews and images routes are siblings, since they share a nearest parent route -->
    <!-- The default route will activate when the URL does not match reviews or images -->
    <route default>
      <h1>Unknown product page</h1>
    </route>
  </route>
</single-spa-router>
```

### 相关 API

#### constructRoutes

将布局定义转换为已解析路由对象

```js
import { constructRoutes } from 'single-spa-layout';
const htmlTemplate = document.querySelector('#single-spa-template')
const layoutData = {
  props: {
    authToken: "78sf9d0fds89-0fysdiuf6sf8",
    loggedInUser: fetch('/api/user')
  },
  loaders: {
    mainContent: `<img src="loading.gif">`,
    // A single-spa parcel config
    topNav: singleSpaReact({...})
  }
};
const resolvedRoutes = constructRoutes(htmlTemplate, layoutData)
```

#### constructApplications

将 resolvedRoute 转换成 Single-SPA 应用注册对象

```js
import { constructRoutes, constructApplications } from 'single-spa-layout';
import { registerApplication } from 'single-spa';
const resolvedRoutes = constructRoutes(...)
const applications = constructApplications({
  routes: resolvedRoutes,
  loadApp: (app) => System.import(app.name)
})
applications.forEach(registerApplication);
```

#### constructLayoutEngine

将 resolvedRoutes 和 applications 转换成一个 layoutEngine 对象

```js
import { constructRoutes, constructApplications, constructLayoutEngine } from 'single-spa-layout';
import { registerApplication, start } from 'single-spa';
const resolvedRoutes = constructRoutes(...);
const applications = constructApplications(...);
const layoutEngine = constructLayoutEngine({routes: resolvedRoutes, applications: applications});
layoutEngine.isActive(); // true
layoutEngine.deactivate();
layoutEngine.activate();
applications.forEach(registerApplication);
start();
```

### matchRoute

```js
import { constructRoutes, matchRoute } from 'single-spa-layout';
const resolvedRoutes = constructRoutes(...);
const settingsRoutes = matchRoute(resolvedRoutes, "/settings")
const dashboardRoutes = matchRoute(resolvedRoutes, "/dashboard")
```

## 配合 Vue 使用

`vue add single-spa`
`npm install systemjs-webpack-interop -S`

在项目根目录新建`set-public-path.js`

```js
import { setPublicPath } from "systemjs-webpack-interop";
setPublicPath("appName");
```

将应用入口改为：

```js
// main.js
const vueLifecycles = singleSpaVue({...})
export const mount = props => vueLifecycles.mount(props).then(instance => {
  // do what you want with the Vue instance
  ...
})
```

注意：对于**Vue2**，改成以下内容：

```js
import "./set-public-path";
import Vue from "vue";
import App from "./App.vue";
import router from "./router";
import singleSpaVue from "single-spa-vue";
const vueLifecycles = singleSpaVue({
  Vue,
  appOptions: {
    render(h) {
      return h(App);
    },
    router,
  },
});
export const bootstrap = vueLifecycles.bootstrap;
export const mount = vueLifecycles.mount;
export const unmount = vueLifecycles.unmount;
```

对于**Vue3**，改成以下内容：

```js
import "./set-public-path";
import { h, createApp } from "vue";
import singleSpaVue from "../lib/single-spa-vue.js";
import App from "./App.vue";
const vueLifecycles = singleSpaVue({
  createApp,
  appOptions: {
    render() {
      return h(App, {
        props: {
          // single-spa props are available on the "this" object. Forward them to your component as needed.
          // https://single-spa.js.org/docs/building-applications#lifecyle-props
          name: this.name,
          mountParcel: this.mountParcel,
          singleSpa: this.singleSpa,
        },
      });
    },
  },
});
export const bootstrap = vueLifecycles.bootstrap;
export const mount = vueLifecycles.mount;
export const unmount = vueLifecycles.unmount;
```

传递 Props：

```js
// main.js
const vueLifecycles = singleSpaVue({
  Vue,
  appOptions: {
    render(h) {
      return h(App, {
        props: {
          mountParcel: this.mountParcel,
          otherProp: this.otherProp,
        },
      });
    },
    router,
    el: "#a", // 指定挂载DOM元素
  },
});
```

```vue
// App.vue
<template>
  <button>{{ otherProp }}</button>
</template>
<script>
export default {
  props: ["mountParcel", "otherProp"],
};
</script>
```

依赖共享：

```js
// vue.config.js使用vue-cli的情况
module.exports = {
  chainWebpack: (config) => {
    config.externals(["vue", "vue-router"]);
  },
};

// webpack.config.js
module.exports = {
  externals: ["vue", "vue-router"],
};
```

## 配合 React 使用

`npm install --save single-spa-react`

入口改为：

```js
import React from "react";
import ReactDOM from "react-dom";
import rootComponent from "./path-to-root-component.js";
// 注意 Singlespacontext 是一个为react@16.3(如果可用的话)提供的上下文，包含了 singleSpa props
import singleSpaReact, { SingleSpaContext } from "single-spa-react";
const reactLifecycles = singleSpaReact({
  React,
  ReactDOM,
  rootComponent,
  errorBoundary(err, info, props) {
    // https://reactjs.org/docs/error-boundaries.html
    return <div>This renders when a catastrophic error occurs</div>;
  },
});
export const bootstrap = reactLifecycles.bootstrap;
export const mount = reactLifecycles.mount;
export const unmount = reactLifecycles.unmount;
```

#### SingleSpaContext 与 Parcels

```js
import Parcel from 'single-spa-react/parcel'
import * as parcelConfig from './my-parcel.js'
// config 必需. The parcel will be mounted inside of the
// of a div inside of the react component tree
<Parcel
  config={parcelConfig}
  wrapWith="div"
  handleError={err => console.error(err)}
  customProp1="customPropValue2"
  customProp2="customPropValue2"
/>
// If you pass in an appendTo prop, the parcel will be mounted there instead of
// to a dom node inside of the current react component tree
<Parcel
  config={parcelConfig}
  wrapWith="div"
  appendTo={document.body}
/>
// You can also pass in a "loading function" as the config.
// The loading function must return a promise that resolves with the parcel config.
// The parcel will be mounted once the promise resolves.
<Parcel
  config={() => import('./my-parcel.js')}
  wrapWith="div"
/>
// If you are rendering the Parcel component from a single-spa application, you do not need to pass a mountParcel prop.
// But if you have a separate react component tree that is not rendered by single-spa-react, you **must** pass in a mountParcel prop
// In general, it is preferred to use an application's mountParcel function instead of the single-spa's root mountParcel function,
// so that single-spa can keep track of the parent-child relationship and automatically unmount the application's parcels when the application
// unmounts
<Parcel
  mountParcel={singleSpa.mountParcel}
  config={parcelConfig}
  wrapWith="div"
/>
// Add styles to wrapWith element.
<Parcel
  config={parcelConfig}
  wrapWith="div"
  wrapStyle={{ background: 'black' }}
/>
```
