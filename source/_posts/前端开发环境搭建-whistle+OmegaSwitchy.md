---
title: 前端开发环境搭建-whistle+OmegaSwitchy
date: 2022-12-23 23:44:00
categories:
- 浏览器
- JavaScript
- 学习笔记
tags:
- 浏览器
- JavaScript
- 学习笔记
---

# 前端开发环境搭建-whistle+OmegaSwitchy

## 简介

在8月底的时候由于开发环境需要前端把`localhost`代理到域名下以实现cookie的共享，采用了`nginx`+`docker`的方案。然而这种方案显然是比较麻烦的，有没有比较简单一点的办法呢？这篇文章的`whistle`+`OmegaSwitchy`就是比较简单的替代方案。

## whistle

`whistle`是一个`node`的库，可以用来实现本地的代理转发。`whistle`的安装和使用非常简单，只需要执行`npm install -g whistle`即可安装，然后在项目根目录下执行`w2 start`即可启动。启动后可以在`localhost:8899`访问到`whistle`的管理页面，可以在这里配置代理规则。

配置示例：

```
127.0.0.1:8080 http://www.baidu.com
```

这样就可以将`localhost:8080`代理到`http://www.baidu.com`。

## OmegaSwitchy

现在我们已经可以把`localhost`代理到域名下，但本地开发的时候浏览器肯定也得访问域名，不然`cookie`还是不方便注入。因此，使用OmegaSwitchy这个插件把浏览器域名代理到`localhost:8899`即可。

## 流程图

![流程图](https://blog.tomsawyer2.xyz/pics/proxy_network.jpg)

## 效果

项目跑起来之后，可以直接在浏览器中用域名访问开发环境进行开发
