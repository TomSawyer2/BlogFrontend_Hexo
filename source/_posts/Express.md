---
title: Express
date: 2022-02-02 13:20:00
categories:
- JavaScript
- Express
tags:
- JavaScript
- Express
---

# Express

## 简介

准确说，Express 是使用过的第一个后端框架，不过一直没写日志。这个博客 v1 版本的接口就是通过 Express 实现的，不过后面换成了 SpringBoot。Express 作为 JS 最经典的后端框架最大的特色就是自由灵活，但同时也带来了一些封装度低，规范不统一的问题，因而出现了 Koa 等等对 Express 进行二次封装的框架。当然了，写写小项目肯定是 Express 来的舒服，不用像 SpringBoot 这样严谨。

## 项目搭建

这次项目的搭建使用了 Express 的脚手架 express-generator，虽然名字看着不太官方但确实是官方的脚手架。

```bash
express project_name
```

项目构建完之后可以注意到项目文件夹中的`/views`文件夹存放着模板文件，但作为纯后端要啥前端模板，直接扬了；`/routes`文件夹中对应请求的路由，这里把具体的实现拆分到了`/controller`中，类似于 SpringBoot 中 Controller 和 Service 的关系，不过这里就没有必要写啥 impl 等等实现了，此外，将错误处理统一放在`app.js`的最后，错误码统一放在`/common`中

## 项目部署

老一套，直接把使用的 dockerfile 和对应 pm2 的配置文件放上来

```dockerfile
FROM keymetrics/pm2:latest-alpine

RUN mkdir -p /home/Service
WORKDIR /home/Service
COPY . /home/Service

RUN npm install

# 暴露端口
EXPOSE port

# 运行命令
CMD [ "pm2-docker", "start", "pm2.json" ]
```

```json
// pm2.json
{
  "apps": {
    "name": "minigame_backend",
    "script": "./bin/www",
    "watch": true,
    "ignore_watch": ["node_modules", "logs"],
    "instances": 2,
    "error_file": "logs/err.log",
    "out_file": "logs/out.log",
    "log_date_format": "YYYY-MM-DD HH:mm:ss"
  }
}
```

```bash
cd "/home/hanserena/minigame_backend/"
docker build -t minigame_backend .
docker run -p 3000:3000 -d minigame_backend
docker exec -it xxx pm2 list // 查看进程情况
docker exec -it xxx pm2 log // 查看日志
```

## 一些经验

在配全局错误处理时一开始`app.js`末尾的函数一直获取不到 error，后来发现即使用不到任何参数，err、req、res、next 这四个形参也是必不可少的。

Express 给人最大的感觉是流畅，这里指的更多是逻辑层面的。在`app.js`中就不难注意到不管是各类日志的处理、具体接口的控制、服务的实现、错误的处理都是在一条线上的。通过`app.use`对中间件的串联形成了一条完整的从 request 到 response 的链路。
