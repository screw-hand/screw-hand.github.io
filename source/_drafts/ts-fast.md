---
title: ts快速入门
date: 2021-12-24 12:52:37
categories: ts
tags:
---

<!--
- ts 简述 优点
- tsc（最简单的环境）
- vscode中的ts
- 基本语法
  1. 基本类型
  2. export、类型推断、类型定义 √
  3. 类型层级 void unkown any never null、类型检测
  4. 构造函数
  - type 联合类型 具体值
- 进阶
  - 函数，可选参数，函数默认值、剩余函数、重载
  - 元组 enum interface 泛型 class
  - type or interface
  - *ts真的太麻烦了吗？ （合理使用类型推断） 预言家
  - 内置泛型
  - 内置方法
  - !. ?? as  // @ts-ignore
- 项目工程
  - js版本问Z题
  - 类型定义文件
  - declare能在d.ts文件之外使用吗？
  - typescript/lib
  - @types
  - tsconfig
  - tsx
-->

## 简述

`typescript`是由Microsoft在2014年开发的一门语言，是`Javascript`的超集，相比`Javascript`，`typescript`拥有了**类型检测**系统，是一门**强类型**的**编译语言**。仅仅是有了类型检测系统，就能大大提高项目的代码的健壮性，ts有如下优点：

1. 更快的捕获错误：在开发阶段，类型检测若失败，则会编译失败，而不是在生产环境中代码运行报错
2. 阶梯式的使用门槛：项目中，typescript可与javascript共存，js也是合法的ts代码
3. 更好的智能语法提示：typescript的类型检测机制使得代码编辑器的代码提示更加精确
4. 提高重构的便携性：重构函数、组件时，不再需要肉眼、人脑分析每次调用的地方，若有问题，编译失败

*js的类型检测解决方案不止typescript，还有[flow](https://github.com/facebook/flow)等。*

官网：https://www.typescriptlang.org

源码：https://github.com/microsoft/TypeScript

<!-- more -->

## 安装typescript

https://www.typescriptlang.org/download

我们可以用node的包管理工具（npm、yarn、pnpm）安装ts。


示例源码：[003-ts-fast](https://github.com/screw-hand/demo-fragment/tree/main/003-ts-fast)


### 准备

新建目录，`npm init`以初始化`package.json`。

```bash
Chris@DARK-FLAME /d/source_code/_github/demo-fragment (dev)
λ mkdir 003-ts-fast
Chris@DARK-FLAME /d/source_code/_github/demo-fragment (dev)
λ cd 003-ts-fast/
Chris@DARK-FLAME /d/source_code/_github/demo-fragment/003-ts-fast (dev)
λ npm init -y
(node:11764) ExperimentalWarning: The fs.promises API is experimental
Wrote to D:\source_code\_github\demo-fragment\003-ts-fast\package.json:

{
  "name": "003-ts-fast",
  "version": "1.0.0",
  "description": "",
  "main": "index.js",
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "keywords": [],
  "author": "",
  "license": "ISC"
}


```

使用自己习惯包管理器安装typescript，这里我以**开发依赖**的性质安装在项目中。

```bash
Chris@DARK-FLAME /d/source_code/_github/demo-fragment/003-ts-fast (dev)
λ npm i typescript -D
(node:11708) ExperimentalWarning: The fs.promises API is experimental

added 1 package in 2s
Chris@DARK-FLAME /d/source_code/_github/demo-fragment/003-ts-fast (dev)
λ ./node_modules/.bin/tsc
Version 4.5.4
```

安装完typescript依赖后，typescript除了核心的功能，还提供了`tsc`、`tsserver`两个命名供开发者使用，前者是ts编译器相关比较常用；后者是ts语言服务，不怎么使用。

### 全局依赖与项目依赖

为什么是 `./node_modules/.bin/tsc`，的方式使用命令？

——因为把typescript安装在了项目中，而不是全局环境，所以需要显式的指定命令行的路径。（所有的项目依赖包，若有提供命令行，都在`./node_modules/.bin`的目录里。

**个人建议node的包优先安装在项目中，而不是全局。因为全局环境只有一个，项目环境有问题随时可以再新开一个目录，全局环境比较宝贵，只有一个。**

如果想把tsc安装在全局，也可以。

```bash
Chris@DARK-FLAME /d/source_code/_github/demo-fragment/003-ts-fast (dev)
λ npm i typescript@4.1.6 -g
(node:10564) ExperimentalWarning: The fs.promises API is experimental

added 1 package in 2s
Chris@DARK-FLAME /d/source_code/_github/demo-fragment/003-ts-fast (dev)
λ tsc -v
Version 4.1.6
Chris@DARK-FLAME /d/source_code/_github/demo-fragment/003-ts-fast (dev)
λ ./node_modules/.bin/tsc -v
Version 4.5.4
```

全局安装了v4.1.6，项目安装了4.5.4。（这里故意安装不同版本以区分）

## 基本概念

`typescript`的基本环境已经准备好了，可以编写ts代码了。这里先从js的基本类型开始，新建一个`1-base.ts`的文件，注意文件命后缀是`.ts`。

```typescript
/* 1-base.ts */

let n = null
let udf = undefined
let num = NaN
let str = ''
let bool = true
let obj = {}
let arr = []
let fn = function (a) {
  return a++
}
function fn2(a) {
  return a--
}
let arrowFn = (a) => typeof a

console.log({
  n,
  udf,
  num,
  str,
  bool,
  obj,
  arr,
  'fn(udf)': fn(udf),
  'fn2(num)': fn(num),
  'arrowFn(bool)': arrowFn(bool)
})
```

内容目前来跟`js`**一点区别都没有**，先将其编译成`js`, 然后查看编译后的代码是什么样的，再执行成代码。

```bash
Chris@DARK-FLAME /d/source_code/_github/demo-fragment/003-ts-fast (dev)
λ ./node_modules/.bin/tsc 1-base.ts
Chris@DARK-FLAME /d/source_code/_github/demo-fragment/003-ts-fast (dev)
λ node 1-base.ts
{ n: null,
  udf: undefined,
  num: NaN,
  str: '',
  bool: true,
  obj: {},
  arr: [],
  'fn(udf)': NaN,
  'fn2(num)': NaN,
  'arrowFn(bool)': 'boolean' }
```

用`./node_modules/.bin/tsc`编译`1-base.ts`，结果输出`1-base.js`使用node运行此代码。

![1-base.ts](./ts-fast/1-base.ts.png)

对比：压缩空行（line: 2）， `let`编译成了`var`。`let`编译成`var`是因为`tsc`编译器默认使用的是低版本的`javascript`，之后会设置一下。


### 类型定义

```typescript
let/var/const [variable]: [date type] = [value];

let/var/const [function name] = function ([arguments]: [date type], ...[arguments]: [date type]): [return data type] {
  return [value]
}

function [function name]([arguments]: [date type], ...[arguments]: [date type]): [return data type] {
  return [value]
}

let/var/const [function name] = ([arguments]: [date type], ...[arguments]: [date type]): [return data type] => {
  return [value]
}
```

### 类型推断

事实上，在声明变量的时候，typescript会根据变量值的初始值推断变量的数据类型，故此ts中所有的变量/函数/类，都是有声明数据类型的。

![类型推断](./ts-fast/1-base.ts-hover.png)

事实上`1-base.ts`，就已经有了类型检测。**当开发者没有显性指定数据类型，ts会根据变量初始值的数据类型推断此变量的数据类型， 这也称之为类型推断。**

### 类型检测

什么是类型检测？就是开发者希望、清醒得知道——指定的变量的数据类型为某个类型，就可以显性指定数据类型，**ts编译器会检测变量的实际数据类型跟指定数据类型是否一致、合理**，若不一致，则编译失败，报错。

```typescript
/* 2-type.ts */

let n: null = null
let udf: undefined = undefined
let num: number = NaN
let str: string = ''
let bool: boolean = true
let obj: {} = {}
let arr: any[] = []
let fn = function (a: any): number {
  return a++
}
function fn2(a: any): number {
  return a--
}
let arrowFn = (a: any): any => typeof a
```

复制了`1-base.ts`的代码，显性声明了数据类型。（记得编译后执行）

*如果在这里发生了变量重名，回去`1-base.ts` 追加`export {}`。ts默认是全局脚本，没有模块化。当使用了`export`语法后，此脚本才会成为一个模块。建议编写ts代码，就算不导出任何东西，也追加`export {}`，以免出现不必要的错误。*

![2-type.png](./ts-fast/2-type.png)

明知故犯： num、str、bool、arr、故意赋值错误，**虽然编译错误，但是也会输出`2-type.js`。**

### 数据类型

ts除了提供js的六大基本类型（null undefined number string boolean object），还扩展了这几个特殊的数据类型：any unknown viod never。

- `any` 允许赋值为任意类型，可以访问任意属性和方法，**相当于没有进行类型检查而直接通过编译阶段的检查**，实际开发中应尽量避免使用
- `unknown` 类似于`any`，只允许赋值给`any`类型和`unknown`类型，也不允许访问属性、运算、调用等；使用时，我们必须将其细化为某种具体类型，否则将产生编译错误。
- `void` 没有任何类型，用于没有返回值的函数，只能赋值为`undefined`、`null`
- `nver` 永远不会有值的一种类型，用于抛出异常或不会有返回值的函数



![any_unknown](./ts-fast/any_unknown.png)

![viod_never](./ts-fast/viod_never.png)

`null`、`undefined` 默认可以互相赋值，不严格区分，除非启动了--strictNullChecks选项，

TODO: 截图 3-diff.ts n udf 互相赋值 开启--strictNullChecks选项。

### 构造造函数

这里其实要讨论的是`new String()`、`String()`、`String`、`[string](''|'string')`的联系与区别，这四个分别代表实例、函数调用、构造函数、直面量。

```bash
> typeof new String()
'object'
> new String() instanceof String
true
> typeof String()
'string'
> String instanceof Function
true
> typeof String
'function'
> typeof ''
'string'
>
```

**`String`是一个`Funciton`————构造函数，构造函数可以使用`new`关键调用生成实例，也可以直接单作函数调用。**

根据以上，我们可以得知关于`string`类型的原型链：

> [string](true|false) > String > Function > Object > null

ts中如果想定义一个实例的数据类型，应该使用定义实例的具体数据类型`String`，不需要`new String`。

```typescript
let newStr: new String = new String() // 错误的用法
let Str:        String = ''
```

而`String`、`Function`是不同的数据类型，ts中会区别对待，不能互相赋值。

`String`相对宽容，能赋值`string`的直面量数据类型，也能实例。

`string`只能使用直面量赋值，不管是实例还是调用构造函数的结果，都不可以。

TODO 截图 `4-constructor.ts`

**实际开发中，一般是用直面量的方式比较多，如果需要使用构造函数的方法，使用完后转换成直面量的方法即可。**

### 类型别名 联合类型 具体值

除了上述的基本类型，**可以使用`type`关键字来声明一个数据类型，这称之为类型别名，一般用于将需要复用的类型统一保存起来，保存的类型可以是原生提供的，也可以是自己定义的。**

```typescript
type myStr = string

let myStr: myStr = ''
myStr = 'myStr'
```

**联合类型，指的是一个变量不仅可以是一种数据类型，也可以是多种数据类型的其中一种。使用`|`不同的数据类型。**

```typescript
let strOrNum: string | number = ''
strOrNum = 1
```

**当我们知道某个变量是某个数据类型的具体值（比如1、2、3）时，我们可以限定这个变量为具体的值。**

```typescript
let oneToThre: '' | 1 | 2 | 3 = ''
oneToThre = 1
oneToThre = 2
oneToThre = 3
```

而且这三个特性都可以结合使用的。

```typescript
/* 5-skill.ts */

type myStr = string

type strOrNum = string | number

type oneToThre = '' | 1 | 2 | 3 | strOrNum

let myStr: myStr = ''
myStr = 'myStr'

let strOrNum: strOrNum = ''
strOrNum = 1

let oneToThre: oneToThre = ''
oneToThre = 1
oneToThre = 2
oneToThre = 3
```

## 进阶

### 函数

形参类型、可选参数、默认参数、解构、返回类型。

<!-- TODO 截图 6-fn.ts -->

> 重载函数是指一个函数同时拥有多个同类的函数签名。例如，一个函数拥有两个及以上的调用签名，或者一个构造函数拥有两个及以上的构造签名。当使用不同数量和类型的参数调用重载函数时，可以执行不同的函数实现代码。

简单来讲就是重载可以让函数拥有多条规则的类型定义，可以让ts根据实际情况兼容。

箭头函数。

<!-- TODO 截图 6-fn.ts -->

### 接口

描述对象，最灵活的特性之一。

跟类型别名的区别。

### 泛型

泛型可以理解为——**动态的函数实参类型**，类似于声明一个变量。定义函数的时候，使用变量对实参的数据类型进行占位，在调用的函数的时候，传入实际的数据类型，赋值给此变量，此时变量才拥有真正的数据类型。

使用场景：在使用某个函数的时候，函数实参的数据类型是没办法在定义函数的时候确定的，只有在使用函数的时候，才能确定函数实参的数据。

泛型的定义语法为尖括号内使用大写母————`<T>`，然后放在函数名后面，这样我们就声明了一个“动态的数据类型变量”，这个变量T可以在此函数区域内任意使用。

```ts
function fn<T>(arg: T): T {
  return arg
}
```

***fn函数使用了泛型T，希望形参arg的数据类型也是T，以及fn返回的结果数据类型也是T。**

使用泛型是在调用函数的时候，在尖括号内给泛型赋予真正的数据类型即可。

```ts
fn<number>(1)
fn<string>('')
fn<null>(null)
fn<undefined>(undefined)
```

```ts
fn<boolean>(NaN)
/**
 * Argument of type 'number' is not assignable to parameter of type 'boolean'.ts(2345)
 */
```


## 项目工程



...



参考资料
- [Typescript Duplicate Function Implementation](https://stackoverflow.com/a/69740928)
- [TS 类型中的 any、void 和 never](https://juejin.cn/post/6844904126019534861)
