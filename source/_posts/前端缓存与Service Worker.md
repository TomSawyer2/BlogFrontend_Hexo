---
title: 前端缓存与Service Worker
date: 2022-01-24 13:20:00
categories:
- JavaScript
- 浏览器
- 学习笔记
tags:
- JavaScript
- 浏览器
- 学习笔记
---

# 前端缓存与 Service Worker

## 简介

前端的缓存方式比较多，主要有 http 缓存和浏览器缓存。

### http 缓存

Expires 请求的过期时间
Cache-Control 资源缓存多久
**前两者一起使用称为强缓存**
Last-Modified / If-Modified-Since 资源最后的修改时间，若前者大，则响应这个资源，为 200；若前者小于等于后者，则响应 304，不变
Etag / If-None-Match 根据文件内容计算文件是否改变，同上

### 浏览器缓存

Storage 包括 cookie localStorage sessionStorage
一些成熟的页面会将 JS 和 CSS 等不会变的文件直接放在 localStorage 里面

前端数据库包括 WebSql 和 IndexDB，前者已被废弃。

应用缓存主要通过 manifest 注册缓存文件，但由于同时缓存了 HTML 文件使得页面的更新只能通过 manifest 文件的版本号决定，因此已被废弃。

## Service Worker

特点：缓存，但独立于当前网页进程，在网页发起请求时代理缓存文件。

由于要用到请求拦截，因此基于 HTTPS 来保证安全，当然，localhost 也行。

sw 的生命周期如图：
![Description](https://blog.tomsawyer2.xyz/pics/640.webp)

### 使用

**注册**

```js
(function () {
  if ("serviceWorker" in navigator) {
    navigator.serviceWorker.register("./sw.js");
  }
})();
```

```js
"serviceWorker" in navigator &&
  window.addEventListener("load", function () {
    var e =
      location.pathname.match(/\/news\/[a-z]{1,}\//)[0] +
      "article-sw.js?v=08494f887a520e6455fa";
    navigator.serviceWorker
      .register(e)
      .then(function (n) {
        n.onupdatefound = function () {
          var e = n.installing;
          e.onstatechange = function () {
            switch (e.state) {
              case "installed":
                navigator.serviceWorker.controller
                  ? console.log("New or updated content is available.")
                  : console.log("Content is now available offline!");
                break;
              case "redundant":
                console.error(
                  "The installing service worker became redundant."
                );
            }
          };
        };
      })
      .catch(function (e) {
        console.error("Error during service worker registration:", e);
      });
  });
```

在注册时指定路径：`navigator.serviceWorker.register('/topics/sw.js');`

**安装监听**

```js
//service worker安装成功后开始缓存所需的资源
var CACHE_PREFIX = "cms-sw-cache";
var CACHE_VERSION = "0.0.20";
var CACHE_NAME = CACHE_PREFIX + "-" + CACHE_VERSION;
var allAssets = ["./main.css"];
self.addEventListener("install", function (event) {
  //调试时跳过等待过程
  self.skipWaiting();

  // Perform install steps
  //首先 event.waitUntil 你可以理解为 new Promise，
  //它接受的实际参数只能是一个 promise，因为,caches 和 cache.addAll 返回的都是 Promise，
  //这里就是一个串行的异步加载，当所有加载都成功时，那么 SW 就可以下一步。
  //另外，event.waitUntil 还有另外一个重要好处，它可以用来延长一个事件作用的时间，
  //这里特别针对于我们 SW 来说，比如我们使用 caches.open 是用来打开指定的缓存，但开启的时候，
  //并不是一下就能调用成功，也有可能有一定延迟，由于系统会随时睡眠 SW，所以，为了防止执行中断，
  //就需要使用 event.waitUntil 进行捕获。另外，event.waitUntil 会监听所有的异步 promise
  //如果其中一个 promise 是 reject 状态，那么该次 event 是失败的。这就导致，我们的 SW 开启失败。
  event.waitUntil(
    caches.open(CACHE_NAME).then(function (cache) {
      console.log("[SW]: Opened cache");
      return cache.addAll(allAssets);
    })
  );
});
```

**激活**
**首次安装 sw：** 在安装后直接进入激活环节；
**更新 sw：** 新的 sw 先进入 waiting 阶段，等老的 sw 被 terminated 后再激活。

terminated 的几种方式：关闭浏览器一段时间、手动清除 sw、在 sw 安装的时候直接跳过 waiting 阶段。

```js
//service worker安装成功后开始缓存所需的资源
self.addEventListener("install", function (event) {
  //跳过等待过程
  self.skipWaiting();
});
```

激活时可以更新存储在 Cache 里的 key 和 value

```js
var CACHE_PREFIX = "cms-sw-cache";
var CACHE_VERSION = "0.0.20";
/**
 * 找出对应的其他key并进行删除操作
 * @returns {*}
 */
function deleteOldCaches() {
  return caches.keys().then(function (keys) {
    var all = keys.map(function (key) {
      if (
        key.indexOf(CACHE_PREFIX) !== -1 &&
        key.indexOf(CACHE_VERSION) === -1
      ) {
        console.log("[SW]: Delete cache:" + key);
        return caches.delete(key);
      }
    });
    return Promise.all(all);
  });
}
//sw激活阶段,说明上一sw已失效
self.addEventListener("activate", function (event) {
  event.waitUntil(
    // 遍历 caches 里所有缓存的 keys 值
    caches.keys().then(deleteOldCaches)
  );
});
```

**idle**
一般不可见，sw 处于闲置状态，浏览器会轮询并释放占用的资源。

**fetch**
所有缓存都在这个阶段，用于拦截代理所有指定的请求。

```js
//监听浏览器的所有fetch请求，对已经缓存的资源使用本地缓存回复
self.addEventListener("fetch", function (event) {
  event.respondWith(
    caches.match(event.request).then(function (response) {
      //该fetch请求已经缓存
      if (response) {
        return response;
      }
      return fetch(event.request);
    })
  );
});
```

### 缺点

使用时需要在 Cache 中寻找资源，如果找不到再请求资源，但比较麻烦。

## Workbox

### 简介

workbox 是对 sw 的封装，可以更方便地使用 sw。

### 配置

在项目的`sw.js`文件中引入 workbox 的官方 js

```js
//关闭控制台中的输出
workbox.setConfig({ debug: false });

//设置缓存cachestorage的名称
workbox.core.setCacheNameDetails({
  prefix: "edu-cms",
  suffix: "v1",
});
```

### precache

对应的是在 installing 阶段进行读取缓存的操作，可以确定缓存文件的时间和长度，以及在不进入网络的情况下将其提供给浏览器。

首次加载 Web 应用程序时，Workbox 会下载指定的资源，并存储具体内容和相关修订的信息在 indexedDB 中。
当资源内容和 sw.js 更新后，Workbox 会去比对资源，然后将新的资源存入 Cache，并修改 indexedDB 中的版本信息。

注意：这种方式的缓存都需要配置一个版本号。在修改 sw.js 时，对应的版本也需要变更。

### runtimecache

是在 install 之后，activated 和 fetch 阶段做的事情。

#### Stale While Revalidate

请求的路由有对应的 Cache 缓存结果就直接返回，在返回 Cache 缓存结果的同时会在后台发起网络请求拿到请求结果并更新 Cache 缓存，如果本来就没有 Cache 缓存的话，直接就发起网络请求并返回结果。

可以进行配置在空闲时候进行请求：

```js
workbox.routing.registerRoute(
  new RegExp("https://edu-cms.nosdn.127.net/topics/"),
  workbox.strategies.staleWhileRevalidate({
    //cache名称
    cacheName: "lf-sw:static",
    plugins: [
      new workbox.expiration.Plugin({
        //cache最大数量
        maxEntries: 30,
      }),
    ],
  })
);
```

#### Network First

优先尝试拿到网络请求的返回结果，如果拿到网络请求的结果，就将结果返回给客户端并且写入 Cache 缓存，如果网络请求失败，那最后被缓存的 Cache 缓存结果就会被返回到客户端。用于保底。

```js
//自定义要缓存的html列表
var cacheList = ["/Hexo/public/demo/PWADemo/workbox/index.html"];
workbox.routing.registerRoute(
  //自定义过滤方法
  function (event) {
    // 需要缓存的HTML路径列表
    if (event.url.host === "localhost:63342") {
      if (~cacheList.indexOf(event.url.pathname)) return true;
      else return false;
    } else {
      return false;
    }
  },
  workbox.strategies.networkFirst({
    cacheName: "lf-sw:html",
    plugins: [
      new workbox.expiration.Plugin({
        maxEntries: 10,
      }),
    ],
  })
);
```

#### Cache First

匹配到请求之后直接从 Cache 缓存中取得结果，如果 Cache 缓存中没有结果，那就会发起网络请求，拿到网络请求结果并将结果更新至 Cache 缓存，并将结果返回给客户端。用于变动不多的数据。

```js
workbox.routing.registerRoute(
  new RegExp("https://edu-image.nosdn.127.net/"),
  workbox.strategies.cacheFirst({
    cacheName: "lf-sw:img",
    plugins: [
      //如果要拿到域外的资源，必须配置
      //因为跨域使用fetch配置了
      //mode: 'no-cors',所以status返回值为0，故而需要兼容
      new workbox.cacheableResponse.Plugin({
        statuses: [0, 200],
      }),
      new workbox.expiration.Plugin({
        maxEntries: 40,
        //缓存的时间
        maxAgeSeconds: 12 * 60 * 60,
      }),
    ],
  })
);
```

#### Network Only

直接强制使用正常的网络请求，并将结果返回给客户端，适合实时性高的数据。

#### Cache Only

直接使用 Cache 缓存的结果，并将结果返回给客户端，适合静态资源。
