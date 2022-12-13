---
title: Docker基础使用
date: 2021-12-15 20:37:00
categories:
- Docker
- 学习笔记
tags:
- Docker
- 学习笔记
---

# Docker

最近把博客的后端迁移到了 docker 中，第一次学习使用 docker，做些简单的笔记。

## 项目准备

在项目中需要生成一份 Dockerfile 用于配置 docker 的行为，本次项目中使用的如下：

```bash
FROM node:12

# Create app directory
WORKDIR /data/app

# COPY package*.json ./
COPY . ./

RUN npm install

# 拷贝应用程序
COPY main.js .

# 暴露端口
EXPOSE 4000

# 运行命令
CMD [ "node", "main.js" ]
```

前面的是之前的写法，这样子跑程序会导致一报错就退出，没有可持续性。

```bash
FROM keymetrics/pm2:latest-alpine

RUN mkdir -p /home/Service
WORKDIR /home/Service
COPY . /home/Service

RUN npm install

# 暴露端口
EXPOSE 4000

# 运行命令
CMD [ "pm2-docker", "start", "main.js" ]
```

这是用 pm2 的写法，可以自动重启。
其中本来应该只把`package.json`挪到根目录，而其余文件不用管，但在实际使用过程中发现读不到`cert`目录下的证书，因此把所有文件都复制了一遍。
当然，也需要配置一份`.dockerignore`用于忽略文件，对于`node`项目一般是`node_modules`，配置规则与`.gitignore`一样。

## 服务端操作

1. 第一步显然是安装 docker，这步没啥好说的。
2. 第二步 cd 到项目目录下，运行`docker build -t hanserena/blogbackend .`这里配置的目录是 docker 内部的，用于生成这个项目的 image。
3. 生成 image 后可以用`docker images`查看生成的所有 images。
4. 运行容器：`docker run -p 4000:4000 -d hanserena/blogbackend`这里前一个端口号为服务器的端口号，后一个为 docker 内部的端口号。
5. 使用`docker ps`查看运行的容器，如果没有就`docker ps -a`找到停止的容器并`docker logs id`来查看日志。

## 一些操作

1. 删除所有容器：`docker rm $(docker ps -a -q)`
2. 删除指定 image：`docker rmi id`
