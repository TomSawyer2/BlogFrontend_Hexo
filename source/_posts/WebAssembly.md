---
title: WebAssembly
date: 2022-02-05 13:20:00
categories:
- JavaScript
- WebAssembly
- 学习笔记
tags:
- JavaScript
- WebAssembly
- 学习笔记
---

# WebAssembly

## 简介

WebAssembly 简称 wasm，有一套完整语义，是体积小且加载快的二进制格式。可以使用非 JS 语言编写且能在浏览器中运行的技术，已于 19 年加入 W3C。

## 运行流程

JSX/TS -> Converter -> JS -> 浏览器
C/C++/Obj-C/Swift -> Compiler -> WASM -> 浏览器

## 优点

文件加载快、解析快、编译优化时间短、不需要重新优化、执行更快、垃圾回收效率高、安全

## C++与原生 JS 比较运行速度

```html
<script>
  function fib(x) {
    if (x <= 0) {
      return 0;
    }
    if (x <= 2) {
      return 1;
    }
    return fib(x - 1) + fib(x - 2);
  }
  console.time("init");
  var res = fib(40);
  console.timeEnd("init");
</script>
```

运行时长约为**900+ms**

相同情况下使用 C++运行

```cpp
#include <iostream>
#include <ctime>

using namespace std;

int fib(int x) {
    if (x <= 0) {
        return 0;
    } else if (x <= 2) {
        return 1;
    }
    return fib(x - 1) + fib(x - 2);
}

int main() {
    int t1, t2;
    t1 = clock();
    fib(40);
    t2 = clock();
    cout << t2 - t1 << "ms" << endl;
    return 0;
}
```

采用常规方式运行，运行时长为**500ms**；
开启 O4 优化，`g++ .\index.cpp -o c -O4 && .\c.exe`，运行时长为**100+ms**

## 将 C++转换为 wasm 并与 JS 同台竞技

[在线转换](http://mbebenita.github.io/WasmExplorer/)

将 C++代码中的`fib`函数转换为`.wasm`文件，
并将 html 代码改为如下：

```html
<script>
  fetch("./test.wasm")
    .then((response) => response.arrayBuffer())
    .then((bytes) => WebAssembly.compile(bytes))
    .then((mod) => {
      const instance = new WebAssembly.Instance(mod);
      const a = instance.exports;
      console.log(a);
      console.time("init");
      // var re = a.fib(40);
      console.timeEnd("init");
    });
</script>
```

运行时间**600+ms**，相比原生 JS 的**900+ms**快了不少
