---
title: IntersectionObserver
date: 2022-01-10 13:05:00
categories:
- HTML
- JavaScript
- 学习笔记
tags:
- HTML
- JavaScript
- 学习笔记
---

# IntersectionObserver API

通过这一 API 可以实现无限滚动等等效果。

## 创建

```js
var io = new IntersectionObserver(callback, option);
```

## 使用

```js
// 开始观察
io.observe(document.getElementById("xxx"));
// 停止观察
io.unobserve(el);
// 关闭观察器
io.disconnect();
```

如果需要同时观察多个结点需要多次使用`observe`。

### callback

回调函数执行两次，一次在开始可见，一次在不可见。

```js
var io = new IntersectionObserver((entries) => {
  console.log(entries);
});
```

`entries`是一个数组，元素是被观察的对象。

### options 属性：

- `threshold:[0, 0.25, 0.5]`当目标元素显示这些值时触发回调。
- `root: el`指定元素滚动相对的父结点。
- `rootMargin:"20px 10px 0px 10px"`指定根元素的 margin。

## 注意点

是异步的，优先级低。
