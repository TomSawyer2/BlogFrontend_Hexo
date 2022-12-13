---
title: Mongoose
date: 2022-02-03 13:20:00
categories:
- MongoDB
- 学习笔记
tags:
- MongoDB
- 学习笔记
---

# Mongoose

## 简介

Mongoose 是 MongoDB 的 orm 库，类似于 Mybatis-Plus

## 数据库连接

```js
//引入模块
const mongoose = require("mongoose");

//连接数据库
mongoose.connect(
  "mongodb://root:password@ip:27017/minigame",
  {
    useNewUrlParser: true,
    useUnifiedTopology: true,
    autoIndex: true,
  },
  function (err) {
    if (err) console.log(err);
  }
);

const db = mongoose.connection;

db.once("open", () => {
  // 测试数据库连接是否成功
  console.log("mongoose connect success");
});
```

## 模型

```js
var mongoose = require("mongoose");
var Schema = mongoose.Schema;

const gameOneSchema = new Schema(
  {
    username: {
      required: true,
      type: String,
    },
    phone: {
      required: true,
      type: String,
    },
    score: {
      type: Number,
    },
  },
  {
    timestamps: true,
  }
);

module.exports = mongoose.model("gameOne", gameOneSchema);
```

## CRUD

新增记录：

```js
let newRecord = new gameOne({
  username: data.username,
  phone: data.phone,
  score: data.score,
});
newRecord.save((err) => {
  if (err) next({ status: errorcode.UPDATE_ERR_1, msg: "更新成绩错误" });
  res.send({ status: 0, msg: "操作成功", data: null });
});
```

查询前十记录：

```js
gameOne
  .find()
  .sort({ score: -1 })
  .skip(0)
  .limit(10)
  .exec((err, response) => {
    if (err) next({ status: errorcode.GET_RANK_ERR_1, msg: "查找排行榜错误" });
    res.send({ status: 0, msg: "操作成功", data: response });
  });
```
