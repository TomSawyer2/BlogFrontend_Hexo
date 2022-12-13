---
title: Cookie&Session
date: 2021-10-26 23:33:00
categories:
- 浏览器
- 学习笔记
tags:
- 浏览器
- 学习笔记
---

# Cookie&Session

1. cookie 不可跨域名，因而本地跑 web 端应用时要把 same-site 关了。

2. cookie 的常见属性：

| 属 性 名       | 描 述                                                                                                                                                                                                             |
| -------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| String name    | 该 Cookie 的名称。Cookie 一旦创建，名称便不可更改                                                                                                                                                                 |
| Object value   | 该 Cookie 的值。如果值为 Unicode 字符，需要为字符编码。如果值为二进制数据，则需要使用 BASE64 编码                                                                                                                 |
| **int maxAge** | **该 Cookie 失效的时间，单位秒。如果为正数，则该 Cookie 在 maxAge 秒之后失效。如果为负数，该 Cookie 为临时 Cookie，关闭浏览器即失效，浏览器也不会以任何形式保存该 Cookie。如果为 0，表示删除该 Cookie。默认为–1** |
| boolean secure | 该 Cookie 是否仅被使用安全协议传输。安全协议。安全协议有 HTTPS，SSL 等，在网络上传输数据之前先将数据加密。默认为 false                                                                                            |
| String path    | 该 Cookie 的使用路径。如果设置为“/sessionWeb/”，则只有 contextPath 为“/sessionWeb”的程序可以访问该 Cookie。如果设置为“/”，则本域名下 contextPath 都可以访问该 Cookie。注意最后一个字符必须为“/”                   |
| String domain  | 可以访问该 Cookie 的域名。如果设置为“.google.com”，则所有以“google.com”结尾的域名都可以访问该 Cookie。注意第一个字符必须为“.”                                                                                     |
| String comment | 该 Cookie 的用处说明。浏览器显示 Cookie 信息的时候显示该说明                                                                                                                                                      |
| int version    | 该 Cookie 使用的版本号。0 表示遵循 Netscape 的 Cookie 规范，1 表示遵循 W3C 的 RFC 2109 规范                                                                                                                       |

如果 maxAge 属性为正数，则表示该 Cookie 会在 maxAge 秒之后自动失效。如果 maxAge 为负数，则表示该 Cookie 仅在本浏览器窗口以及本窗口打开的子窗口内有效，关闭窗口后该 Cookie 即失效。如果 maxAge 为 0，则表示删除该 Cookie。

3. 如果要修改某个 Cookie，只需要新建一个同名的 Cookie，添加到 response 中覆盖原来的 Cookie。

4. 如果要删除某个 Cookie，只需要新建一个同名的 Cookie，并将 maxAge 设置为 0，并添加到 response 中覆盖原来的 Cookie。注意是 0 而不是负数。

注意：修改、删除 Cookie 时，新建的 Cookie 除 value、maxAge 之外的所有属性，例如 name、path、domain 等，都要与原 Cookie 完全一样。否则，浏览器将视为两个不同的 Cookie 不予覆盖，导致修改、删除失败。

5. 如果想所有同一域名下的二级域名都可以使用 Cookie，需要设置 Cookie 的 domain 参数。

```js
Cookie cookie = new Cookie("time","20080808"); // 新建Cookie

cookie.setDomain(".helloweenvsfei.com");           // 设置域名

cookie.setPath("/");                              // 设置路径

cookie.setMaxAge(Integer.MAX_VALUE);               // 设置有效期

response.addCookie(cookie);                       // 输出到客户端
```

6. **一般不把密码等重要信息保存到 Cookie 中。**

7. Session 对象是在客户端第一次请求服务器的时候创建的。

8. session 的常用方法：

| 方 法 名                                          | 描 述                                                                                                                        |
| ------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------- |
| void setAttribute(String attribute, Object value) | 设置 Session 属性。value 参数可以为任何 Java Object。通常为 Java Bean。value 信息不宜过大                                    |
| String getAttribute(String attribute)             | 返回 Session 属性                                                                                                            |
| Enumeration getAttributeNames()                   | 返回 Session 中存在的属性名                                                                                                  |
| void removeAttribute(String attribute)            | 移除 Session 属性                                                                                                            |
| String getId()                                    | 返回 Session 的 ID。该 ID 由服务器自动创建，不会重复                                                                         |
| long getCreationTime()                            | 返回 Session 的创建日期。返回类型为 long，常被转化为 Date 类型，例如：Date createTime = new Date(session.get CreationTime()) |
| long getLastAccessedTime()                        | 返回 Session 的最后活跃时间。返回类型为 long                                                                                 |
| int getMaxInactiveInterval()                      | 返回 Session 的超时时间。单位为秒。超过该时间没有访问，服务器认为该 Session 失效                                             |
| void setMaxInactiveInterval(int second)           | 设置 Session 的超时时间。单位为秒                                                                                            |
| void putValue(String attribute, Object value)     | 不推荐的方法。已经被 setAttribute(String attribute, Object Value)替代                                                        |
| Object getValue(String attribute)                 | 不被推荐的方法。已经被 getAttribute(String attr)替代                                                                         |
| boolean isNew()                                   | 返回该 Session 是否是新创建的                                                                                                |
| void invalidate()                                 | 使该 Session 失效                                                                                                            |

9. Session 中禁止使用 Cookie。

10. 区别：

11. cookie 数据存放在客户的浏览器上，session 数据放在服务器上。
12. cookie 不是很安全，别人可以分析存放在本地的 COOKIE 并进行 COOKIE 欺骗考虑到安全应当使用 session。
13. 设置 cookie 时间可以使 cookie 过期。但是使用 session-destory（），我们将会销毁会话。
14. session 会在一定时间内保存在服务器上。当访问增多，会比较占用你服务器的性能考虑到减轻服务器性能方面，应当使用 cookie。
15. 单个 cookie 保存的数据不能超过 4K，很多浏览器都限制一个站点最多保存 20 个 cookie。(Session 对象没有对存储的数据量的限制，其中可以保存更为复杂的数据类型)
16. Session 的运行依赖 Session ID，而 Session ID 是存在 Cookie 中的，也就是说，如果浏览器禁用了 Cookie，Session 也会失效（但是可以通过其它方式实现，比如在 url 中传递 Session ID）。
