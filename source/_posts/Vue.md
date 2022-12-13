---
title: Vue
date: 2021-10-07 20:27:00
categories:
- Vue
- 学习笔记
tags:
- Vue
- 学习笔记
---

## 创建应用

将 vue.js 引入时会声明全局变量 Vue，使用 new Vue 来获取一个新的应用对象。

```html
<div id="app">{{ message }}</div>
```

```js
var app = new Vue({
  el: "#app",
  data: {
    message: "Hello Vue!",
  },
});
```

注意：el 为 element，放入要绑定的组件名称，data 为组件内要引用的数据。

### 数据与方法

通常会用 vm 代表视图模型。

如果想通过 js 来修改视图中的值那么要在 new Vue 前先声明这个变量。

vm.$data 也可以用于表示 data

$watch 是一个实例方法，示例：

```vue
vm.$watch('a',function(newVal, oldVal){ console.log(newVal, oldVal); })
vm.$data.a = 2;
```

### 生命周期

生命周期的函数内不能使用箭头函数。

beforeCreate：整个页面创建之前调用

created：实例创建之后被调用

beforeMount：挂载之前被调用

mounted：el 被新创建的 vm.$el 替换，挂载成功

beforeUpdate：数据更新（变化）之前调用

updated：组件 DOM 更新完毕之后调用

### 模板语法-插值

#### v-once

v-once 指令可以执行一次性插值，即之后的内容不会再改变。

#### v-html

`<span v-once>不会改变：{{msg}}</span>`

双大括号会把数据解释为普通文本，输出真正的 HTML 需要用 v-html

```vue
<p>
    Using mustaches: {{ rawHtml }}
</p>
<p>
    Using v-html directive: <span v-html="rawHtml"></span>
</p>
```

v-html 可以绑在 p 标签下，标签内不用写任何东西。

#### v-bind

为标签动态绑定属性：`<div v-bind:id="dynamicId"></div>`

格式：`<div v-bind:属性=""></div>`

属性内部的内容即为 data 内的内容。

#### js 表达式

可以在`{{}}`内部放入 js 代码

### 模板语法-指令

v-if 可以通过判断变量来决定是否显示

`<p v-if="seen">可以看见</p>`

v-bind 可以动态跳转网页

`<a v-bind:href="url">跳转至百度</a>`

#### 修饰符

与 data 并行的 methods 内部可以放置事件处理函数

```vue
<div @click="click1">
    <div @click.stop="click2">
        click me
    </div>
</div>
```

```vue
methods:{ click1 : function () { console.log('click1'); }, click2 : function ()
{ console.log('click2'); } }
```

@click 表示点击，@click.stop 表示点击完毕后就结束事件，不会触发上一层。

### Class 与 Style 绑定

动态绑定的样式可以与静态绑定的样式共存。

```vue
<div
  class="static"
  v-bind:class="{ active: isActive, 'text-danger': hasError }"
>hello vue</div>
```

```vue
var app6 = new Vue({ el: '#app6', data: { isActive: true, hasError: false } })
```

```vue
.static{ background-color: aliceblue; } .active{ font-size: 50px; }
```

#### 绑定内联样式

`<div :style="{color : color}">hi vue</div>`

```vue
data: { isActive: true, color: '#55aa7f' }
```

### 条件渲染

v-if

v-else

v-else-if

```vue
<div v-if="type === 'A'">
	A
</div>
<div v-else-if="type === 'B'">
	B
</div>
<div v-else-if="type === 'C'">
	C
</div>
<div v-else>
	Not A/B/C
</div>
```

v-show

根据条件展示

```vue
<div v-show="judge">Judge OK!</div>
```

v-show 是通过 css 来隐藏元素的。

如果切换频繁则用 v-show，如果很少切换则用 v-if。

### 列表渲染

v-for 渲染一个列表

数组

```vue
<ul>
	<li v-for="item,index in items" :key="index">
		{{ index }}:{{ item.message }}
	</li>
</ul>
```

```vue
data: { items: [ { message : 'FOO' }, { message : 'BAR' } ] }
```

对象

```vue
<ul>
	<li v-for="value in object" :key="key">
		{{ value }}
	</li>
</ul>
```

```vue
object: { title: "lists by v-for", author: "hanserena", publishedAt:
"2021-04-24" }
```

### 事件绑定

v-on 监听

`<button v-on:click="counter += 1">{{ counter }}</button>`

```vue
data: { counter: 0, }
```

`<button v-on:click="greet">Greet</button>`

```vue
methods: { greet: function () { alert('hi!'); } }
```

事件修饰符

.stop

.prevent

.capture

.self

### 表单输入绑定

v-model 创建双向数据绑定

```vue
<input v-model="message" placeholder="edit me" />
<p>message is : {{ message }}</p>
```

```vue
data: { counter: 0, message: "" },
```

```vue
			<div style="margin-top: 20px;">
				<input type="checkbox" id="jack" value="Jack" v-model="checkedNames" />
				<label for="jack">Jack</label>
				<input type="checkbox" id="john" value="John" v-model="checkedNames" />
				<label for="john">John</label>
				<input type="checkbox" id="mike" value="Mike" v-model="checkedNames" />
				<label for="mike">Mike</label>
				<br />
				<span> Checked names: {{ checkedNames }}</span>
			</div>

			<div style="margin-top: 20px;">
				<input type="radio" id="one" value="One" v-model="picked" />
				<label for="one">One</label>
				<br />
				<input type="radio" id="two" value="Two" v-model="picked" />
				<label for="two">Two</label>
				<br />
				<span>Picked: {{ picked }}</span>
			</div>
		</div>
```

```vue
data: { counter: 0, message: "", message2: "", checkedNames: [], picked: "" },
```

### 组件基础

```vue
<button-counter title="title1 : " @clicknow="clicknow">
	<h2>hi...h2</h2>
</button-counter>
<button-counter title="title2 : " @clicknow="clicknow"></button-counter>
```

```vue
Vue.component('button-counter', { props: ['title'], data: function () { return {
count: 0 } }, template: '
<div><h1>hi...</h1><button v-on:click="clickfun">{{title}} {{ count }} times</button></div>
', methods:{ clickfun: function () { this.count++; this.$emit('clicknow',
this.count); } } }) var app10 = new Vue({ el: '#app10', data: { }, methods:{
clicknow : function (e) { console.log(e); } } })
```

### 组件注册

全局注册，局部注册

```vue
<test></test>
```

```vue
var app10 = new Vue({ components:{ test : { template:"
<h2>h2...</h2>
", } } })
```

### 单文件组件

template 模板视图

script 脚本

style 样式
