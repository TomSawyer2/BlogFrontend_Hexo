---
title: 2021秋Dian Web前端新人任务书
date: 2021-10-26 23:04:00
categories:
- 日志
tags:
- 日志
---

# 前端学习路线

## 前言

按照此路线完全学习大概需要 1-1.5 个月，学习开始前请根据自己的基础选择适合自己的起点。

**Level0 内容的学习请与其他部分的学习同步进行，所以请大家直接从 Level1 开始学习~**

总体学习目标：基本掌握 HTML、JS、CSS，对 Vue 有基本的了解，会使用 Uniapp 构建项目。

各阶段验收：时间待定，除了规定的要求外还会针对学习的内容进行相关的提问。

## Level0 知识储备

学习时长：不限

学习目标：掌握使用 Markdown 书写文档，学习使用 Git 管理自己的代码，掌握计算机网络基础部分，了解 NodeJS 中 npm 相关知识

学习资源：[Markdown 教程](https://www.runoob.com/markdown/md-tutorial.html)、[Git 教程](https://www.liaoxuefeng.com/wiki/896043488029600)、[图解 git flow 开发流程](https://zhuanlan.zhihu.com/p/198066289)

验收要求：

- 使用 Markdown 记录以后各个任务学习日志（记录日志是一个很好的习惯）；
- 使用 Git 管理以后各个任务的代码；
- 计网相关知识会在各个部分的验收中以问答形式穿插进行。

注意：

1. 这部分的学习成果**不进行**书面形式的检查，且这部分的学习应该与之后部分的学习同步进行。希望大家能把这些知识用在今后的工作中~
2. Markdown 和 Git 均不需要学习到很深的部分，以 Git 为例，只需要掌握创建仓库、commit、push、开分支、合并分支、解决冲突、提交 PR、版本回退等等基本操作即可。
3. 计网部分需要了解但不仅仅限于以下部分：掌握 HTTP 请求的几种常用方法，了解 HTTP 常用的请求头，了解 HTTP 常见的返回码，了解跨域产生的原因以及解决方案，了解 Web 认证相关知识（token）。

## Level1 HTML+CSS

学习时长：5 天

学习目标：对 HTML 和 CSS 有基本的了解，能利用基本的布局方式构建静态页面。

学习资源：[HTML 教程](https://www.w3school.com.cn/html/index.asp)、[JavaScript 教程](https://www.w3school.com.cn/js/index.asp)、[CSS 教程](https://www.w3school.com.cn/css/index.asp)、[Flex 布局](http://www.ruanyifeng.com/blog/2015/07/flex-grammar.html)、[Grid 网格布局](http://www.ruanyifeng.com/blog/2019/03/grid-layout-tutorial.html)

验收要求：

- 使用 HTML 和 CSS 构建一个自我介绍的静态页面（使用合适的布局方式使界面尽可能美观）

注意：

1. HTML 部分的学习包括 HTML5 部分。
2. CSS 部分的学习不需要过深。

## Level2 JavaScript

学习时长：5 天

学习目标：对 JS 的基本语法以及 ES6 标准有基本的了解，能够利用 JS 实现一些基本的算法，对 DOM 以及 BOM 有基本的了解并会进行使用

学习资源：[JavaScript 教程](https://www.runoob.com/js/js-tutorial.html)、[HTML DOM 教程](https://www.runoob.com/htmldom/htmldom-tutorial.html)、[HTML BOM 教程](https://www.runoob.com/js/js-window.html)

验收要求：

- 使用之前学习的内容完成如下游戏：

  - 玩家为“X”和“O”，在下棋过程中轮流切换；
  - 一方胜利时，显示胜利方名字，游戏结束；
  - 效果参考：https://codepen.io/gaearon/pen/LyyXgK?editors=0010
  - <img src="http://tomsawyer2.xyz/pics/tiktoc.png" alt="tictoc" style="zoom:30%;" />

## Level3 框架初探

学习时长：3 天

学习目标：能够使用 Vue 构建自己的项目

学习资源：[Vue.js](https://cn.vuejs.org/v2/guide/)、[Vue-Cli 详细教程](https://www.cnblogs.com/fengzhenxiong/p/10213198.html)

验收要求：

- 使用 Vue 还原 Level2 中实现的小游戏，体验框架开发与原生 JS 开发的不同。

注意：

1. 推荐使用 Vue-Cli 构建项目；
2. 在这个层次的学习中不要求路由、VueX 等等使用。

## Level4 框架深入

学习时长：10 天

学习目标：熟练掌握 Vue 的使用，熟练掌握组件库的使用（选择一个即可）

学习资源：[Vue.js](https://cn.vuejs.org/v2/guide/)、[Vue Router](https://router.vuejs.org/zh/guide/)、[Vuex](https://vuex.vuejs.org/zh/)、[Axios](https://cn.vuejs.org/v2/cookbook/using-axios-to-consume-apis.html)、[ElementUI](https://element.eleme.cn/#/zh-CN/component/installation)、[Ant Design Vue](https://www.antdv.com/docs/vue/introduce-cn/)、[Vuetify](https://vuetifyjs.com/en/)

验收要求：

- 实现一个个人博客，功能要求如下：
  - 查看所有文章
  - 查看单篇文章
  - 添加文章
  - 删除文章
  - 编辑文章
  - ...

注意：

1. 个人博客相关接口会由后端同学提供；
2. 请使用 Vue Router 配置路由，VueX 管理状态，Axios 收发请求；
3. 请自行学习框架开发的相关规范，在这部分 Level 结束后也会进行统一的讲解。

## Level5 微信小程序

学习时长：7 天

学习目标：了解微信提供的基本接口，能够使用 Uniapp 进行微信小程序的开发

学习资源：[微信开放文档](https://developers.weixin.qq.com/miniprogram/dev/framework/)、[Uni-App](https://uniapp.dcloud.io/)、[Vant Weapp 组件库](https://vant-contrib.gitee.io/vant-weapp/#/home)、[ColorUI 组件库](http://docs.xzeu.com/#/info/快速开始/快速布署)

验收要求：

- 将 Level5 中实现的 Web 端个人博客移植到小程序端。

注意：

1. 请使用 UniApp 进行开发；
2. 推荐使用 Vant 或者 ColorUI 组件库；
3. 开发环境推荐 HBuilderX+微信开发者工具，AppID 使用测试号，展示在开发者工具的模拟器进行即可。

## 结语

如果你坚持到了这里，那么恭喜你，已经能够使用 Vue 以及 UniApp 构建一个属于自己的 SPA。接下来，你可以选择继续深入之前的学习，也可以选择拓宽自己的知识面。你可以深入学习 Vue 直至 Vue.js 的源码，也可以选择学习其他的框架比如 React、Angular 等等，你可以了解各种预处理器比如 SASS，也可以了解使用 NodeJS 实现简单的后端。前端的世界非常广阔，在技术的学习过程中你可以收获到无穷无尽的快乐。可以说前面的学习路线仅仅只是 Web 开发的冰山一角，想在 Web 上有更深入了解害得靠今后不断努力~

——何某某 2021.10.02
