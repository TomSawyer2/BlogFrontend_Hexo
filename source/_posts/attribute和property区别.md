---
title: attribute和property区别
date: 2022-01-21 13:20:00
categories:
- JavaScript
- 学习笔记
tags:
- JavaScript
- 学习笔记
---

# JS 中 attribute 和 property 的区别

## 简介

attribute 是 DOM 元素自带的属性，比如 class、title、id 等等；
property 是 DOM 元素作为对象，新增的内容，比如 childNodes、firstChild 等。

因此，可以看出 attribute 是 property 的**子集**。

## 子集？

DOM 元素里的所有属性都是 attribute，其中比较常用的一些会自动转化为 property，而另一些自定义的则不会。

## 取值与赋值

1. attribute
   取值：`getAttribute()`
   赋值：`setAttribute()`

2. property
   取值：`.`
   赋值：`.`

## 数据绑定

attribute 与 property 之间的数据是单向绑定的，attribute->property
所以不管更改哪个值，都会更新到页面中。
