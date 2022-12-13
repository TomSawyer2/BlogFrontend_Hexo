---
title: React Hooks
date: 2022-03-20 13:20:00
categories:
- React
- 学习笔记
tags:
- React
- 学习笔记
---

# React Hooks 学习

## 简介

React Hooks 是 React 在最近几个大版本中提出的新概念，其中最关键的点就在于可以用函数式组件替代原来的`Class`式组件，从而使组件更轻量化，新的博客[博客 - TomSawyer2](https://novel.tomsawyer2.xyz)即使用 React + Umi + TS 的重构

## 组件基本定义与使用

```typescript
const MyComponent: React.FC<MyProps> = () => {
  return <></>;
};

export default MyComponent;
```

## useState

`useState`其实就是`getter`和`setter`组成的一个数组，类似于 Vue2 中的`data`和 Vue3 中的`reactive()`

```typescript
const [shouldRender, setShouldRender] = useState<boolean>(false);

// 获取state中shouldRender的值
console.log(shouldRender);

// 向state中新设置一个shouldRender值
setShouldRender(true);
```

## useEffect

副作用 Hook，最基本的使用是模拟各类生命函数

```typescript
useEffect(() => {
  console.log("mounted");
  return () => {
    console.log("updated");
  };
}, []);
```

当然在数组里传入想监听的值就可以实现`watch`的功能

## useRef

提供类似于 Vue 中`ref`的功能，不过 React 这里用起来麻烦一点，如果要循环绑定`ref`可以使用`use-dynamic-refs`这个库，如下绑定`ref`

```typescript
const [getRef, setRef] = useDynamicRefs();

// 获取ref
getRef(origin.index.toString()) as RefObject<HTMLDivElement>

// 设置ref
ref={setRef(idx.toString()) as LegacyRef<HTMLDivElement>}
```

## useCallback

在指定监听值发生变化后触发回调

## useMemo

用于记忆某些指定的值，当这些值改变时才触发回调

```typescript
return useMemo(() => {
  return <div>{state}</div>;
}, [state]);
```

上述例子中只有`state`发生改变后才会重新渲染

## useContext

`Context`可以提供一个变量的全局访问点，类似于`Redux`或者`VueX`或者`provide/inject`

```typescript
// top module
export const fullScreenContext = createContext({});

return (
  <fullScreenContext.Provider value={{ value }}>
    <Component />
  </fullScreenContext.Provider>
);
```

```typescript
// inner module
import { fullScreenContext } from "xxx";

const { value } = useContext<any>(fullScreenContext);
```

**注意**：`Context`提供的数据流很方便，但会经常渲染子组件，带来性能问题，可以通过`useMemo`的方式进行优化，或者把`Context`的大小压到最小
