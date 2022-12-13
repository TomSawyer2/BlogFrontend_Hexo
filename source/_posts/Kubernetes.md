---
title: Kubernetes
date: 2022-01-15 13:20:00
categories:
- Kubernetes
- 学习笔记
tags:
- Kubernetes
- 学习笔记
---

# Kubernetes

## 基本架构

结点网络——Master、Node1、Node2（Pod1、Pod2、Kube-proxy）

Pod 网络（虚拟）

Service 网络（虚拟）

一个 Node 即是一台主机。

## Pod

一个 Pod 内部有多个容器，容器间共用网络和卷，在启动 Pod 时会自动启动 pause 容器。

### RC/RS

用于确保副本数，若有容器异常退出则自动创建新的 Pod，多余的容器也会被回收。

### 滚动更新

通过 deployment 来控制 RS，将内部的 Pod 一个个更新，回滚同理。

### HPA

水平自动扩展。

### StatefulSet

解决有状态服务的问题——持久化存储、稳定网络标志、有序。

### DaemonSet

确保所有 Node 上都有一个 Pod 的副本。

### Job

批处理任务。

### Cron Job

基于时间的 Job。

## 网络通信

在同一主机：直接通过 Docker0 的网桥；

不在同一主机：经过 Flannel。

## 安装与部署

[腾讯云环境 K8S 安装及配置测试 | 阿辉的博客 (huilog.com)](http://www.huilog.com/?p=996)

步骤：

1. 操作环境配置，各主机安装 docker，配置 harbor 私有镜像仓库；
2. 安装配置 etcd；
3. 配置 master 节点负载均衡；
4. 使用 kubeadm 安装配置 k8s 集群；
5. 安装其他插件。

## k8s 对象

Pod、NameSpace、Service 等等都是对象。

Spec：定义 Status：状态

根据 Spec 创建对象，根据 Status 维护对象。

使用 yaml 文件描述 Spec 和 Status。

写完 yaml 文件后使用`kubectl apply -f deployment.yaml --record`即可创建一个 deployment。

## Pod 生命周期

initC->MainC(START->Liveness(readiness->STOP))

initC 时指定运行 docker 版本与镜像，通过`kubectl get pod`查看 pod 运行的情况，init 有可能卡住过不去。
