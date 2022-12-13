---
title: Map&Set
date: 2021-10-26 23:29:00
categories:
- JavaScript
- 学习笔记
tags:
- JavaScript
- 学习笔记
---

# Map&Set

## Map

1. 是一种键值对格式，比 Object 结构更灵活，键中可以存各种类型的值，形成值-值的对应。

2. ```js
   const m = new Map();
   const o = { p: "Hello World" };

   m.set(o, "content");
   m.get(o); // "content"

   m.has(o); // true
   m.delete(o); // true
   m.has(o); // false
   ```

3. ```javascript
   const map = new Map([
     ["name", "张三"],
     ["title", "Author"],
   ]);

   map.size; // 2
   map.has("name"); // true
   map.get("name"); // "张三"
   map.has("title"); // true
   map.get("title"); // "Author"
   ```

实际上执行的操作：

```js
const items = [
  ["name", "张三"],
  ["title", "Author"],
];

const map = new Map();

items.forEach(([key, value]) => map.set(key, value));
```

4. `Set`和`Map`都可以用来生成新的 Map。

5. 如果对同一个键多次赋值，后面的值将覆盖前面的值。

6. 如果读取一个未知的键，则返回`undefined`。

7. 只有对同一个对象的引用，Map 结构才将其视为同一个键。这一点要非常小心。

8. Map 的键实际上是跟内存地址绑定的，只要内存地址不一样，就视为两个键,这就解决了同名属性碰撞（clash）的问题。

9. 如果 Map 的键是一个简单类型的值（数字、字符串、布尔值），则只要两个值严格相等，Map 将其视为一个键，比如`0`和`-0`就是一个键，布尔值`true`和字符串`true`则是两个不同的键。另外，`undefined`和`null`也是两个不同的键。虽然`NaN`不严格相等于自身，但 Map 将其视为同一个键。

10. 具体操作见[Set 和 Map 数据结构 - ECMAScript 6 入门 (ruanyifeng.com)](https://es6.ruanyifeng.com/#docs/set-map#WeakSet)

## Set

1. 类似于数组，但是成员的值都是唯一的，没有重复的值。

2. `Set`本身是一个构造函数，用来生成 Set 数据结构。

```javascript
const s = new Set();

[2, 3, 5, 4, 5, 2, 2].forEach((x) => s.add(x));

for (let i of s) {
  console.log(i);
}
// 2 3 5 4
```

上面代码通过`add()`方法向 Set 结构加入成员，结果表明 Set 结构不会添加重复的值。

`Set`函数可以接受一个数组（或者具有 iterable 接口的其他数据结构）作为参数，用来初始化。

```javascript
// 例一
const set = new Set([1, 2, 3, 4, 4]);
[...set];
// [1, 2, 3, 4]

// 例二
const items = new Set([1, 2, 3, 4, 5, 5, 5, 5]);
items.size; // 5

// 例三
const set = new Set(document.querySelectorAll("div"));
set.size; // 56

// 类似于
const set = new Set();
document.querySelectorAll("div").forEach((div) => set.add(div));
set.size; // 56
```

上面代码中，例一和例二都是 Set 函数接受数组作为参数，例三是接受类似数组的对象作为参数。

3. 向 Set 加入值的时候，不会发生类型转换，所以`5`和`"5"`是两个不同的值。Set 内部判断两个值是否不同，使用的算法叫做“Same-value-zero equality”，它类似于精确相等运算符（`===`），主要的区别是向 Set 加入值时认为`NaN`等于自身，而精确相等运算符认为`NaN`不等于自身。

4. 在 Set 内部，两个`NaN`是相等的。两个对象总是不相等的。

5. 具体操作见[Set 和 Map 数据结构 - ECMAScript 6 入门 (ruanyifeng.com)](https://es6.ruanyifeng.com/#docs/set-map)
