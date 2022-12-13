---
title: TypeScript
date: 2022-03-02 13:20:00
categories:
- JavaScript
- TypeScript
- NodeJS
- 学习笔记
tags:
- JavaScript
- TypeScript
- NodeJS
- 学习笔记
---

# TypeScript

## 安装

```bash
npm i -g typescript
npm i -g @types/ts
```

由于 ts 运行环境不确定，因此需要安装`@types`来匹配环境

## 编译与运行

```bash
tsc xxx.ts
```

```bash
ts-node xxx.ts
```

## 元组

ts 的元组相当于 js 的数组

## 联合

```ts
let a: string | number | string[];
```

之后`a`可以赋值为字符串或数值或字符串数组

## 类与接口

接口可以通过`extends`实现多继承，可以通过类`implements`实现具体实现；
类不能多继承，但可以通过`extends`实现多重继承

`super`可以直接作为父类在子类的调用，可以在子类通过`super.method()`调用父类的`method`方法

`static`用于指定对应属性和方法是静态的，可以直接通过类名调用

访问控制修饰符：`public`、`protected`、`private`

- `public`：可以在任何地方访问
- `protected`：可以在自己或者子类访问
- `private`：只能在自己处访问

## 对象

ts 中不能为对象添加新的属性或方法，需要在对象中先放好模板

```ts
let person {
    age: 18;
    getAge: () => {};
}

person.getAge = function() {
    console.log(this.age);
}
```

鸭子类型：只关注对象能干什么，而不关注对象是什么，是多态的一种实现，比如入参可以游泳，可以叫，那么就可以当鸭子处理

## 命名空间

```ts
namespace Inamespace {
    export interface Iinterface{};
    export class Iclass();
}

class xxx implements Inamespace.Iinterface {
    // do something
}
```

**注意**：在其他 ts 文件中引用命名空间时需要`/// <reference path = "SomeFileName.ts" />`来进行命名空间的引入

## 声明

```ts
declare var jQuery: (selector: string) => any;
```

可以用于定义引入库的类型，帮助 ts 检查传入的参数类型

## 声明文件

```
// xxx.d.ts
declare module Module_name {
    // do something
}
```

引入声明文件：`/// <reference path = " runoob.d.ts" />`
