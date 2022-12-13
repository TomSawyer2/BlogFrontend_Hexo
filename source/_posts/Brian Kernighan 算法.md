---
title: Brian Kernighan 算法
date: 2022-03-01 13:20:00
categories:
- 算法
- 学习笔记
tags:
- 算法
- 学习笔记
---

# Brian Kernighan 算法

[leetcode338.比特位计数](https://leetcode-cn.com/problems/counting-bits/)

```js
var countBits = function (n) {
  let arr = new Array(n + 1).fill(0);
  for (let i = 0; i <= n; i++) {
    arr[i] = count(i);
  }
  return arr;
};

var count = function (num) {
  let cnt = 0;
  while (num > 0) {
    num &= num - 1;
    cnt++;
  }
  return cnt;
};
```
