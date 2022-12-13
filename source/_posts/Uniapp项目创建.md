---
title: Uniapp项目创建
date: 2021-10-26 23:18:00
categories:
- 小程序
- Uniapp
- 学习笔记
tags:
- 小程序
- Uniapp
- 学习笔记
---

# Uniapp 微信小程序构建

## 前言

以前写过用 Uniapp 作为框架的小程序项目，但一直没有自己搭过 Uniapp 的微信小程序框架。此外，以前的项目每次都得用 HBuilderX 启动微信小程序模拟器，烦的批爆，所以这次项目自己搭了下。

## 使用 Vue-Cli 构建 Uniapp 默认模板

```bash
vue create -p dcloudio/uni-preset-vue my-project
```

由于某些懂得都懂的原因，启动项目奇慢无比，甚至经常出现 TimeOut 的情况。虽然 pingGitHub 的 ip 没啥问题，但下载还是遇到了不少麻烦，反复试了几次终于成功。

成功后直接用箭头上下选择模板即可，我选的是默认模板。

## 框架基本配置

到这一步之后项目就基本上起来了，目录结构与原生的 Vue 应用差不多，该用的规范都可以直接用上。

但在用 axios 请求时报错了，查阅资料得是 Uniapp 自身与 axios 的配合八太行，解决方法有两个：

1. 把所有请求换成 axios，干脆不用 axios；
2. 对`uni.request`方法进行封装：
   ```javascript
   // 自定义适配器来适配uniapp语法
   axios.defaults.adapter = function (config) {
     return new Promise((resolve, reject) => {
       var settle = require("axios/lib/core/settle");
       var buildURL = require("axios/lib/helpers/buildURL");
       uni.request({
         method: config.method.toUpperCase(),
         url:
           config.baseURL +
           buildURL(config.url, config.params, config.paramsSerializer),
         header: config.headers,
         data: config.data,
         dataType: config.dataType,
         responseType: config.responseType,
         sslVerify: config.sslVerify,
         complete: function complete(response) {
           // console.log("执行完成：", response)
           response = {
             data: response.data,
             status: response.statusCode,
             errMsg: response.errMsg,
             header: response.header,
             config: config,
           };
           settle(resolve, reject, response);
         },
       });
     });
   };
   ```
   前一种方法对用惯 axios 进行请求的同学肯定不太友好，而后一种方法可以完美解决问题，不过 ESLint 会报错找不到 uni，这时候只要重启一下项目就行。

## 组件库的引入

这里我用的是 Vant 的 Weapp 组件库，但在引入的时候遇到了一些麻烦。目前的做法是直接把组件库打包后的 dist 文件夹直接全部放在 src 文件夹内，之后考虑用 CDN 引入。
