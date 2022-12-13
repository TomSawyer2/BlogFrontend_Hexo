---
title: MySQL内存优化
date: 2022-01-10 13:20:00
categories:
- MySQL
tags:
- MySQL
---

# MySQL 占用内存过大优化

## 查看 table_open_cache

```sql
SHOW VARIABLES LIKE '%table_open_cache%';
```

## 修改 table_open_cache

修改 MySQL 配置文件中的对应值，稍微调小一点，占用内存明显减小。
