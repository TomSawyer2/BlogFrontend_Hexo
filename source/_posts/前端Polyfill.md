---
title: 前端Polyfill
date: 2022-02-07 13:20:00
categories:
- JavaScript
- 浏览器
- 学习笔记
tags:
- JavaScript
- 浏览器
- 学习笔记
---

# 前端 Polyfill

## 简介

前端由于各类浏览器的存在需要对一些操作进行保底，尤其是 IE，解决方案通常有三种：手动打补丁、根据覆盖率自动打补丁、根据浏览器特性自动打补丁

## 手动打补丁

找到不支持的方法，手动加上该方法的实现

优点：最小化引入，不会有冗余代码，性能好；
缺点：手动导入不易维护

## 根据覆盖率自动打补丁

相关依赖：@babel/preset-env、@babel/plugin-transform-runtime、core-js、@babel/polyfill

使用方法：

1. 在应用入口`import 'core-js'`；
2. 使用@babel/preset-env 指定 useBuiltIns、core-js 以及根据应用确定的 targets；

```js
{
  "presets": [
    [
      "@babel/preset-env",
      {
        "useBuiltIns": "entry",
        "corejs": 3,
        "targets": {
          "chrome": 58
        }
      }
    ],
    "@babel/preset-react"
  ]
}
```

3. 引入@babel/plugin-transform-runtime 重用方法，减少打包体积。

## 根据浏览器特性自动打补丁

Polyfill.io 可以根据浏览器的版本自动识别需要的 Polyfill 并返回

引入：`<script src="https://polyfill.io/v3/polyfill.js?features=Promise"></script>`
