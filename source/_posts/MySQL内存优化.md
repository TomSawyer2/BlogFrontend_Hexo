---
title: MySQL内存优化
date: 2022-01-10 13:20:00
categories:
- MySQL
tags:
- MySQL
---

# MySQL 占用内存过大优化

## 方案一

### 查看 table_open_cache

```sql
SHOW VARIABLES LIKE '%table_open_cache%';
```

### 修改 table_open_cache

修改 MySQL 配置文件中的对应值，稍微调小一点，占用内存明显减小。

```sql
SET GLOBAL table_open_cache = 1024;
```

## 方案二

宿主机的`MySQL`可以直接修改`/etc/mysql/mysql.cnf`文件，容器内可以在`/etc/mysql/conf.d`下添加`docker.cnf`文件并添加如下配置：

```
[mysqld]
performance_schema_max_table_instances=400  
table_definition_cache=400  
table_open_cache=256
performance_schema = off
```