---
title: UmiJS
date: 2022-03-03 13:20:00
categories:
- React
- Umi
- 学习笔记
tags:
- React
- Umi
- 学习笔记
---

# UmiJS

## 简介

Umi 是基于 React 的前端框架，集成了大量的成熟插件，面向业务开箱即用

## 启动项目

```bash
mkdir myapp && cd myapp
yarn create @umijs/umi-app
yarn
yarn start
```

## 项目打包与本地验证

```bash
yarn build

yarn global add serve
serve ./dist
```

## 目录结构

**在`/src`目录下**

`pages`目录中放置路由组件
`layouts`目录中放置约定式路由时的全局布局文件
`.umi`是临时目录，不要提交到 git
`app.ts`运行时配置文件
`global.css`是全局样式

**在`/config`目录下**

`config.ts`是全局配置文件
`routes.ts`是路由配置文件

## 路由

### 配置式路由

配置式路由即通过`routes.ts`进行配置的路由

**路由跳转**

```ts
history.push("/list?a=b");
history.push({
  pathname: "/list",
  query: {
    a: "b",
  },
});
// 回到上一个路由
history.goBack();
```

**Link 组件**

可实现点击跳转到对应地址的功能

```ts
import { Link } from "umi";

export default () => (
  <div>
    <Link to="/users">Users Page</Link>
  </div>
);
```

### 约定式路由

约定式路由是不通过配置文件，直接解析`pages`目录下文件形成的路由

**动态路由**

`[id].tsx`会被解析为`/:id`

**动态可选路由**

`[id$].tsx`会被解析为`:id?`

**嵌套路由**

`_layout.tsx`存在时会在当前目录下生成嵌套路由，以`_layout.tsx`为核心，该文件需要返回一个 React 组件，并通过`props.children`渲染子组件

**全局 layout**

`/src/layouts/index.tsx`即全局 layout，返回一个 React 组件，并通过`props.children`渲染子组件

**权限路由**

通过`wrappers`达成效果

```ts
import React from "react";

function User() {
  return <>user profile</>;
}

User.wrappers = ["@/wrappers/auth"];

export default User;
```

```ts
// /wrappers/auth
import { Redirect } from "umi";

export default (props) => {
  const { isLogin } = useAuth();
  if (isLogin) {
    return <div>{props.children}</div>;
  } else {
    return <Redirect to="/login" />;
  }
};
```

即可通过`useAuth`实现权限校验

## 插件

**id 与 key**

id 是路径的简写，key 是简化后用于配置的唯一值

**启用插件**

umi 会自动检测`package.json`中的插件并注册，也可以在`presets`和`plugins`中注册，也可以通过环境变量`UMI_PRESETS`与`UMI_PLUGINS`注册

**检测插件**

```bash
umi plugin list
umi plugin list --key
```

```ts
api.hasPlugins(pluginId[])
api.hasPresets(pluginId[])
```

**禁用插件**

```ts
export default {
  mock: false,
};
```

```ts
api.skipPlugins(pluginId[])
```

**配置插件**

```ts
export default {
  mock: { exclude: ["./foo"] },
};
```

## 页面跳转

**声明式**

通过 Link 组件使用，具体用法见配置式路由的 Link 组件

**命令式**

```ts
import { history } from 'umi';

function goToListPage() {
  history.push('/list');
}

export default (props) => (
  <Button onClick={()=>props.history.push('/list');}>Go to list page</Button>
);
```

## 环境变量

**通过命令添加**

```bash
cross-env PORT=3000 yarn run dev
```

**在`.env`中定义**

```env
PORT=3000
```

## 按需加载

**启动按需加载**

```ts
export default {
  dynamicImport: {},
};
```

**封装与使用**

```ts
import { dynamic } from "umi";

export default dynamic({
  loader: async function () {
    // 这里的注释 webpackChunkName 可以指导 webpack 将该组件 HugeA 以这个名字单独拆出去
    const { default: HugeA } = await import(
      /* webpackChunkName: "external_A" */ "./HugeA"
    );
    return HugeA;
  },
});

import React from "react";
import AsyncHugeA from "./AsyncHugeA";

// 像使用普通组件一样即可
// 1. 异步加载该模块的 bundle
// 2. 加载期间 显示 loading（可定制）
// 3. 异步组件加载完毕后，显示异步组件
export default () => {
  return <AsyncHugeA />;
};
```

## 快速刷新

本地开发环境下修改参数时无关内容保持不变，包括表单

**启动 fastFresh**

```ts
fastRefresh: {
}
```

## MFSU

基于 webpack5 特性 Module Federation 的打包提速方案，可以大幅减少热更新的时间
