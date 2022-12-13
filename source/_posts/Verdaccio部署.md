---
title: Verdaccio部署
date: 2022-03-10 13:20:00
categories:
- NodeJS
- 学习笔记
tags:
- NodeJS
- 学习笔记
---

# Verdaccio

## 简介

Verdaccio 是一个私服的 npm 包管理平台，类似于淘宝源，但可以部署在自己的服务器上，更加方便地进行包管理与缓存

## 安装

安装采用 verdaccio 的 docker 镜像

```bash
docker pull verdaccio/verdaccio
docker run -it --name verdaccio -p 4873:4873 -v /home/verdaccio/storage:/verdaccio/storage -v /home/verdaccio/conf:/verdaccio/conf -v /home/verdaccio/plugins:/verdaccio/plugins verdaccio/verdaccio
```

注意需要提前在`/home/verdaccio/conf`下进行配置文件的创建

```yaml
# 素有包的保存路径
storage: /verdaccio/storage/data
# 插件的保存路径
plugins: /verdaccio/plugins

# 通过web访问
web:
  title: Verdaccio

# 账号密码文件，初始不存在
auth:
  htpasswd:
    file: /verdaccio/storage/htpasswd
    # max_users：1000
    # 默认1000，允许用户注册数量。为-1时，不能通过 npm adduser 注册，此时可以直接修改 file 文件添加用户。

# 本地不存在时，读取仓库的地址
uplinks:
  taobao:
    url: https://registry.npm.taobao.org
  npmjs:
    url: https://registry.npmjs.org

# 对包的访问操作权限，可以匹配某个具体项目，也可以通配
# access 访问下载；publish 发布；unpublish 取消发布；
# proxy 对应着uplinks名称，本地不存在，去unplinks里取

# $all 表示所有人都可以执行该操作
# $authenticated 已注册账户可操作
# $anonymous 匿名用户可操作
# 还可以明确指定 htpasswd 用户表中的用户，可以配置一个或多个。
packages:
  "@*/*":
    access: $all
    publish: $authenticated
    unpublish: $authenticated
    proxy: taobao

  "**":
    access: $all
    publish: $authenticated
    unpublish: $authenticated
    proxy: taobao

# 服务器相关
sever:
  keepAliveTimeout: 60

middlewares:
  audit:
    enabled: true

# 日志设定
logs: { type: stdout, format: pretty, level: http }
```

到这一步已经安装完成

## 使用

```bash
npm config set registry http://xxx:4387
yarn set registry http://xxx:4387
```

之后采用`npm install xxx`或者`yarn add xxx`的包就会通过缓存访问 verdaccio，如果在服务器上的`/storage`里面没有找到则会前往`uplink`进行下载，并放入缓存

**注意**：通过`npm install`或者`yarn`直接安装的大量包不会进入缓存
