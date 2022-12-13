---
title: Cloudreve云盘搭建
date: 2022-01-25 13:20:00
categories:
- 学习笔记
tags:
- 学习笔记
---

# Cloudreve 云盘搭建

## 简介

Cloudreve 是开箱即用的云盘，虽然很多教程都推荐使用宝塔一键安装，但其实手动安装也挺方便的。相比于百度云等公共云盘最大的优点就是上传下载完全没有限速，适合存一些个人的文档、资料。此外，cloudreve 以前是用 PHP 写的，现在使用 React+Golang 写的，此外组件库一眼就是 AntD，所以环境配置也会方便很多。（PHP：落魄了，家人们

## 安装

1. 在 GitHub 上找到 cloudreve 的仓库，下载对应版本的压缩包，这台服务器使用的是 amd64 版本；
2. 解压，把文件上传到服务器，啥目录都行；
3. cd 到该目录下，先`chmod +x ./cloudreve`再`./cloudreve`即可启动服务；
4. 注意，此时需要记录下管理员的账号与密码，浏览器访问 ip+5512 即可进入云盘。

## 配置

### 阿里云 OSS

进入云盘的管理员界面，选存储策略，新建策略，选阿里云 OSS，之后把 OSS 相关信息填入即可，非常方便。

### nginx

由于 https 域名只有一个，所以就没有把云盘相关地址反向代理到 https 上。

### 持久化

之前启动的服务是暂时的，显然需要持久化，此处使用的是 supervisor，当然也可以用 systemd 等等。

```bash
# 安装supervisor
apt install supervisor

# 访问配置文件
sudo touch /etc/supervisor/supervisord.conf

# 修改配置文件，最后两行改成下面这样
[include]
files = /etc/supervisor/conf/*.conf

supervisorctl update

# 创建配置文件夹
sudo mkdir -p /etc/supervisor/conf

# 加入配置文件cloudreve.conf

# 开启配置
supervisord -c /etc/supervisord.conf

# 开启服务
sudo supervisorctl start cloudreve

# 停止服务
sudo supervisorctl stop cloudreve

# 查看服务状态
sudo supervisorctl status cloudreve
```

## 效果

可以在http://175.24.30.102:5212访问体验。
