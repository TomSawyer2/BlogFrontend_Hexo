---
title: NuxtJS体验
date: 2022-08-25 13:20:00
categories:
- Vue
- JavaScript
- CSS
- 学习笔记
tags:
- Vue
- JavaScript
- CSS
- 学习笔记
---

# NuxtJS 体验

## 简介

作为 Vue 中标志性的脚手架，NuxtJS 对标的是 React 中的 NextJS；同时，NuxtJS 提供了开箱即用的 SSR，可以方便地实现服务端渲染

项目源代码仓库：[ColorX - Github](https://github.com/TomSawyer2/ColorX)
线上部署地址：[ColorX - 中国传统色彩](https://color.tomsawyer2.xyz)

## 启动项目

```bash
pnpm dlx nuxi init nuxt-app
cd nuxt-app
pnpm i
pnpm run dev
```

## 路由

NuxtJS 采用约定式路由，和 umi 等等框架非常类似

## 引入插件

**以`Element-plus`为例**

```ts
// nuxt.config.ts
build: {
  transpile: lifecycle === 'build' || lifecycle === 'generate' ? ['element-plus'] : [],
},
components: true,
vueuse: {
  ssrHandlers: true,
},
```

```ts
// app.vue
<script setup>
import { ID_INJECTION_KEY } from 'element-plus'

provide(ID_INJECTION_KEY, {
  prefix: 100,
  current: 0,
})
</script>
```

**注：** 也可在`/plugins`中注册插件，并在`nuxt.config.ts`中进行配置，但需注意不能直接`Vue.use`或者`Vue.component`

## 打包

NuxtJS 提供两种打包方式

`build`生成`.output`文件夹，内部有静态文件和服务端渲染的脚本
`generate`生成`dist`文件夹，内部只有静态文件，类似于 SPA 的渲染方式

## 部署

### SPA

直接 Nginx 一波反向代理即可

### SSR

**方案一：** 在服务器上起一个 pm2 守护进程运行`.output/server`中的`.mjs`文件
**方案二：** 采用 Vercel，对 Github 对应仓库进行监听，实现自动部署

## 遇到的一些问题

### 部署后显示`isCE is not defined`

这种情况出现在组件中使用`slot`处，原因是 Vue 的版本内部不统一

**解决方案：** 采用如上方式引入 Element-plus

### Vercel 打包时间<10s，但没有产物

网上很多关于 NuxtJS+Vercel 的教程都是**坑**，实际上 Nuxt3**根本不需要任何**对 Vercel 的配置文件（比如`vercel.json`、`now.json`）就可以实现完美的部署

**解决方案：** 删除项目中有关 Vercel 的配置文件

### 项目未启动时 ts 报错

由于 NuxtJS 中 tsconfig 是在项目启动时动态生成的（根目录下的`tsconfig.json`只是个指向`.nuxt`的指针），因此未启动项目时自然是没有对应配置的

**解决方案：** 启动项目

### 项目在 Vercel 中构建时有关`tsconfig.json`报错

根目录中的`tsconfig.json`不应该有注释，而 NuxtJS 默认的`tsconfig.json`第二行有个注释

**解决方案：** 把`tsconfig.json`第二行的注释它删了

### 项目在 Vercel 中构建时采用`pnpm install`安装依赖有关`peerDependencies`报错

Vercel + NuxtJS3 的默认配置会采用`pnpm`进行依赖管理，但在自动部署的过程中不会安装`peerDependencies`，因此会导致依赖缺失

**解决方案：** 用`yarn`覆盖原有配置
