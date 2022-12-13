---
title: yunzai-bot部署
date: 2022-03-15 13:20:00
categories:
- NodeJS
- 学习笔记
tags:
- NodeJS
- 学习笔记
---

# yunzai-bot

## 安装

```bash
git clone https://github.com/Le-niao/Yunzai-Bot.git
cd Yunzai-Bot
docker build . -t yunzai-bot
docker run -itd yunzai-bot
docker exec -it xxxx bash

// in docker
node app

// fill in data
npm start
```

## 一些坑

进入容器后直接启动 node 服务可能会报错找不到`redis`服务，此时需要先启动`redis-server`，即`redis-server &`，再`redis-cli`才可正常启动`redis`服务
