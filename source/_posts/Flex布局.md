---
title: Flex布局
date: 2021-10-09 21:00:00
categories:
- CSS
- 学习笔记
tags:
- CSS
- 学习笔记
---

## HTML 相关

[TOC]

### 空元素

不包含任何内容的元素。
示例：`<img src="images/firefox-icon.png" alt="测试图片">`
alt 内的为替换内容，当图片不可见时显示

### 网页结构

1. index.html ：这个文件一般包含主页内容，即用户第一次访问站点时看到的文本和图像。使用文本编辑器在 test-site 文件夹中新建 index.html。
2. images 文件夹 ：这个文件夹包含站点中的所有图像。在 test-site 文件夹中新建 images 文件夹。
3. styles 文件夹 ：这个文件夹包含站点所需样式表（比如，设置文本颜色和背景颜色）。在 test-site 文件夹中新建一个 styles 文件夹。
4. scripts 文件夹 ：这个文件夹包含提供站点交互功能的 JavaScript 代码（比如读取数据的按钮）。在 test-site 文件夹中新建一个 scripts 文件夹。

### 列表

所有项目均用`<li>`包围。

#### 无序列表

`<ul></ul>`

#### 有序列表

`<ol></ol>`

#### 示例

```html
<ul>
  <li>技术人员</li>
  <li>思考者</li>
  <li>建造者</li>
</ul>
```

### 链接

示例：`<a href="https://www.mozilla.org/zh-CN/about/manifesto/">Mozilla 宣言</a>`

## Flex 布局

### 定义

任意容器均可以指定为 Flex 布局。
示例：

```css
.box {
  display: flex;
}
.box {
  display: inline-flex;
}
.box {
  display: -webkit-flex; /* Safari */
  display: flex;
}
```

注：webkit 内核浏览器要加上`-webkit`前缀。且设为 flex 布局之后子元素的 float、clear、vertical-align 属性会失效。

### 基本概念

采用 flex 布局的元素称为 flex 容器，子元素自动称为容器成员，称为 flex 项目。

水平主轴，垂直交叉轴。项目默认沿主轴排列。

### 容器属性

#### flex-direction

决定主轴方向（项目排列方向）
值：

```css
row（默认值）：主轴为水平方向，起点在左端。
row-reverse：主轴为水平方向，起点在右端。
column：主轴为垂直方向，起点在上沿。
column-reverse：主轴为垂直方向，起点在下沿。
```

#### flex-wrap

定义轴线上排不下时如何换行。
值：

```css
nowrap（默认值）：不换行。
wrap：换行，第一行在上。
wrap-reverse：换行，第一行在下。
```

#### flex-flow

前两者的简写。
默认值：`row nowrap`

#### justify-content

定义项目在主轴上对齐方式。

```css
flex-start（默认值）：左对齐
flex-end：右对齐
center： 居中
space-between：两端对齐，项目之间的间隔都相等。
space-around：每个项目两侧的间隔相等。所以，项目之间的间隔比项目与边框的间隔大一倍。
```

#### align-items

定义项目在交叉轴上如何对齐。
值：

```css
flex-start：交叉轴的起点对齐。
flex-end：交叉轴的终点对齐。
center：交叉轴的中点对齐。
baseline: 项目的第一行文字的基线对齐。
stretch（默认值）：如果项目未设置高度或设为auto，将占满整个容器的高度。
```

#### align-content

定义多根轴线的对齐方式。
值：

```css
flex-start：与交叉轴的起点对齐。
flex-end：与交叉轴的终点对齐。
center：与交叉轴的中点对齐。
space-between：与交叉轴两端对齐，轴线之间的间隔平均分布。
space-around：每根轴线两侧的间隔都相等。所以，轴线之间的间隔比轴线与边框的间隔大一倍。
stretch（默认值）：轴线占满整个交叉轴。
```

### 项目属性

```css
order
flex-grow
flex-shrink
flex-basis
flex
align-self
```

#### order

定义项目的排列顺序。数值越小排列越前，默认 0。

#### flex-grow

定义项目的放大比例。默认 0。

#### flex-shrink

定义项目的缩小比例。默认 1。负值无效。

#### flex-basis

定义分配多余空间之前项目占的主轴空间。默认值为 auto，即原本的大小。也可以设为固定值。

#### flex

是 flex-grow, flex-shrink 和 flex-basis 的简写，默认值为 0 1 auto，后面两个值可选。
快捷值：auto (1 1 auto) 和 none (0 0 auto)。

#### align-self

允许单个项目有与其他项目不一样的对齐方式，可覆盖 align-items 属性。默认值为 auto，表示继承父元素的 align-items 属性，如果没有父元素，则等同于 stretch。
