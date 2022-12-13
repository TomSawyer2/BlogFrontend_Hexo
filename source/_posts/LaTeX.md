---
title: LaTeX
date: 2022-01-23 13:20:00
categories:
- LaTeX
- 学习笔记
tags:
- LaTeX
- 学习笔记
---

# LaTeX

## 简介

论文必备公式工具，没啥好说的。

## 安装

Win11 上安装需要下载科大的镜像安装包，http://mirrors.ustc.edu.cn/CTAN/systems/texlive/Images/texlive.iso，下载后直接打开管理员运行安装脚本即可。

Docker 上也有 texlive 的镜像，似乎更方便。

## 使用

LaTeX 使用`\documentclass{article}`来规定文档的类型，并用`\begin{document}`与`\end{document}`来标志文档的开始与结尾。

测试范例：

```latex
\documentclass[fontset=windows]{article} % 导言部分，有article book report letter类型
\usepackage{ctex} % 显示中文
\newcommand\degree{^\circ} % 定义新命令

\title{test docu}
\author{TomSawyer2}
\date{\today}

\begin{document} % 正文区，括号内放环境名称

\maketitle% 显示标题、作者、日期信息
Hello \LaTeX
Let $f(x)$ be defined % $包裹起来为数学模式
Let $f(x)=3x+2$ % 两个$包裹起来为另起一行的数学模式

% 使用空行来分行
\heiti 中文黑体
\kaishu 中文楷书

\begin{equation}% 带编号的单行公式
    a^2 = b^2 + c^2
\end{equation}

\end{document}
% 这是一条注释
```

### 字体

字体编码、字体族、字体系列、字体形状、字体大小

字体族

```latex
\textrm{Roman Family}
\rmfamily Roman Family
```

字体大小

```latex
{\tiny Hello}
{\scriptsize Hello}
{\footnotesize Hello}
{\small Hello}
{\normalsize Hello}
{\large Hello}
{\Large Hello}
{\LARGE Hello}
{\huge Hello}
{\Huge Hello}
\zihao{5} 中文字体
% normalsize的大小是由文档决定的，例如[10pt]
```

### 文章结构

```latex
\tableofcontents % 生成目录
\chapter{第一章}
\section{引言}
\section{实验方法}
\subsection{子小节}
```

### 换行

```latex

% 空行换行，有缩进

123\\456
% \\换行，无缩进

123\par 456
% \par换行，有缩进
```

### 特殊字符

1. 使用空行分段时多个空行等效为 1 个；
2. 自动缩进，不要用空格代替；
3. 英文中多个空格等效为 1 个，中文中空格忽略。

```latex
a\quad b % 产生1em，即当前字体M的宽度
a\qquad b % 产生2em
a\,b a\thinspace b % 产生1/6em
a\enspace b % 产生0.5em
a\ b % 空格
a~b % 硬空格
a\kern xxxpc/em b
a\hspace{xxpt}b
a\hphantom{xyz}b % 占位字符宽度的空白
a\hfill b % 弹性长度
```

一些控制符

```latex
\# \$ \% \{ \} \~{} \_{} \^{} \textbackslash \&
```

引号

```latex
` ' `` '' % 对应‘ ’ “ ”
```

插图

```latex
\usepackage{graphicx}
\graphicspath{figures/} % 指定图像搜索路径

\includegraphics[选项]{文件名}
% 选项示例：scale=0.3 height=2cm width=2cm height=0.1\textheight width=0.2\textwidth angle=-45 用逗号隔开
```

### 表格

```latex
\begin{tabular}{|l|c|c|c|p{1.5cm}|r|} % 左对齐、居中、右对齐，竖线产生竖线
    \hline % 产生横线
    姓名 & 年龄 & a & b & c \\ % 不同列用&分割
    \hline % 产生横线
\end{tabular}
```

### 浮动

```latex
\ref{fig-1} % 引用标签
\begin{figure}[htbp]
    \centering % 居中排版

    \caption{插图标题}\label{fig-1} % 标签
\end{figure}

\begin{table}

\end{table}
```

### 数学公式

```latex
&f(x)&
&&f(x)$$
\(f(x)\)
\begin{math}f(x)\end{math}

\begin{displaymath}
f(x)
\end{displaymath}

\begin{equation} % 自动编号不加*，不自动编号加*
f(x)
\end{equation}
```

注意：可以用大括号进行分组，相当于合并作用。

上标：`^` 下标：`_`
希腊字母：`$\alpha$` `$\pi$` `$\Alpha$` `$\Pi$`
函数：`$\sin$` `$\arcsin$` `$\ln$` `$\ln$`
根号：`$\sqrt[2]{x}$`
分式：`$3/4$` `$\frac{3}{4}$`

### 矩阵

```latex
\usepackage{amsmath}

\begin{matrix} % pmatrix加小括号，bmatrix加中括号，Bmatrix加大括号，vmatrix加单竖线，Vmatrix加双竖线
    0 & 1 \\
    1 & 0
\end{matrix}
% 省略号：\dots \vdots \ddots
% 跨列省略号：\hdotsfor{4}
% 乘号：\times
% 在数学模式中使用文本：\text
% 合并多列：\multicolumn{2}{c}
% 行内小矩阵：\left(\begin{smallmatrix}...\end{smallmatrix}\right)
% 复杂矩阵使用array环境：@{内容}添加任意内容，不占表项计数
```

### 多行数学公式

```latex
\usepackage{amsmath}
\usepackage{amssymb}

\begin{gather} % 自动编号，带*不自动编号
    a + b = b + a \notag \\ % 阻止自动编号
    ab ba
\end{gather}

\begin{align} % 在指定&的位置自动对齐，也可选择*
    x &= 1 + 1 \\
    y^2 &= x
\end{align}

\begin{split} % 对齐采用align环境的方式，编号在中间
    \cos 2x &= \cos^2 x - \sin^2 x \\
    &= 2\cos^2 x - 1
\end{split}

\begin{cases} % cases的每行公式中使用&分割为两部分，表示值和后面的条件
    1, & \text{如果 } x \in \mathbb{Q}; \\
    0, & \text{如果 } x \in \mathbb{R}\setminus\mathbb{Q}.
\end{cases}
```

### 参考文献

#### 使用 BibTex

```latex
\begin{thebibliography}{编号样本}
    \bibitem[记号]{引用标志}文献条目1
    ...
\end{thebibliography}
% 使用\emph进行排版
% 使用\texttt引用网址
% 使用\cite{引用标志}引用文章
```

直接使用`\cite`引用：

```latex
\usepackage[round]{natbib} % 指定排版格式，提供\citep与\citet
\bibliographystyle{alpha} % plainnat

\cite{article}
```

#### 使用 BibLaTeX

参考文献样式文件`bbx`文件，引用样式文件`cbx`文件。
本地化排版：`biber -l zh__pinyin texfile`按拼音排序，`biber -l zh__stroke texfile`按笔画排序。

```latex
\usepackage[style=numeric,backend=biber,utf8,sorting = centy]{biblatex}
\addbibresource{test.bib}

\cite{biblatex} % 无格式化引用
\parencite{a1-1} % 带方括号的引用
\supercite{6-1} % 上标引用

\notice{*} % 列出没有引用的参考文献
\printbibliography[title = {参考文献}]
```

### 自定义命令

```latex
% \newcommand<命令>[参数个数][首参数默认值]{具体定义}
\newcommand\PRC{People's Republic of \emph{China}}

\PRC

\newcommand\loves[2]{#1 喜欢 #2}

\loves{爷}{甘雨}

% 只能为第一个参数指定默认值，因而第一个参数就成了可选参数
\newcommand\love[3][喜欢]{#2#1#3}

\love[最爱]{猫}{鱼}

\renewcommand % 重新定义命令
```

### 自定义环境

```latex
% \newenvironment{环境名称}[参数个数][首参数默认值]{环境前定义}{环境后定义}
% \renewenvironment{环境名称}[参数个数][首参数默认值]{环境前定义}{环境后定义}

\newenvironment{myabstract}[1][摘要]
{\small
    \begin{center}\bfseries #1\end{center}
    \begin{quotation}}
    {\end{quotation}}

\begin{myabstract}[我的摘要]
\end{myabstract}
```
