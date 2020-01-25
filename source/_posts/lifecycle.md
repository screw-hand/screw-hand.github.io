---
title: vue技巧篇：生命周期
categories: vue
tags: vue-skill
date: 2020-01-25 22:17:01
---

## 前言

> 每个 Vue 实例在被创建时都要经过一系列的初始化过程——例如，需要设置数据监听、编译模板、将实例挂载到 DOM 并在数据变化时更新 DOM 等。同时在这个过程中也会运行一些叫做**生命周期钩子**的函数，这给了用户在不同阶段添加自己的代码的机会。

其实对生命周期而言，我们要搞懂的是。

1. 什么阶段初始化数据
2. 什么阶段初始化事件
3. 什么阶段渲染DOM
4. 什么阶段挂载数据

<!-- more -->

## 生命周期图示

![b3251a15e5779fcfec925b78a149f5c8.png](en-resource://database/2632:1)
![lifecycle](./lifecycle.png)

生命周期钩子函数可以分成6个类型，除了一个最少用的子孙组件错误钩子函数。
每个类型都有 "beforeXX" "XXed"，总共有11个生命周期钩子函数。

1. 创建： beforeCreate     created
2. 挂载：beforeMount     mounted
3. 更新：beforeUpdate     updated
4. 销毁：beforeDestroy     destroyed
5. 激活：activated     deactivated
6. 错误：errorCaptured

TODO： markdown表格合并单元格

| 序 | 类型 | 钩子函数名 | 钩子函数名 |
| --- | --- | :--- | :--- |
| 1 | 创建 | beforeCreate  | created |
| 2 | 挂载 | beforeMount  | mounted |
| 3 | 更新 | beforeUpdate | updated |
| 4 | 销毁 | beforeDestroy | destroyed |
| 5 | 激活 | activated | deactivated |
| 6 | 错误 | errorCaptured |  |

生命周期钩子官方api [传送门](https://cn.vuejs.org/v2/api/#%E9%80%89%E9%A1%B9-%E7%94%9F%E5%91%BD%E5%91%A8%E6%9C%9F%E9%92%A9%E5%AD%90)

别看有11个钩子函数，看似一时间难以掌握。
其实也不是很需要全部掌握，常用的就那么几个。
这几个钩子函数会一一介绍，也会先大家演示一遍完整的生命周期。
且实际开发中我们更在意的是，这些钩子函数对组件实例数据/事件的影响。

## 完整的生命周期

这一章基本是在翻译生命周期图示的内容。
不过很多开发者都对完整的生命周期流程一知半解。
虽然此文提供源码，还是**建议每个人按照自己的理解写一下实例。**

**定义一个lifecycle.vue**

虽然官网的示例都是`new Vue()` 初始化vue实例。
单文件组件(*.vue)使用`export default`也同样时初始化vue实例。


这里有几个概念：

1. 数据观测 (data observer) : prop， data， computed
2. 事件机制 (event / watcher)： methods 函数， watch侦听器


~~我们只简单搞清楚每个阶段发生了什么事情。其他还没有开始做的事情不想提及。~~
~~毕竟未开始也未完成，默认就是还没初始化嘛，有什么好说的呢？~~

### create

本小节标题是create，是指**vue实例的create阶段**。
**不是生命周期钩子函数** beforeCreate / created。

我们不打算从生命周期的钩子函数作为切入点。
只要搞清楚了vue实例xx阶段做了什么事情，
那beforeXX / XXed 的区别自然知晓。

我们也根据官方api的资料来表述，实例阶段做了什么事情。

> 实例已完成以下的配置：数据观测 (data observer)，属性和方法的运算，watch/event 事件回调。

那我们应该定义 prop， data， computed methods watch，
然后使用beforeCreate， created前后对比一下。

```js
export default {
  // prop， data， computed methods watch
  // 自行定义，这里不浪费
  props: {},
  data () {
    return {
      msg: 'Hey Jude!'
    }  
  },
  methods: {},
  watch: {},
  beforeCreate () {
    console.log("%c%s", "color:orangeRed", 'beforeCreate--实例创建前状态')
    console.log("%c%s", "color:skyblue", "$props  :" + this.$props)
    console.log("%c%s", "color:skyblue", "$data  :" + this.$data)
    console.log("%c%s", "color:skyblue", "computed :" + this.reverseMsg)
    console.log("%c%s", "color:skyblue", "methods  :" + this.reversedMsg)
    // this.msg = 'msg1'
  },
  created ()  {
    console.log("%c%s", "color:red", 'created--实例创建完成状态')
    console.log("%c%s", "color:skyblue", "$props  :" + this.$props)
    console.log("%c%s", "color:skyblue", "$data  :" + this.$data)
    console.log("%c%s", "color:skyblue", "computed :" + this.reverseMsg)
    console.log("%c%s", "color:skyblue", "methods  :" + this.reversedMsg())
    // this.msg = 'msg2'
  }
}
```
![beforeCreate-created.jpg](./beforeCreate-created.jpg)

![1d689a094485391ea176016382505f6a.jpeg](en-resource://database/2634:1)

prop， data， computed， methods， watch。
除了watch比较特殊，其他都得到了验证效果。
要验证也很简单，取消 beforeCreate， created 对 `this.msg`赋值的注释。
`watch msg` 看看控制台会打印`msg1`还是`msg2`，或者两者皆可。
聪明的你肯定知道控制台只打印`msg2`的，所以我就不取消注释了。

### mount

>  el 被新创建的 vm.$el 替换。 如果根实例挂载到了一个文档内的元素上，当mounted被调用时vm.$el也在文档内。


```html
<template>
  <div class="skill-lifecycle">
    {{ msg }}
  </div>
</template>
```

```js
export default {
  beforeMount () {
    console.log("%c%s", "color:orangeRed", 'beforeMount--挂载之前的状态')
    console.log("%c%s", "color:skyblue", "$el  :",this.$el)
  },
  mounted () {
    console.log("%c%s", "color:orangeRed", 'mounted--已经挂载的状态')
    console.log("%c%s", "color:skyblue", "$el  :", this.$el)
  }
}
```

![beforeMount-mounted.jpg](./beforeMount-mounted.jpg)
![26f28459d5202d95b053fd05384d27d2.jpeg](en-resource://database/2636:1)

mount阶段，由于vue支持多种方式挂载DOM。
而vue实例在created之后，beforeMounted之前这一阶段，
对挂载DOM的方式有判断机制，这里的流程稍微复杂也比较重要。

多种挂载DOM的方式。

* render
* template
* $mount

<!--

#### render

#### template

#### $mount

-->

**create mount是每个组件都必须经历的生命周期，但接下来的生命周期就比较有选择性了。**

### update

> 数据更改导致的虚拟 DOM 重新渲染和打补丁。

**实例data属性更新将会触发update阶段，数据的值改变，才会触发，并不是每次赋值都会触发。**

```html
<template>
  <div class="skill-lifecycle-process">
    <p>{{ msg }} </p>
    <p><button @click="handleClick">update</button></p>
  </div>
</template>
```

```js
export default {
  data () {
    return {
      msg: 'Hey Jude!'
    }
  },
  methods: {
    handleClick () {
      this.msg = 'Hello World!'
    }
  },
  watch: {
    msg () {
      console.log(this.msg)
    }
  },
  beforeUpdate () {
    console.log("%c%s", "color:orangeRed", 'beforeUpdate--数据更新前的状态')
    console.log("%c%s", "color:skyblue", "el  :" + this.$el.innerHTML)
    console.log(this.$el)
    console.log("%c%s", "color:skyblue", "message  :" + this.msg)
    console.log("%c%s", "color:green", "真实的 DOM 结构:" + document.querySelector('.skill-lifecycle-process').innerHTML)
  },
  updated () {
    console.log("%c%s", "color:orangeRed", 'updated--数据更新完成时状态')
    console.log("%c%s", "color:skyblue", "el  :" + this.$el.innerHTML)
    console.log(this.$el);
    console.log("%c%s", "color:skyblue", "message  :" + this.msg)
    console.log("%c%s", "color:green", "真实的 DOM 结构:" + document.querySelector('.skill-lifecycle-process').innerHTML)
  }
}
```
![a247a783b4284e526598230142173caf.jpeg](en-resource://database/2642:1)


![beforeUpdate-updated.jpg](beforeUpdate-updated.jpg)

不难看出，vue的响应式机制是先改变实例数据。
此时新的实例数据并还没有挂载到DOM，只是存在于虚拟DOM(el);
再通过虚拟DOM重新渲染DOM元素。

**如果这个更新的数据有侦听器，侦听器会在update阶段前触发。**

### destroy

> 对应 Vue 实例的所有指令都被解绑，所有的事件监听器被移除，所有的子实例也都被销毁。

**销毁指的是销毁vue的响应式系统，事件还有子实例。**
都是针对vue层面的，并非销毁DOM之意。

调用`vm.$destroy()`触发 [传送门](https://cn.vuejs.org/v2/api/#vm-destroy)

调用这个实例方法后，DOM并没有什么变化。
vue实例也还是存在的，只是vue的响应式被销毁。
DOM与vue切断了联系。


### active

> 被 keep-alive 缓存的组件激活/停用时调用

```html
<p><button @click="handleClick">toggle click</button></p>
<keep-alive>
  <lifecycle-process v-if="isShow"></lifecycle-process>
</keep-alive>
```

`v-if`指令切换**组件挂载/移除触发**；
`v-show`指令切换**组件显示/隐藏不触发**。

```js
// lifecycle-process.vue
export default {
  // ...
  activated () {
    console.log('activated')
  },
  deactivated () {
    console.log('deactivated')
  }
}
```

有意思的是，**页面初始化的时候，activated会在mounted之后触发。**
而 `v-if`又会初始化组件实例，让组件从头到尾再走一遍生命周期。

有意思的是，单纯的切换组件的挂载/移除状态，activated / deactivated 会触发；
组件不会重新实例化走一遍生命周期，尽管这里用是的`v-if`。

**而当我们destroy组件，之后的每一次切换挂载/移除，组件都会重新实例化，我们只是第一次destroy而已。**

### errorCapture*

> 当捕获一个来自子孙组件的错误时被调用。此钩子会收到三个参数：错误对象、发生错误的组件实例以及一个包含错误来源信息的字符串。此钩子可以返回 false 以阻止该错误继续向上传播。

这个钩子函数是用来捕获错误的，而且只应用于子孙组件，实际开发中并不常用。 [传送门](https://cn.vuejs.org/v2/api/#errorCaptured)

## 常用生命周期函数

11个钩子函数就这样介绍完了。

### created

### mounted

### activated


## 结语


推荐阅读

* [vue 生命周期深入](https://juejin.im/entry/5aee8fbb518825671952308c) 针对多个组件引用情况（父子、兄弟组件）等情况生命周期的执行顺序
* [vue生命周期探究（一）](https://segmentfault.com/a/1190000008879966) 包括组件、路由、指令等共计28个的生命周期
* [vue生命周期探究（二）](https://segmentfault.com/a/1190000008923105) 路由导航守卫的钩子函数执行顺序
