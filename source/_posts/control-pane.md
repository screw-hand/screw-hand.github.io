---
title: vue技巧篇：我的浏览器也是“控制台”
categories: vue
tags:
  - vue-skill
  - debugger
date: 2020-01-17 13:39:38
---

## 前言

写代码少不了，调试最简单方便的方法是控制台输出信息，如js的 `control.log`。
可有时候我们要监听的变量是改动频繁，可能要多次使用`control.log`，控制台信息太多看得也容易乱。
有一次查阅资料的时候，看到其他开发者使用`pre`标签直接在页面上打印变量，突然受到了一点感悟。

## pre 和 $data

html的`pre`标签并不常用，它可以保留原格式（空格和换行符），常用于表示源代码。
有了`pre`我们很容易在页面上输出源码。此外，还需要vue的声明式渲染 —— `｛｛ x ｝｝` 或者是 `v-text` 指令。
以及 vue 的 `$data` 实例属性，其实引用的是`data`对象属性的访问。

_附：博客系统，不支持双括号，这里用 `v-text`代替，大部分情况下两者可以互换_

说了那么多，其实只需要`<pre v-text="$data"></pre>`,这一行就够了。好的，今天就到这里，大家再见。

...

<!-- more -->

## 编写样式

如果只是简单的方便调试，确实只需要上面一行代码就够了。
只是本着折腾的命，觉得可以设计成一个组件，进行复用。
就算设计成一个组件，实用性的不大，趣味性要多过实用性吧。

如果在实际开发中，直接单纯只写一行，调试使用的`pre`可能会被其他DOM元素的样式所铺盖。
所以在编写组件前可以给这个`pre`写一点样式，先开头说的代码吧。

```html
<template>
  <pre v-text="$data"></pre>
</template>

<script>
import Package  from '@/../package.json'

export default {
  name: 'views-skill-control-panel',
  data () {
    return {
      strong: '<strong>I \'m strong</strong>',
      debugger: true,
      arr: [1,2,3,4,5],
      package: Package
    }
  }
}
</script>
```

可能比官网入门实例还要简单，唯一有疑问的可能也就是 `import` 一个 `json` 文件进来， 这在`es6 Modules`中是允许的，相关资料请自行查阅。

![pre-$data](./pre-$data.jpg)

ok，先看html部分，再看css。

html中，把`data`的属性都渲染到DOM上，并且html实体不会被转义，（`v-text`的功劳）。
数组、对象也全被展开，不像在浏览器控制台是默认闭合的，而且key值也被加上双引号，这是`JSON`的格式。

内容上看非常友好，样式因为没写，非常朴素，但我们也不追求美感，能看就行，这里有几个因素影响了观看。

1. 内容过长，高度容易溢出
2. 默认定位，容易被其他元素遮挡
3. 透明背景，深色背景观看费劲
4. 字体样式会被通用样式影响

其实以上问题都是其他DOM元素影响`pre`的阅读观看，我们要固定，或者说通配一下pre的样式。
让其在不同色彩表现、不同布局的页面降低其他DOM元素对自身的影响。

```html
<!-- 模拟pre真实使用场景 -->
<pre v-text="$data" class="pre-panel"></pre>
```

```css
.pre-panel {
  position: absolute;
  z-index: 999999;
  left: 20px;
  top: 20px;
  bottom: 20px;
  width: 380px;
  overflow: auto;
  background: rgba(0, 0, 0, .7); /* 建议半透明背景 */
  color: #34ecff;                /* 亮色的颜色即可 */
  font-size: 16px;
  font-weight: normal;
  line-height: 20px;
  text-indent: 0;
}
```

**以上css样式都是在多次实践中一行行增加，现已能适应大多数页面。**

模拟pre真实使用场景，完整代码：[传送门](https://github.com/Fifth-Patient/stardust/blob/master/src/views/skill/control-panel/control-panel.vue)

![pre-panel](./pre-panel.jpg)

即使在色彩强烈，内容纷乱的布局上，pre-panel仍然不影响阅读。

## 组件设计

这个组件也非常简单，还是把一行代码还有样式抽象成一个组件，就基本完成了。
不过考虑到扩展性，我们也可以考虑下给组件一些常用的配置选项。

第一步我们就是新建一个 `control-panel.vue` 文件，然后把刚才写的代码先复制过去。
接下来复用就会发现 `v-text="$data"` 使得每次复用绑定的都是自身组件的变量。
我们这里应该使用插槽slot，然而每次插槽每次都要复用都要传值，我们更喜欢默认显示`$data`。
然后再给指定插槽内容；当然这个 `$data` 是 `control-panel` 的父组件（**引用`control-panel`的那个组件**）而不是自己。

```html
<template>
  <pre class="control-panel">
    <slot>
      {{ defaultProps }}
    </slot>
  </pre>
</template>
```

```js
export default {
  computed: {
    defaultProps () {
      const parent = this.$parent
      if (parent && parent.$data) {
        return parent.$data
      } else {
        return this.$data
      }
    }
  }
}
```

这是最小化的可配置使用组件，然后这样还不够。
虽然 `control-panel` 不会被其他组件遮住了，可是他遮住了其他组件。
所以在某些情况，我们希望它“挪一挪”自己的位置，增加几个`props`即可解决这个问题。

```js
export default {
  props: {
    width: {
      type: [String, Number],
      default: '380px'
    },
    position: {
      type: String,
      validator: (val) => ['left', 'right'].indexOf(val) !== -1,
      default: 'left'
    }
  },
  computed: {
    currentWidth () {
      if (typeof this.width === 'string') {
        return this.width
      } else {
        return `${this.width}px`
      }
    }
  }
}
```

```css
/* 记得删除.control-panel的 left 属性！！ */
.position-left {
  left: 20px;
}
.position-right {
  right: 20px;
}
```

```html
<template>
  <pre 
    class="control-panel"
    :style="{ width: currentWidth }"
    :class="[
      { 'position-left': position === 'left' },
      { 'position-right': position === 'right' }
    ]"><slot>{{ defaultProps }}</slot>
    <!-- 这里不换行是为了消除首行缩进 -->
  </pre>
</template>
```

`props`只定义了3个，也有插槽，可以自定义，使用起来也不繁琐，方便了很多，不是吗？

-  组件源码：[传送门](https://github.com/Fifth-Patient/stardust/blob/master/src/components/control-panel/control-panel.vue)
- 复用-1：[传送门](hhttps://fifth-patient.github.io/stardust/#/skill/multi-index-1)
- 复用-2：[传送门](https://fifth-patient.github.io/stardust/#/skill/multi-index-2)

当然还可以再进行扩展，只是没什么必要，如：随机color，交互设置样式和插槽内容；
~~最好可以跟程序窗口一样可以最小化最大化关闭拖曳改变宽高..~~

## 彩蛋

设计一个组件，还要在实际项目中使用，可能因为各种现实因素影响，如果不喜欢组件的方式。
（不想写，或者是嫌弃麻烦的）这里可以提供一个代码片段，需要的使用的直接复制粘贴即可。

```html
<pre style="position: fixed; top: 20px; left: 20px; bottom: 20px; width: 200px; overflow: auto; z-index: 9999; font-size: 16px; line-height: 20px; color: skyblue; background: rgba(0, 0, 0, .7)">
  {{ formData }}
</pre>
```

什么？不想每次都复制一遍？想编辑器**代码提示**的功能一样打几个单词就帮你打一整段？
好伐，我也是一个嫌弃麻烦的人，如果你跟我一样是用vs code 的话，那我们可以用 vs code 增加用户自定义的代码提示。

**vs code 菜单： 文件 => 首选项 => 用户代码片段 => vue-html.json**

![user_snippets](./user_snippets.jpg)

![user_snippets_lang](./user_snippets_lang.jpg)

vue-html.json中增加这一段

```js
  "Print to pre dom": {
    "prefix": "vuepre",
    "body": [
     "<pre style=\"position: fixed; top: 20px; left: 20px; bottom: 20px; width: 300px; overflow: auto; z-index: 9999; font-size: 16px; line-height: 20px; color: skyblue; background: rgba(0, 0, 0, .7)\">",
     "  {{ $1 $2 }}",
     "</pre>"
    ]
  }
```

这样在`*.vue`的文件格式中，vs code 就支持对`vuepre`的代码提示了。

![vue-pre](./vue-pre.jpg)

也直接直接拿我的 vue-html.json（[传送门](/download/vue-html.txt)），使用任何文本编辑器打开，另存为：%APPData%\Code\User\snippets\vue-html.json

## 最后

此本到这里就结束了，定义了一个可以监测变量的组件，相当于把控制台搬运到了网页，只是这个控制台是简化版的。
<!-- 当然之后的开发，喜欢`control.log`、`debugger`还有打断点的还是会选择之前喜欢的方式调试。 -->
只是很多开发者都很讨厌调试，因为只有自己的代码出现问题才会去调试。
其实调试本来就是一件苦中作乐的事情，平时写的代码，都是为了满足各种需求，有时候写得并不自由。
那么，我们在调试的时候，为何不使用一种更有趣味的方式去调试呢？起码这个时候自由度很高很高..
