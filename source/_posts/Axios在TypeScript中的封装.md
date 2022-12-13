---
title: Axios在TypeScript中的封装
date: 2022-03-25 13:20:00
categories:
- React
- TypeScript
- 学习笔记
tags:
- React
- TypeScript
- 学习笔记
---

# Axios 在 TypeScript 中的封装

## 简介

在写 TS 应用的时候想着也用用熟悉的`axios`，但发现像 JS 那样调用会带来一系列问题，因此模仿其他人自己也封装了下

## 封装

```typescript
// request.ts
import { Interceptor } from "./interceptor";
import baseURL from "../config/index";
import { ERROR_CODE } from "../config/index";
import { message } from "antd";
export default class Request {
  public axios: any;

  constructor() {
    // 获取axios实例
    this.axios = new Interceptor().getInterceptors();
  }

  /**
   * get请求
   * @param {String} url [请求的url地址（去头）]
   * @param {object} params [请求时携带的参数, 默认为空]
   */
  public getData(url: string, params: object = {}) {
    return new Promise((resolve, reject) => {
      const config: any = { params };

      this.axios
        .get(baseURL + url, {
          ...config,
        })
        .then((res: any) => {
          this.resultHandle(res, resolve);
        })
        .catch((err: { message: any }) => {
          reject(err.message);
        });
    });
  }

  /**
   * post请求
   * get请求
   * @param {String} url [请求的url地址]
   * @param {object} data [请求时携带的参数, 默认为空]
   * @param {object} headers [自定义头部信息， 默认为空]
   */
  public postData(url: string, data: object, headers: object = {}) {
    return new Promise((resolve, reject) => {
      const config: any = {};

      let newData: any = data;

      this.axios
        .post(baseURL + url, (data = newData), {
          ...config,
          headers,
        })
        .then((res: any) => {
          this.resultHandle(res, resolve);
        })
        .catch((err: { message: any }) => {
          reject(err.message);
        });
    });
  }

  /**
   * resultHandle 根据响应code
   * @param {any} res [请求返回值]
   * @param {any} resolve [Promise.resolve]
   * @param {boolean} loading [判断是否是需要loading]
   */
  public resultHandle(
    res: any,
    resolve: {
      (value?: unknown): void;
      (value?: unknown): void;
      (arg0: any): void;
    }
  ) {
    if (res.code === "0") {
      resolve(res);
    } else {
      this.errorHandle(res);
      // tslint:disable-next-line:no-unused-expression
      resolve(res);
    }
  }

  /**
   * 服务端状态处理
   * @param {any} res [请求返回值]
   */
  public errorHandle(res: any) {
    const errorCode = res.data.status;
    // 错误处理
    switch (errorCode) {
      case ERROR_CODE.xxx:
        message.error("xxx");
        break;

      default:
        return res;
    }
  }
}
```

```typescript
// interceptor.ts
import axios from "axios";

export class Interceptor {
  private static errorHandle(res: any) {
    // 状态码判断
    switch (res.status) {
      case 401:
        break;
      case 403:
        break;
      case 404:
        break;
    }
  }

  public instance: any;

  constructor() {
    this.instance = axios.create({ timeout: 1000 * 12 });
    this.initInterceptors();
  }

  public getInterceptors() {
    return this.instance;
  }

  // 初始化拦截器
  public initInterceptors() {
    // 设置post请求头
    this.instance.defaults.headers.post["Content-Type"] = "application/json";
    /**
     * 请求拦截器
     * 每次请求前，如果存在token则在请求头中携带token
     */
    this.instance.interceptors.request.use(
      (config: { headers: { Authorization: string } }) => {
        const token = localStorage.getItem("token");
        if (token) config.headers.Authorization = token;
        return config;
      },
      (error: any) => {
        console.log(error);
      }
    );

    // 响应拦截器
    this.instance.interceptors.response.use(
      // 请求成功
      (res: { status: number; headers: object; data: { token: string } }) => {
        if (res.status === 200 || res.status === 304) {
          return Promise.resolve(res.data);
        } else {
          Interceptor.errorHandle(res);
          return Promise.reject(res.data);
        }
      },
      // 请求失败
      (error: { response: any }) => {
        const { response } = error;
        if (response) {
          // 请求已发出，但是不在2xx的范围
          Interceptor.errorHandle(response);
          return Promise.reject(response.data);
        } else {
          console.log("断网了");
        }
      }
    );
  }
}
```

## 使用

```typescript
const request = new Request();
const getArticleById = async (id: number) => {
  const result: any = await request.postData("/getArticleById", { id: id });
  return result.data;
};

// 函数式组件内
useEffect(() => {
  const fetchArticles = async () => {
    const result = await getArticleById(props.id);
    setArticle(result);
  };
  fetchArticles();
}, []);
```
