---
title: PWA
date: 2022-02-04 13:20:00
categories:
- Vue
- PWA
- 学习笔记
tags:
- Vue
- PWA
- 学习笔记
---

# PWA

## 简介

Progressive Web App 即渐进式 Web 应用，可以将一个 Web 页面转换为桌面端应用，同时加入离线缓存、消息通知等原生桌面端应用具有的功能。

注：此博客已经配置 PWA，可以在 URL 栏右侧选择安装。

## 配置

如果用`vue-cli`生成项目，则可选择使用`vue add pwa`来自动配置 PWA；

如果手动配置，则按以下步骤：

1. `npm install -g vue-asset-generate`；
2. `vue-asset-generate --no-manifest -a src/assets/logo.png -o public/img/icons`生成各类大小的图标；
3. 在`main.js`中加入

```js
if ("serviceWorker" in navigator) {
  navigator.serviceWorker.register("/service-worker.js", {
    scope: "/",
  });
}
```

4. 在`/public`文件夹内加入`service-worker.js`，并写入：

```js
self.addEventListener("fetch", () => {});
```

5. 同时加入`manifest.webmanifest`，写入：

```js
{
    "name": "博客 - TomSawyer2",
    "short_name": "博客",
    "theme_color": "#66CCFF",
    "background_color": "#66CCFF",
    "description": "博客",
    "display": "standalone",
    "display_override": ["minimal-ui", "standalone", "fullscreen"],
    "start_url": "/",
    "scope": "/",
    "icons": [
        {
            "src": "/img/icons/android-chrome-192x192.png",
            "sizes": "192x192",
            "type": "image/png",
            "purpose": "any"
        },
        {
            "src": "/img/icons/android-chrome-maskable-192x192.png",
            "sizes": "192x192",
            "type": "image/png",
            "purpose": "maskable"
        },
        {
            "src": "/img/icons/android-chrome-512x512.png",
            "sizes": "512x512",
            "type": "image/png",
            "purpose": "any"
        },
        {
            "src": "/img/icons/android-chrome-maskable-512x512.png",
            "sizes": "512x512",
            "type": "image/png",
            "purpose": "maskable"
        }
    ]
}
```

6. 在`index.html`的 head 部分加入：

```html
<meta name="theme-color" content="#66CCFF" />
<meta name="apple-mobile-web-app-capable" content="no" />
<link rel="icon" href="./favicon.ico" />
<link rel="apple-touch-icon" href="./img/icons/apple-touch-icon.png" />
<link
  rel="apple-touch-icon"
  sizes="57x57"
  href="./img/icons/apple-touch-icon-60x60.png"
/>
<link
  rel="apple-touch-icon"
  sizes="72x72"
  href="./img/icons/apple-touch-icon-60x60.png"
/>
<link
  rel="apple-touch-icon"
  sizes="76x76"
  href="./img/icons/apple-touch-icon-76x76.png"
/>
<link
  rel="apple-touch-icon"
  sizes="114x114"
  href="./img/icons/apple-touch-icon-120x120.png"
/>
<link
  rel="apple-touch-icon"
  sizes="120x120"
  href="./img/icons/apple-touch-icon-120x120.png"
/>
<link
  rel="apple-touch-icon"
  sizes="144x144"
  href="./img/icons/msapplication-icon-144x144.png"
/>
<link
  rel="apple-touch-icon"
  sizes="152x152"
  href="./img/icons/apple-touch-icon-152x152.png"
/>
<link
  rel="apple-touch-icon"
  sizes="180x180"
  href="./img/icons/apple-touch-icon-180x180.png"
/>
<link rel="manifest" href="/manifest.webmanifest" />
```

7. 打开项目即可看到 PWA 应用的效果。
