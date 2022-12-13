---
title: 前端使用Gitlab-CI/CD实现自动部署
date: 2022-01-07 22:42:00
categories:
- Docker
- CICD
tags:
- Docker
- CICD
---

# 使用 gitlab-ci 实现前端自动部署

何科栩 2021.12.17

## 目标

当 gitlab 前端仓库指定分支出现更新时自动打包并部署到后端服务器。

## 工具

- gitlab-ci
- docker
- 后端服务器

## 过程

1. 首先在服务器中安装 docker 以及 gitlab-runner，具体百度，很简单。

2. 然后进入 gitlab 的前端项目，选择`设置-CI/CD-Runner`获取项目的 URL 以及 token，并在服务器中执行`gitlab-runner register`，输入相关信息，description 随便输，tags 不确定的话最好唯一。

3. 此时执行`gitlab-runner restart`重启服务，在 gitlab 上应该可以看到已成功配置的服务。

4. 前端在项目根目录下创建`.gitlab-ci.yml`，并进行配置。我的配置参考如下：

   ```yml
   image: node:12.22

   stages:
     - deploy

   cache:
     key: ${CI_BUILD_REF_NAME}
     paths:
       - node_modules/

   deploy-staging:dep:
     stage: deploy
     tags:
       - buddyadmin-runner
     only:
       - main
     script:
       - echo "gitlab-ci script by TomSawyer2"
       - echo "=====start install======"
       - npm install #安装依赖
       - echo "=====end install======"
       - echo "=====start build======"
       - npm run build # 将项目打包
       - cp -r ./dist /build
       - echo "=====end build======"
   ```

   注意，yml 文件对格式要求很高，不要用 tab，冒号后面需要加个空格。

   image 是指定 docker 运行的容器，本地有没有装无所谓，stage 相关信息看官方文档。

   这里由于 nginx 没有放在容器内部，因此需要在打包完成后把 dist 文件夹递归复制到 build 文件夹下，并在 gitlab-runner 的配置文件`/etc/gitlab-runner/config.toml`中配置映射：`    volumes = ["/etc/nginx/conf.d/dist:/build/dist"]`，用于实现 nginx 代理的更新。

   具体细节相信聪明的后端都看得懂，就不再多说了。

## DEMO

[Web / BuddyAdmin · GitLab (dian.org.cn)](https://gitlab.dian.org.cn/hawkeye/buddyadmin)

https://buddy.dian.org.cn/
