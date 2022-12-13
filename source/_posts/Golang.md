---
title: Golang
date: 2022-05-01 13:20:00
categories:
- Golang
- 学习笔记
tags:
- Golang
- 学习笔记
---

# Golang

## Before Learning

作为新时代的 C 语言，听闻 Go 集便捷与快速于一体，加上某 724 号正式队员对 Go 的极力赞赏，于是抓紧学一手，_指不定下个版本的博客后端就是 Go 写的_

## 编译与运行

```bash
go build test.go // 生成test.exe
// or
go run test.go // 直接运行
```

## 变量定义

```golang
// 类似于ts的定义方式
var num int = 1
// 自动推断类型，若变量已存在则赋值
num := 1

const Pi float64 = 3.1415926
```

## 变量类型转换

```golang
str := '123'
reflect.TypeOf(int(str)) // int
```

## 常量声明

常量可以无类型，会自动转换类型

```golang
const (
  a = 1
  b
  c = 2
  d
)

// 1 1 2 2
```

## iota 常量生成器

类似 excel 下拉

```golang
type Weekday int

const (
  Sunday Weekday = iota
  Monday
  Tuesday
  Wednesday
  Thursday
  Friday
  Saturday
)
// 0 1 2 ...
```

## 函数定义

```golang
// 类似于ts的定义方式
// 入参为int arg1， string arg2， 剩余入参string型分配到args
func myFunc(arg1 int, arg2 string, args ...string) (res1, res2) {
    return 1, '123'
}
```

注：变量、常量、函数名首字母为大写时可以在外部直接调用

注：如果函数的入参仅为变长参数，而且传参时只传一个切片，可以`(param1...)`

## 函数引用

```golang
res, _ = func()
// _会被忽略，不会被识别为unusedvar
```

通常第二个返回值为`err`，但默认不报错时也会返回`nil`，所以要加上`if err != nil`对每个返回值进行判断

## 指针

与 C 语言基本上一样

```golang
a := 1
b := &a // b是指向a的指针
c := *b // c是b指向的值，即a的值
```

非常神奇的特性：可以返回一个指向函数局部变量的指针，并且不管作用域在哪都可以通过指针访问这个局部变量（有点像闭包？）

## 包

### 本地编写与调用

文件系统结构：`/bin`保存可执行程序，`/pkg`保存已编译的包代码，`/src`保存源代码

在一个包的文件夹里可以存在多个文件，并且都将称为包的一部分

注：包的目录应该与包同名

```golang
// test.go
greeting.Hello()
greeting.Hi()
```

```golang
// /src/greeting/greeting.go
package greeting // 包的名称为greeting

import "fmt"

func Hello() { // 函数名大写以在外部调用
  fmt.Println("hello")
}

func Hi() {
  fmt.Println("hi")
}
```

**命名规则**

- 包名全部小写
- 尽可能用一个词，如果用多个词不要隔开，也不要大写

`go install /xxx`会将`xxx`文件夹下的文件打包成可执行程序并放在`/bin`内

注：指令默认在`/sdk`内部寻找文件夹，但一般程序肯定不会写在`/sdk`里，需要手动指定`GOPATH`，`set GOPATH="F:\xxx"`，此种方法设置的`GOPATH`只对当前 terminal 生效

### GitHub 上调用

```golang
// 这个位置的仓库就是一个包的文件夹
import "github.com/username/module_name"
```

本地安装对应库：`go get github.com/username/module_name`，会安装在`/src`目录下

显示包的文档：`go doc module_name`
显示具体函数的文档：`go doc module_name func_name`

在包/函数前面加注释即可作为`doc`的内容添加

**注释规范**

- 包注释应以`Package`开头，后跟包名
- 函数注释应以描述的函数名开头

在本地起服务器以 Web 页面的形式查看所有包的注释：`godoc -http=:port`

## 数组

注：数组是定长的

```golang
var arr [4]string

var numArr [3]int = [3]int{1, 2, 3}
numArr := [3]int{1, 2, 3}
```

数组初始化时所有值默认为类型的零值，`int`类型用 0 填充，`string`类型用''填充

访问越界会导致`panic`，这是在运行时而不是编译时发生的错误

获取数组长度：`len(numArr)`

```golang
for i, val := range arr {
  fmt.Println(i, val)
}
```

## 文件读取

```golang
file, err = os.Open(xxx)
if err != nil {
  log.Fatal(err)
}

scanner := buffio.NewScanner(file)

for scanner.Scan() { // 一次读取一行，读完后返回false
  fmt.Println(scanner.Text())
}

// 关闭文件
err = file.Close()
if err != nil {
  log.Fatal(err)
}

// 读取时的错误
if scanner.Err() != nil {
  log.Fatal(scanner.Err())
}
```

## 切片

切片就是不定长的数组

```golang
var mySlice []string // 声明切片变量
mySlice = make([]string, 7) // 创建长度为7的字符切片
// or
mySlice := make([]string, 7)
```

字面量赋值

```golang
notes := []string{"1", "2"}
```

切片的实现：`mySlice := myArr[1:3]`切片从 1 开始直到 3 的前一个元素
切片的底层实际上就是一个数组，不过被截取了部分展示出来，因此底层数组的修改也会影响到切片

```golang
arr := []int{1, 2}
arr = append(arr, 3) // arr -> [1, 2, 3]
```

注：通常要在`append`之后将数组重新赋值给原变量，这是为了防止多个切片同时共享同一个底层数组时出现底层数组长度不够而自动扩容导致元素混乱的问题 _js 的`push()`方法是怎么实现的呢 🧐_

注：切片变量的默认值为`nil`，默认为空

## 读取命令行

```golang
fmt.Println(os.Args)
```

## Map

```golang
var myMap map[string]int // map[键类型]值类型
myMap = make(map[string]int)
// or
myMap := make(map[string]int)
```

字面量赋值

```golang
myMap := map[string]int{"a": 1, "b": 2}
```

```golang
myMap := make(map[string]int)
myMap["123"] = 123

val, ok := myMap["123"]
fmt.Println(val, ok) // 123 true 此处通过获取第二个返回值判断该值是否为初始值
val, ok = myMap["111"]
fmt.Println(val, ok) // 0 false
```

删除键值对：`delete(myMap, "key")`

通过`for range`语法遍历得到的结果顺序不固定，因此可以通过先取出键，对键排序后再根据键取值的方式来固定顺序，根据字母表排序的方式：`sort.Strings(strs)`

## 结构体

```golang
struct {
  field1 string
  field2 int
}
```

```golang
var myStruct struct{
  id int
  name string
  email string
}
```

结构体成员名称大写开头是导出的

结构体不能包含自身，但可包含自身的指针

### 结构体嵌入和匿名成员

通过匿名成员可以直接把对应结构体的变量引入其他结构体，引用更加方便

**注意：** 匿名成员的变量名需要导出，否则也不能进行操作

```golang
type Point struct {
  X, Y int
}

type Circle struct {
  Point
  Radius int
}

type Wheel struct {
  Circle
  Spokes int
}

var w Wheel
// w.X w.Y w.Radius
```

## JSON

```golang
type Movie struct {
  Title string
  Year int `json:"released"`
  Color bool `json:"color,omitempty"`
}
```

输出格式化后的 json，可以标志缩进量

```golang
data, err := json.MarshalIndent(item, "", "    "); err {
  // error handler
}
```

类型后的字段是 tag，第一部分表示解码后 json 的 key，第二部分的`omitempty`表示如果没有对应值则删除该 key

## 文本和 HTML 模板语法

文本模板

```golang
const templ = `{{.TotalCount}} issues:
{{range .Items}}----------------------------------------
Number: {{.Number}}
User:   {{.User.Login}}
Title:  {{.Title | printf "%.64s"}}
Age:    {{.CreatedAt | daysAgo}} days
{{end}}`

func daysAgo(t time.Time) int {
  return int(time.Since(t).Hours() / 24)
}

// 将daysAgo的值进行转化后创建文本模板
report, err := template.New("report").
  Funcs(template.FuncMap{"daysAgo": daysAgo}).
  Parse(templ)
if err != nil {
  log.Fatal(err)
}
```

将文本模板转换为 HTML

```golang
import "html/template"

var issueList = template.Must(template.New("issuelist").Parse(`
<h1>{{.TotalCount}} issues</h1>
<table>
<tr style='text-align: left'>
  <th>#</th>
  <th>State</th>
  <th>User</th>
  <th>Title</th>
</tr>
{{range .Items}}
<tr>
  <td><a href='{{.HTMLURL}}'>{{.Number}}</a></td>
  <td>{{.State}}</td>
  <td><a href='{{.User.HTMLURL}}'>{{.User.Login}}</a></td>
  <td><a href='{{.HTMLURL}}'>{{.Title}}</a></td>
</tr>
{{end}}
</table>
`))
```

生成 HTML

```golang
$ go build gopl.io/ch4/issueshtml
$ ./issueshtml repo:golang/go commenter:gopherbot json encoder >issues.html
```

特殊字符会自动转义，可以通过对信任的 HTML 字符串使用 template.HTML 类型来抑制这种自动转义的行为

```golang
const templ = `<p>A: {{.A}}</p><p>B: {{.B}}</p>`
t := template.Must(template.New("escape").Parse(templ))
var data struct {
  A string        // untrusted plain text
  B template.HTML // trusted HTML
}
data.A = "<b>Hello!</b>"
data.B = "<b>Hello!</b>"
if err := t.Execute(os.Stdout, data); err != nil {
  log.Fatal(err)
}
```
