---
layout: posts
title: es6主要特性小结
date: 2019-04-11 14:58:51
tags:
  - es6
---

ECMAScript 6（以下简称ES6）是JavaScript语言的下一代标准。因为当前版本的ES6是在2015年发布的，所以又称ECMAScript 2015。

Babel是一个广泛使用的ES6转码器，可以将ES6代码转为ES5代码，从而在现有环境执行。

let：`let`实际上为JavaScript新增了块级作用域。用它所声明的变量，只在`let`命令所在的代码块（花括号）内有效；与`var`的区别是，`var`用来做循环的计数变量，会泄露成全局变量，在外部调用的值是循环完成后的值。

const：声明变量，但声明的是**常量**，一旦声明，常量的值不能改变。

<!-- more -->

class：定义一个类，可定义构造方法在其中，构造方式`this`关键字指向实例。`constructor`内定义的方法和属性是**实例对象**自己的，而`constructor`外定义的方法和属性则是**所有实例对象可以共享**的。

extends：`class`之间可用`extends`关键字实现继承

super：指代父类的实例（即父类的this对象）。子类必须在`constructor`中调用·方法，否则新建实例就会报错，因为子类没有自己的`this`对象，而是继承父类的`this`对象，然后对其进行加工。

> ES6的继承机制，实质是先创造父类的实例对象`this`（所以必须先调用`super`方法），然后再用子类的构造函数修改`this`。

arrow function：箭头函数 `(i)=> i+1`;箭头函数体内的this对象指向定义时所在的对象（箭头函数内无自己的`this`，其`this`继承外面的作用域）

template string：用反引号（ &#96; ）来标识起始，用`${}`来引用变量，所有的空格和缩进都会被保留在输出之中

destructuring：从数组和对象中提取值，对变量进行赋值，这被称为解构（Destructuring）。

```js
// 解构
let cat = 'ken'
let dog = 'lili'
let zoo = {cat, dog}
console.log(zoo)  //Object {cat: "ken", dog: "lili"}

// 赋值
let dog = {type: 'animal', many: 2}
let { type, many} = dog
console.log(type, many)  //animal 2
```

default：变量未赋值时给该变量一个默认值

```js
function animal(type = 'cat') {
  console.log(type)
}
animal()  //cat
```

rest：过滤变量

```js
function animals(once, ...types){
  console.log(types)
}
animals('cat', 'dog', 'fish')   //[ "dog", "fish"]
```

import export：es6的模块化机制， import用于导入模块，可以选择性导入模块中的一部戏属性/方法，也可给导入的模块重命名；export用于导出模块，也多次导出，任何数据类型都可导出（变量、函数、类等..）。

基本使用
```js
//index.js
import animal from './content'
console.log(animal) // A cat

//content.js
export default 'A cat'
```

多次导出，导入模块时使用 `as` 重命名 `type` 为 `animalType`
```js
//content.js
export default 'A cat'
export function say(){
  return 'Hello!'
}
export const type = 'dog';

//index.js
import animal, { say, type as animalType } from './content'
let says = say()
console.log(`The ${animalType} says ${says} to ${animal}`)
//The dog says Hello to A cat
```