---
title: 开发环境搭建-Docker+Nginx
date: 2022-08-20 13:20:00
categories:
- Docker
- JavaScript
- 学习笔记
tags:
- Docker
- JavaScript
- 学习笔记
---

# 开发环境搭建-Docker+Nginx

## 简介

这篇文章主要记录基于 Docker+Nginx 进行请求转发的前端开发环境搭建过程，前端技术栈为 Umi+React+Webpack

**为什么在 Webpack 提供 devServer 请求转发的情况下，还要使用 Nginx？**

Umi 中 devServer 暴露的 api 相当少，因此对于 websocket 的转发支持不完善，很难做到 ws->wss 的升级转发

**为什么要把 Nginx 放在 Docker 内？**

莫得 mac 电脑，win 系统裸配 Nginx 怕配出问题，放 Docker 方便管理

## 操作过程

1. 安装 Docker Desktop
2. `docker pull nginx`
3. `docker run -itd nginx -p 80:80`这一步 Docker 的桌面端 GUI 用起来挺方便
4. 设置容器自动重启`docker update --restart=always <CONTAINER ID>`
5. 进入容器配置`nginx.conf`

## nginx 配置文件

```conf
listen 80;
server_name xxx.xxx.com;
access_log /var/log/xxx.xxx.com.access.log;
error_log /var/log/xxx.xxx.com.error.log error;

add_header Access-Control-Allow-Credentials true;
add_header Access-Control-Allow-Origin *;
add_header Access-Control-Allow-Headers "Accept,Authorization,Cache-Control";
add_header Access-Control-Allow-Methods "GET, POST, PUT, DELETE, OPTIONS";

location / {
    proxy_pass http://host.docker.internal:port;
    proxy_set_header   X-Real-IP $remote_addr;
    proxy_set_header   Host      $http_host;
    proxy_http_version 1.1;
    proxy_set_header Connection "";
}

location /api {
    proxy_pass https://xxx.xxx.com/api;
    proxy_set_header Connection "";
}

location /ws/ {
    proxy_pass https://xxx.xxx.com/ws/;
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "upgrade";
    proxy_read_timeout 86400;
    proxy_set_header Connection "";
}
```

**注意：** 在 Docker 容器内是不能通过`127.0.0.1`访问宿主机的服务的，因此需要通过`host.docker.internal`来访问，当然也可以通过起容器时的某些参数共享网络环境，但端口容易起冲突

## 一些问题

### Webpack 在开发环境下无法进行热更新

**方案一：** 这是 Webpack 的 devserver 默认监听的 url 导致的，可以通过硬编码改依赖实现，但显然不够方便
**方案二：** 将 Webpack 的 devserver 对应的路由进行配置转发

```conf
location /dev-server/ {
     proxy_pass http://host.docker.internal:1024/dev-server/;
     proxy_set_header X-Real-IP  $remote_addr;
     proxy_set_header X-Forwarded-For $remote_addr;
     proxy_set_header Host $host;
     proxy_http_version 1.1;
     proxy_set_header Connection "";
 }
```

### 在页面加载时，经常性会有一些 js 文件加载不出来导致页面打不开

这一问题表现形式是在加载页面时部分文件网关超时，返回 504，但直接去访问对应 url 是可以访问到的

猜测是因为开发环境下需要加载的文件量很大，nginx 默认的最大连接数不够用，所以会导致超时

**方案：** 找到`nginx.conf`并设置连接数`worker_connections`

```conf
events {
    worker_connections  65535;
}
```
