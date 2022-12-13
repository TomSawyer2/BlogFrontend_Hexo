---
title: Java&Springboot
date: 2022-01-13 13:20:00
categories:
- Java
- Springboot
- 学习笔记
tags:
- Java
- Springboot
- 学习笔记
---

# Java & SpringBoot

## Java

基本参照着 ts 学，其中比较关键的一些数据结构之后通过算法题熟悉。

## SpringBoot

项目结构：

**一级目录**
pom.xml 依赖管理
src 具体代码
target 打包之后生成的文件夹

**二级目录/src/main/.../**
java 具体的代码实现
resources 配置文件

**java/...**
common 通用配置，包括跨域、统一返回格式、jwt 鉴权等等
config 配置文件
modules 代码

**/modules**
xxxApplication 项目入口
xxx 实现 xxx 功能的文件夹

**/xxx**
controller 配置与前端交互的 api 以及对应做的事
dto 前端给的格式
vo 后端返回的格式
mapper 与数据库的联动
model 一些常用对象的格式
service 与 controller 对应的服务，包括接口和具体实现

**/resources**
项目启动的配置文件，mapper 映射规则

## 踩的一些坑

1. 数据库拒绝连接时，检查 pom 内部的 mysql 版本以及配置文件中密码是否加了""；
2. 注解不要忘记；
3. 打包时选 maven 的 package，若报错先 install。
