---
title: Matlab
date: 2022-01-31 13:20:00
categories:
- Matlab
- 学习笔记
tags:
- Matlab
- 学习笔记
---

# Matlab

## 基本操作

脚本文件：后缀.m
实时脚本文件：后缀.mlx，结果实时显示在代码旁边，可以使用分节符+运行节来实现分块运行，可以选择文本/代码切换模式以插入图片、代码等等
函数文件：后缀.m，可以直接在脚本文件中调用，固定格式`function [sigma, theta, x, y] = Simple(f, a, b, index)`前面是出参，后面是入参。
%：注释
分号：不加分号会输出在命令行，加了分号只会输出在工作区

## 单引号和双引号的区别

双引号定义字符串变量`t = "abc"`，字符串中本来就有的双引号需要重复两次`t = "abc""efg""hij"`
矩阵存储多个字符串：`t = ["abc", "efg"; "aaa", "bbb"]`

单引号定义字符变量`t = 'ABCD'`，实质上是字符数组，可以使用`t(2)`取出指定位置的字符
添加字符：`newt = [t, 'ABCD']`

## 矩阵运算

创建矩阵`t = [1 2 3]`

每个元素都+3：`newt = t + 3`

plot 函数作图：`plot(x); grid on`

多维矩阵：`t = [1 2 3; 4 5 6; 7 8 9]`

常见运算：

```matlab
B = A' % 求转置
[D, V] = eig(A) % 求特征值和特征向量
E = inv(A) % 求逆矩阵
F = A * E % 矩阵乘法
F = A .* E % 矩阵点乘，即每个元素相乘
```

A 的逆矩阵乘以矩阵 B，即求解 Ax=B：

```matlab
x = A \ B
```

注意：在进行矩阵运算时 matlab 会隐式拓展矩阵使参与运算的矩阵大小相同。

## 二维图

### 线图

```matlab
x = 0:0.05:30 % 起始值:步长:终止值
y = sin(x)
plot(x, y) % 可以用(x, y, 'LineWidth', 2)变粗
xlabel("横轴标题")
ylabel("纵轴标题")
grid on % 显示网格
axis([0 20 -1.5 1.5]) % 设置横纵坐标范围
```

一张图显示多条线：

```matlab
y1 = sin(x)
y2 = cos(x)
plot(x, y1, x, y2)
```

### 条形图

bar 垂直条形图，barh 水平条形图

```matlab
t = -3:0.05:3;
p = exp(-t.*t);
bar(t, p)
barh(t, p)
```

### 极坐标图

```matlab
theta = 0:0.01:2*pi;
radi = abs(sin(7*theta).*cos(10*theta));
polarplot(theta, radi) % 弧度，半径
```

### 散点图

```matlab
height = randn(1000, 1); % 生成长度为1000宽度为1的随机数矩阵，数值随机，符合正态分布,均值为0方差为1
weight = randn(1000, 1);
scatter(height, weight)
xlabel('Height')
ylabel('Weight')
```

## 三维图和子图

### 三维曲面图

```matlab
[X, Y] = meshgrid(-2:0.02:2); % 创建空间上的(x, y)点
Z = X .* exp(-X.^2-Y.^2);
surf(X, Y, Z); % 创建三维曲面图
colormap hsv % 设置颜色，可以写winter summer等等
colorbar
```

### 子图

使用 subplot 函数在同一窗口的不同子区域显示多个绘图

```matlab
theta = 0:0.01:2*pi;
radi = abs(sin(7*theta).*cos(10*theta));
Height = randn(1000, 1);
Weight = randn(1000, 1);

% subplot参数：行数，列数，第几个
subplot(2, 2, 1); surf(X .^ 2); title('1');
subplot(2, 2, 2); surf(Y .^ 3); title('2');
subplot(2, 2, 3); polarplot(theta, radi); title('3');
subplot(2, 2, 4); scatter(Height, Weight); title('4');
```

## 导入数据

主页-导入数据-选择 excel 文件-选择导入的数据

注意：matlab 默认从第二行开始导入，可以在上方改，可以 ctrl+左键选择需要的列，变量名称行只识别英语，汉语需要自己改，可以加表的标题。

输出类型
| 类型 | 属性 |
| ---------- | ------------------------------------------ |
| 列向量 | 所选数据每一列导入为单个 m x 1 向量 |
| 数值矩阵 | 所选数据导入为 m x n 数值数组 |
| 字符串数组 | 所选数据导入为 m x n 字符串数组 |
| 元胞数组 | 所选数据导入为可包含多种数据类型的元胞数组 |
| 表 | 导入为表，不变 |

若单元格变黄则代表内容的类型与所选的类型不匹配，方法一：替换为 NaN；方法二：排除具有以下内容的行；方法三：排除具有以下内容的列

注意：导入的数据在工作区，关闭 matlab 后会消失，需要保存工作区为文件.mat

## 处理缺失值和异常值

构造一组包含缺失值和异常值的例子：

```matlab
x = 1:100;
data = randn(1, 100);
data(20:20:80) = NaN;
data(10) = -50;
data(40) = 45;
data(70) = -40;
data(90) = 50;
plot(x, data);
```

### 清理缺失数

实时编辑器选任务-清理缺失数据-填充缺失，线性插值

### 处理异常值

实时编辑器选任务-清理离群数据-填充离群值-线性插值

注意：定义离群值-中位数/均值-阈值因子 3，输出可以根据需要选择显示哪些部分
