---
title: Eslint与Prettier
date: 2022-08-12 13:20:00
categories:
- JavaScript
- 学习笔记
tags:
- JavaScript
- 学习笔记
---

# Eslint 与 Prettier

在写前端项目的时候，往往会配置 Eslint 与 Prettier 来规范代码，两者功能相似，但实际负责的工作有所区别

## 两者的区别

### Eslint

Eslint 主要负责**代码可靠性+代码风格**的检验，更倾向于前者

代码可靠性可以减少可能会在运行时引起问题的代码，比如一些`no-used-vars`等等
代码风格比如缩进方式、大括号换行等等

但 Eslint 提供的代码风格检验相对比较少，所以需要 Prettier 进行进一步的约束

### Prettier

Prettier 主要负责**Prettier**的检验，提供了非常多的配置项

## 配置

两者如果在一个项目中直接使用会导致冲突，因此个人比较多配置的方法是将 Prettier 作为 Eslint 的插件配入 Eslint
