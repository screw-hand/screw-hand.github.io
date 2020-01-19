---
title: vue的一些技巧
date: 2019-12-20 22:49:04
tags: vue-skill
---

## `v-if` 获取 `refs` 问题

先简单介绍下这两个指令：

- `v-if` 条件渲染
- `ref` 返回组件实例或DOM元素

有时候我们需要在条件渲染的DOM节点上返回一个DOM对象或组件实例，可`this.$refs.child` 返回的是`undefined`。通过查阅文档得知:

> v-if 是“真正”的条件渲染，因为它会确保在切换过程中条件块内的事件监听器和子组件适当地被销毁和重建。
> v-if 也是惰性的：如果在初始渲染时条件为假，则什么也不做——直到条件第一次变为真时，才会开始渲染条块。
> $refs 只会在组件渲染完成之后生效，并且它们不是响应式的。这仅作为一个用于直接操作子组件的“逃生舱”——你应该避免在模板或计算属性中访问 $refs。

如此可得：

**`v-if` 条件渲染： 惰性渲染，DOM、事件、组件会被销毁重建**

**`ref` 返回组件实例或DOM元素，非相应式**

<!-- more -->

那么可推论得知`v-if`和`ref`的实现有冲突，`v-show`也是条件渲染，而它只是单纯切换元素css display属性值隐藏。**如此可以使用`v-show`替代`v-if`**。

总结：工作中常用的是`v-if`，可`v-show`也有`v-if`替代不了的时候，比如用于`ref`的DOM或组件；
而`v-if`又可使用`v-else`、`v-else-if`，这两个指令也比较特殊，必须和`v-if`相邻，阅读代码时逻辑性更强。

## `$event` —— 隐藏的函数参数

vue的官方api文档，里详细地介绍了实例属性/方法，这些属性和方法都以美元符号`$`为前缀， `$event`并没有介绍；
但在教程中， `$event`的定义是获取原生dom事件，实践中有时候其值并非是原生dom对象，
而`$event` 又是可以隐性调用的，这使得`$event`的机制不那么直观。

### 基本使用

使用`v-on`或`@`指令可以为dom元素绑定事件,
函数没有参数时，`$event`被自动当作实参传入;
函数带有参数时，最后一个参数必须显式传入`$event`

请自行准备一个组件：`dollar-event.vue`

```html
/* dollar-event.vue */
// eg: 无参数
<button @click="handleClick">$event empty param</button>

<script>
handleClick ($event) {
  console.log('dom事件：本组件事件')
  console.log($event) // 原生dom对象
}
</script>

// eg：带有参数
<!-- 调换$event位置，爹妈不疼哦，不信你试试？ -->
<button @click="handleParamClick('click', $event)">$event with param</button>

<script>
handleParamClick (value, $event) {
  console.log({
    value,  // 'click'
    $event  // 原生dom对象
  })
}
</script>
```

非常简单，就是有无参数的区别，可自定义事件(`$emit`)机制就有两个含义了。

### 自定义事件($emit)

`$emit`实例方法可以触发父组件的自定义事件，
同时还可以传递一个参数给自定义事件接受；
这个参数也可以是子组件的`$event`

请再准备一个组件：`emit-event.vue`

```html
/* emit-event.vue */
<button class="skill-emit-event" @click="handleEmit">
  <slot>emit-event</slot>
</button>

<script>
handleEmit ($event) {
  // 这里的$event同"基本使用"的第一段实例一样都是原生dom对象
  this.$emit('dispatch', {
    emitParams: $event,
    emitValue: 'dispatch emit-event'
  })
}
</script>

/* dollar-event.vue */
<emit-event @dispatch="emitClick">emit click</emit-event>

<script>
import emitEvent from './emit-event'

emitClick (emitEvent, $event) {
  console.log({
    emitEvent,  // { emitParams: '子组件的$event', emitValue: 'dispatch emit-event' }
    $event      // emitEvent才是形参$event, 因此自己没有$event了，这里是undefined
  })
  console.log(emitEvent.emitParams.target) // <button class="skill-emit-event">
}
</script>
```

父组件的自定义事件有参数时也可结合`$event`一起使用，机制跟“基本使用”是一样的。

```html
/* dollar-event.vue */
<emit-event @dispatch="emitParamClick('val', $event)">emit param click</emit-event>

<script>
emitParamClick (val, $event) {
  console.log({
    val,        // 'val'
    $event     // { emitParams: '子组件的$event', emitValue: 'dispatch emit-event' }
  })
}
</script>
```

示例代码：[dollar-event](https://github.com/Fifth-Patient/vue-skill/tree/master/src/views/skill/dollar-event)

总结：

- 基本使用时函数无其他实参，可以不用传`$event`实参，有其他实参的时候，`$event`必须作为最后一个参数传入
- 自定义事件时使用，`$event`作为`$emit`的实参，若`$emit`不带参数，`$event`的值为`undefined`
