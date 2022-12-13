---
title: JSBridge
date: 2022-01-16 13:20:00
categories:
- JavaScript
- 学习笔记
tags:
- JavaScript
- 学习笔记
---

# JSBridge

## 简介

JSBridge 是在移动端开发时为 JS 提供双向 native 功能的接口。

## 实现原理

JS 运行在独立的环境中，例如 Webkit，因此与 native 的每次调用都可看做 RPC 调用（远程过程调用）。因此前端可看做 RPC 的客户端，native 可看做 RPC 的服务器端。

## 通信原理

### JS 调用 native

1. 注入 api

   通过 WebView 的相关接口，向 JS 的 window 直接注入对象和方法。在 JS 调用相关接口时直接执行对应 native 代码。

2. 拦截 URL SCHEME

   **URL SCHEME：**app 之间互相调用的类似 URL 的链接，但 protocol 和 host 是自定义的。

   比如说手机端网页浏览知乎时显示打开 APP，点击后就会自动跳转到知乎 APP 的对应文章，其中传递信息的就是 URL SCHEME。

   Web 端发送 URL SCHEME 请求后，native 拦截请求并根据其中的参数进行相关操作。

   缺陷：耗时、URL 长度受限。

### native 调用 JS

执行拼凑好的 JS 代码，注意方法要挂载在 window 上。

## JSBridge 接口实现

模型：

```js
window.JSBridge = {
  // 调用 Native
  invoke: function (bridgeName, data) {
    // 判断环境，获取不同的 nativeBridge
    nativeBridge.postMessage({
      bridgeName: bridgeName,
      data: data || {},
    });
  },
  receiveMessage: function (msg) {
    var bridgeName = msg.bridgeName,
      data = msg.data || {};
    // 具体逻辑
  },
};
```

执行过程：

**JS->native**：接收 JS 信息->解析参数->根据 bridgeName 找到方法，将 data 传入执行->将返回值和回调函数返回前端。

**native->JS**：生成唯一的 responseId，存储句柄->与 data 一起发送给前端。

## JSBridge 引用

1. native 端注入

   直接执行桥的全部代码。

   **优点**：桥的版本与 native 容易保持一致。

   **缺点**：注入时机不确定，需要提供重试机制。

2. JS 端调用

   直接与 JS 一起运行。

   **优点**：调用简单方便。

   **缺点**：版本兼容需保持一致。
