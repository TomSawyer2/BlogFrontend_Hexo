---
title: CnpmJs.org部署
date: 2022-03-12 13:20:00
categories:
- NodeJS
- 学习笔记
tags:
- NodeJS
- 学习笔记
---

# CnpmJs.org

## 简介

团队 npm 私服是部署在团队内网的 npm 服务器，具有缓存 npm 包的功能，可以加速 npm 相关操作

## 使用

**注意**：需要在内网环境下使用

```bash
npm config set registry 'http://ip:7001/
```

## 原理

采用 cnpmjs.org 镜像源（即 cnpm 的框架），将内网下载的包缓存至团队服务器，并在下次使用时直接返回团队内网的 npm 包资源，不需要再访问公网

## 安装过程

```bash
docker pull supermp/cnpmjs.org
docker run -d --name cnpmjs.org -v /root/cnpmjs/:/root/.cnpmjs.org/ -p 7001:7001 -p 7002:7002 -m 600M --memory-swap=600M --oom-kill-disable supermp/cnpmjs.org
```

**注意**：此处需要把外部的配置文件先配置好，示例如下。此外，需要指定容器运行的大小，不然容易炸服

```json
{
  "registryPort": 7001,
  "webPort": 7002,
  "bindingHost": "0.0.0.0",
  "handleSyncRegistry": "https://registry.npmmirror.com",
  "registryHost": "host:7001",
  "scopes": ["@dian"],
  "enablePrivate": false,
  "syncModel": "exist",
  "syncByInstall": true,
  "syncDevDependencies": false,
  "syncDeletedVersions": false,
  "alwaysAuth": false,
  "admins": {
    "admin": "admin@xxxx.com"
  },
  "database": {
    "db": "testdb",
    "username": "name",
    "password": "pwd",
    "dialect": "mysql",
    "host": "host",
    "port": 3306
  }
}
```

同步了一个项目不到的包就使用了 18G 的空间，且`npm i`的时间仅从 35s 缩短到 30s 左右，性价比其实不高，且因为`npm i`的过程中部分时间其实是在解析依赖树，因此网络带宽的影响会进一步缩小，所以目前不再拓展包的同步
