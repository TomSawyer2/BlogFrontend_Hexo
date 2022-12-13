---
title: Redis
date: 2022-01-22 13:20:00
categories:
- Redis
- 学习笔记
tags:
- Redis
- 学习笔记
---

# Redis

## 简介

键值对缓存，同时也可以做持久化，读写速度快到起飞。

## 安装

```bash
docker pull redis:latest
docker run -p 6379:6379 -d redis
docker exec -it xxx bash
```

输入`redis-server`以启动，不过在 redis 的镜像内部默认是启动的，
输入`redis-cli`进入 redis，输入`ping`，返回`pong`，安装成功。

远程访问：`redis-cli -h host -p port -a pwd`

## 配置

配置文件`redis.conf`

获取所有配置项：`CONFIG GET *`
获取指定配置项：`CONFIG GET XXX`
编辑配置项：`CONFIG SET XXX XXX`

## 数据类型

String、Hash、List、Set、Zset

### String

一个 key 对应一个 value，二进制安全，可以存任何数据，最大值为 512MB。

```redis
SET a "123"
GET a
DEL a // 删除成功返回1，失败0
```

### Hash

多个 key 与多个 value，是键值对集合。

```redis
HMSET hashtest test1 "1" test2 "2"
HMGET hashtest test1
```

### List

是简单的字符串列表，按照插入顺序排列。

```redis
lpush listtest first
lpush listtest second
lrange listtest MIN MAX
```

存储时使用数字类型的索引。

### Set

```redis
sadd settest 1
sadd settest 2
smembers settest
```

注意：重复加入元素会被忽略。

### Zset

```redis
// zadd key score member
zadd zsettest 1 1
zadd zsettest 1 2
ZRANGEBYSCORE zsettest MIN MAX
```

redis 会根据 score 的值进行排序，score 的值可以重复。

## KEY 相关命令

`DEL`删除
`DUMP`序列化给定 key 并返回值
`EXISTS`判断是否存在
`EXPIRE`设置失效时间
`PERSIST`撤销失效时间
`RENAME`重命名
`TYPE`查看类型

## HyperLogLog

用于做基数统计，基数集为不重复的数据集，基数为重复的元素。

```redis
PFADD hypertest 1
PFADD hypertest 2
PFCOUNT hypertest // 2
```

## 发布订阅

用于在不同客户端间传递数据。
订阅：`SUBSCRIBE A`
发布：`PUBLISH A "XXX"`

## 事务

开始事务->命令入队->执行事务

```redis
MULTI
SET A XXX
GET A
...
EXEC // 会执行上述所有内容
```

注意：事务不是原子性的，失败了不会全部回滚。

## 连接

验证密码是否正确：`AUTH pwd`
切换数据库：`SELECT idx`

## 服务器

查看统计信息：`INFO`

## Stream

用于消息队列，是新版本新增的数据结构。

## 数据备份与恢复

备份：`SAVE`或`BGSAVE`（后台执行）
恢复：`CONFIG GET dir`查看安装目录，并将备份文件`dump.rdb`移动到安装目录并启动服务即可。

## 设置密码

查看有无密码：`CONFIG get requirepass`
设置密码：`CONFIG set requirepass "xxx"`

## 性能测试

```redis
redis-benchmark -n 1000 -q`
```

同时执行 1000 个请求测试性能。

## 分区

通过 user 的 key 来实现不同客户端间的分布式存储。
