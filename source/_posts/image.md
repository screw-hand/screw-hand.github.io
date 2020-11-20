---
title: 浏览器图片机制
date: 2020-11-06 18:48:40
categories:
tags: web
---

## 前言

浏览器中引用图片是一种很常见的情况，使用方式的不同，他们的意义也不同。比如————作为“内容主体”、“背景”、“图标”等，而设计师有时候也会提供不同的格式图片（img/png/svg/）。在不同的场景，我们对同一份图片素材，要根据图片在web界面中的意义合理运用。个人会列举浏览器常用使用图片的方式。

- img
- background-image
- icon-font
- svg
- webpack 与 img
- base64

<!-- more -->

## img、background-image

`HTML`的`img`标签、`css`的`background-image`样式是最原始的使用图片方式，在H5时代前，相当长的一段时间都是用这两方式引用图片资源的。

`<img>`标签，将图片作为**内容主体**引入web页面，故其是**占位**的；而`background-image`样式，起**修饰**作用，**不占位**。

### 基本用法

**img**

```html
<img src="https://mdn.mozillademos.org/files/7693/catfront.png" />
```

**background-image**

```html
<div class="background"></div>
```

```css
.background {
  width: 30px;
  height: 64px;
  margin: 0 auto;
  background-image: url('https://mdn.mozillademos.org/files/7693/catfront.png');
}
```

<img src="https://mdn.mozillademos.org/files/7693/catfront.png" />

<div class="background"></div>

<style>
.background {
  width: 30px;
  height: 64px;
  margin: 0 auto;
  background-image: url('https://mdn.mozillademos.org/files/7693/catfront.png');
}
</style>

*虽然呈现的效果一致，意义却不一样。*

<!-- - [<img>：图像嵌入元素](https://developer.mozilla.org/zh-CN/docs/Web/HTML/Element/img) -->
<!-- - [background-image](https://developer.mozilla.org/zh-CN/docs/Web/CSS/background-image) -->

### img之尺寸、居中

`img`标签提供了关于设置尺寸的属性，分别是`width`和`height`，单位可以是css像素，也可以是百分比。

```html
<img src="https://mdn.mozillademos.org/files/7693/catfront.png"  width="100%" height="100%" />
```

*然而尺寸的百分比单位并不是相对于图片资源的比例，而是其容器的百分比。*

所以并不推荐使用img标签的`width`及`height`设置属性，推荐使用css的`width`及`height`属性编写。

其实很多web开发者设置`100%`的本意是想让图片**按父容器宽度自动缩放，并保持图片原本的长宽比**。

```css
img {
    width: auto;
    height: auto;
    max-width: 100%;
    max-height: 100%;
}
```

除此之外，`img`的居中方式也是很容易让人误解，因`img`的`display`属性为`inline-block`，其居中方式（水平、垂直都是）更是让人误解。

```html
<div class="block">
  <img src="https://mdn.mozillademos.org/files/7693/catfront.png" />
</div>
```

```css
.block {
  width:150px;
  height: 150px;
  border: 1px solid #333;
  /* 垂直居中 */
  display: table-cell;
  vertical-align: middle;
  /* 水平居中 */
  text-align: center;
}

img {
    max-width: 50%;
    max-height: 50%;   
}
```

没想吧？居然是加在img的容器标签上，虽然绝对居中（水平、垂直都同时居中）还有其他的方法，常见的`margin auto`居中还有绝对定位50%。不过个人觉得这是最值得开发着去记住的。除此之外，也建议给容器设置`font-size: 0;`，这可以解决两个相邻的img标签之间的空隙问题。

说了那么多的img，现在得回过头来谈论`background-image`了。

### background-image之位置、尺寸及重复

虽然前面我们说的`background-image`一直说的是css的样式特性，然而`background-image`只能指定使用的图片资源（可以是一张、也可以是多张）。背景图片样式（如本节小标题所说的位置、尺寸及重复）的设置，往往还需要结合其他css特性。

1. `background-position`可以给背景图片定义位置，设置的是其图片的左上角要在容器的哪个偏移度位置。

2. `background-size` 可设置背景图片大小。`contain`理解为等比例缩放图片，高度/宽度其一先与容器尺寸相等，则停止缩放，若图片和容器宽高比例不一致，会出现白边；`cover`也是等比例缩放，高度/宽度其一先与容器尺寸相等，继续缩放，（此时图片溢出），直到另一方向的尺寸占满容器，停止缩放。

![background-size:contai](/image/background-size_contain.png)

![background-size:cover](/image/background-size_cover.png)

**更简易的理解： `contain`为最小化等比例缩放图片，`cover`则为最大化等比例缩放。**

除了这两个关键字，也可以用两个单位值指定背景图片的宽高，对于绝对单位（px、em、rem）没啥好说的，对于相对单位（百分比），是相对于容器的尺寸来计算的，**有意思的是`100% 100%`，这代表着破坏原比例，把图片拉伸/挤压到容器的尺寸。**（很多css属性的相对单位都是根据容器来计算的，或许有特殊的属性我忘了。;-)

3. `background-repeat` 设置图片重复使用的方式。

以上就是关于背景常用的css样式特性，完整的css背景样式如下，并不复杂。

* background-attachment
* background-clip
* background-color
* background-image
* background-origin
* background-position
* background-position-x
* background-position-y
* background-repeat
* background-size

> 不建议使用css简写属性`background`一次性设置背景特性。

### CSS Sprites

CSS Sprite(CSS 精灵), 又名雪碧图，是一种图片合并技术，我们可以把一些小图，整合放在一张大图中，每次单独使用小图的时候，裁剪出指定位置，尺寸即可正常显示。

![CSS-Sprites.gif](/image/CSS-Sprites.gif)

像上图就可以作为雪碧图的素材使用，以实现改方案。

简单分析一下这张图片：

1. 尺寸：134 * 44
2. 小图数量：3
3. 规范：固定大小，水平排列

那我们可以定义一个通用的`class`，设置小图的尺寸；再定义一个`class`，设置图片裁剪位置即可。

```css
.css-sprite {
    width: 44px;
    height: 44px;
    background: url("./CSS-Sprites.gif");
    background-repeat: no-repeat;
}

.hourse {
    background-position-x: 0;
}
.left-arrow {
    background-position-x: -44px;
}
.right-arrow {
    background-position-x: -88px;
}
```

#### 特性

1. 减少服务器压力：多图合并成一张，只发送一次HTTP请求，并且可以被缓存，有助于提升页面加载性能
2. 维护困难： 后期维护成本较高，添加一张图片需要重新制作。
3. 应用麻烦：每应用一张图片都需要调整位置，误差要求严格。
4. 局限：只能用在背景图片`background-image`上，不能用`<img>`标签来使用。

#### 不同方式实现 CSS Sprites

如果会使用`gulp`、`webkack` 等构建工具，可以借助工具自动生成雪碧图。

[spritesmith](https://github.com/twolfson/spritesmith)，是一个node工具，可以将多张图片合成一张图片——雪碧图，也提供了`grup`和 `gulp`插件，甚至是命令行工具。

- `gulp` 结合[spritesmith](https://www.npmjs.com/package/spritesmith)的插件 [gulp.spritesmith](https://www.npmjs.com/package/gulp.spritesmith)
- `webpack`结合对应的loader [webpack-spritesmith](https://www.npmjs.com/package/webpack-spritesmith) 
- svg [svg-sprite-loader](https://www.npmjs.com/package/svg-sprite-loader)

## icon-font

**首先我们得明白，icont-font本质上不是图片，而是一种比较特殊字体，这种字体，以图标的方式显示。**

### web字体

得益于`css3`的新特性“web字体”，我们可以为自己的网页定义在线字体，无论用户是否安装了我们指定的字体，我们都可以让网页呈现出我们想要的字体，突破了传统[Web-safe 字体](https://developer.mozilla.org/en-US/Learn/CSS/Styling_text/Fundamentals#Web_safe_fonts)的限制。

```css
/* 定义名为“Open Sans”字体  */
@font-face {
  font-family: "Open Sans";
  src: url("/fonts/OpenSans-Regular-webfont.woff2") format("woff2"),
       url("/fonts/OpenSans-Regular-webfont.woff") format("woff");
}

/* 应用于网页 */
body {
 font-family: "Open Sans";
}
```

> web字体不是我们这次要重点的谈论范围，了解即可，这里提供了一些相关资料：
- [Web 字体](https://developer.mozilla.org/zh-CN/docs/Learn/CSS/%E4%B8%BA%E6%96%87%E6%9C%AC%E6%B7%BB%E5%8A%A0%E6%A0%B7%E5%BC%8F/Web_%E5%AD%97%E4%BD%93)
- [@font-face](https://developer.mozilla.org/zh-CN/docs/Web/CSS/@font-face)
- [font-family](https://developer.mozilla.org/zh-CN/docs/Web/CSS/font-family)

所以icon-font，指的是使用自定义的字体展示图标。运用了上述介绍的web字体技术。

### 基本使用

字体图标技术已经是web主流使用icon的一种方案了，很多UI库都内置提供了一套图标库供开发者使用，当然也可以独立使用开源的图标库，或者使用工具生成自定义的图标库。

这里用常用的UI框架`elemment-ui`举例，其UI库提供了[icon](https://element.eleme.cn/#/zh-CN/component/icon)组件，内置了图标库，使用方式也很简单。

![](/image/element-ui_icon.png)

基本上，正确引用了icon-font，直接设置的类名即可展示对应的UI，那么我们究竟引用了什么东西呢？在[icon](https://element.eleme.cn/#/zh-CN/component/icon)页面上，使用`F12`打开开发者工具、找到`element-ui-*.css`源码。

![](/image/element-ui-css.png)

 独立的开源图标库有很多，名气比较大的有[Font Awesome](https://fontawesome.com/)。使用方法也是类比UI库，引入相关的css源文件即可。css源文件也是类似`element-ui-*.css`的格式，引用外部资源、定义web字体、使用web字体，内置定义了`class`。直接在相关dom中使用class即可。

实际项目中，这种开源的集成图标库往往不能满足需求设计稿，我们需要使用一些自定义图标。我们可以使用一些工具：[iconfont](https://www.iconfont.cn/)、[fontello](https://fontello.com/)、[icomoon](https://icomoon.io/)，都是很优秀的在线生成图标库，具体使用方式网站也有介绍，不再累述。教程中引入的`css`，也是跟`element-ui-*.css`的格式类似。

### 特性

icon-font最大的特性就是样式有更多的灵活性。**我们可以像处理文字一样处理图标的样式。**使用`font-size`控制图标的尺寸，`text-align`、`line-height`控制其居中方式，甚至是`color`为图标设置不同的样式。

一般使用icon-font都是一套一套的使用，而不是一个一个独立使用，所以这对减少网络请求次数也有优势。

矢量图形也意味着我们可以随意调整图标大小而不用担心其失真。

不过icon-font只适用于纯色图标，当然渐变效果也可以使用css样式编写。

## svg

[svg](https://en.wikipedia.org/wiki/Scalable_Vector_Graphics)——可缩放矢量图形(Scalable Vector Graphics)，是一种文件格式， 用XML 的格式定义图像。我们可以使用代码编辑器编辑svg文件，使用浏览器可直接预览。

```html
<svg version="1.1"
  baseProfile="full"
  width="300" height="200"
  xmlns="http://www.w3.org/2000/svg">
  <rect width="100%" height="100%" fill="red" />
  <circle cx="150" cy="100" r="80" fill="green" />
  <text x="150" y="125" font-size="60" text-anchor="middle" fill="white">SVG</text>
</svg>
```

> 可以先将其拷贝保存为x.svg，待会用到的 。

将在浏览器中呈现...

![](/image/svg.png)

### 基本使用

有几种使用方式，第一种是直接作为标签嵌入`HTML`源码中。

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Document</title>
</head>
<body>

  <svg version="1.1"
    baseProfile="full"
    width="300" height="200"
    xmlns="http://www.w3.org/2000/svg">
    <rect width="100%" height="100%" fill="red" />
    <circle cx="150" cy="100" r="80" fill="green" />
    <text x="150" y="125" font-size="60" text-anchor="middle" fill="white">SVG</text>
  </svg>

</body>
</html>
```

第二种是将svg代码保存为一个单独的文件，如同png，jpg，git等图片资源一样使用。

```html
<h1>img svg</h1>
<img src="x.svg" alt="">
<h1>object svg</h1>
<object data="x.svg" type=""></object>
<h1>iframe svg</h1>
<iframe src="x.svg" frameborder="0"></iframe>
```

背景图片也是可以的。

```html
<div id="div-svg"></div>
<style>
  #div-svg {
    width: 300px;
    height: 200px;
    background: url('./x.svg');
  }
</style>
```

### 特性

svg基于`XML`语法实现，可以用DOM选择器获取该DOM对象。前提是用第一种方式直接将svg嵌入`HTML`。

```html
<!-- 先给刚才的svg加上id属性 -->
  <svg
    id="dom-svg"
    ...>
    ...   
  </svg>
```

```javascript
const domSvg = document.querySelector('#dom-svg')
console.log(domSvg) // <svg id="dom-svg" version="1.1" baseProfile="full" width="300" height="200" xmlns="http://www.w3.org/2000/svg">
console.log(domSvg.childNodes) // NodeList(7) [ #text, rect, #text, circle, #text, text, #text ]
const divSvg = document.querySelector('#div-svg')
```

如果有用过`icon-font`，会知道我们可以用多个svg制作成一套字体图标库。虽然字体图标然比传统的`img`，`background`方式有着更好的css样式灵活性，可终究直接使用的时候是纯色的。而svg有着更好的色彩表现能力，同样也是矢量图形，且可以进行DOM操作，这也意味着我们可以**随时动态地改变图片的结构**。**而且svg不仅仅可以制作成字体图标库，也可以转换成png、jpg等传统图片格式甚至是`canvas`。**

>  svg文件格式现在已经是主流web开发图片使用方案了，而且是目前最灵活的图片文件格式。

## webpack 与 img

[webpack](https://webpack.js.org/)是一个前端打包工具，前端项目的每个静态资源都是一个单独的模块，`webpack`内部会**自动管理这些依赖关系**，编译源码时会自动根据这些依赖关系进行打开，最终生成*bundle*。其特点是拥有**模块化机制**、**loader**可以对各种类型的模块加载时运动不同的任务、**插件化**更是令其可以跟其他的构建工具（`grunt`、`gulp`等）结合使用、**模块热替换****更是大大加大了开发速度，模块的更新无需重新加载整个页面。

`webpack`功能多样且强大，我们本次将重点放在webpack是如何处理图片资源的。`webpack`一般是跟`vue`或者`react`框架集成使用，当然也可以独立使用。原理都差不多，框架的脚手架会基于`webpack`进行对框架场景的适合或者说扩展。为了方便，这里以`vue`为例。

### 基本使用

[vue-cli](https://cli.vuejs.org/zh/guide/html-and-static-assets.html#%E5%A4%84%E7%90%86%E9%9D%99%E6%80%81%E8%B5%84%E6%BA%90)已有相关介绍，简单来说，就是在`template`中，还有在js中有不同的使用图片方式。

原生`html` 跟`vue`的`template`语法是一样的。

```html
<img src="./image.png">
```

`script` 或者叫`js`中是这样使用的。

```javascript
imgURL = require('./image.png')
```

```html
<img :src="require('./image.png')">
```

`background`也类同`<img>`。

### 裂图/空图

裂图：指定的图片资源地址不存在，或者加载失败（404），此时界面出现一张小的占位“裂图”；

空图：不指定图片资源地址，如果样式有设置尺寸大小，会根据img/background的原生特性占位。

裂图一般是bug，我们需要根据bug的场景去解决。

空图也有其使用的场景：如，初始img标签，动态加载不同的图片资源地址，默认占位。

实现空图也很简单，`src=""` `:src="null"` 即可，也可以直接不使用`src`属性。

有意思的是，当`src`的属性值为空时，chrome 和 firefox 渲染的DOM略有差异。

```html
<!-- chrome -->
<img src(unknown)>
```

```html
<!-- firefox -->
<img>
```

### 小图自动转成base64

有时候我们会发现`webpack`自动把一些小内存的图片自动转换成`databas64`格式的编码。在`vue-cli`也有相关的资料介绍 —— [从相对路径导入](https://cli.vuejs.org/zh/guide/html-and-static-assets.html#%E4%BB%8E%E7%9B%B8%E5%AF%B9%E8%B7%AF%E5%BE%84%E5%AF%BC%E5%85%A5)。

我们知道`vue-cli`是一个集成了`webpack`常用的功能实现的`vue`脚手架，为了是配置管理`vue`项目更加方便快捷，内置静默配置了`webpack`的常用功能。

>  究其原因还是使用了`webpack`的`file-loader`处理资源最终引用的路径。`url-loader`将小于**指定大小**的资源转成内联（这里包括`css`、`javascript`、图片字体等静态资源），`css` `javascript` 都拥有html对用的标签，图片资源则是处理成`base64`格式。为了是节约 HTTP 请求数量。

`vue-cli`可以使用`chainWebpack`设置指定大小，如果是单独使用`webpack`，则应该配置`url-loader`，以下是参考的`url-loader`配置。

```js
module: {
　　loaders: [
　　　　{
　　　　　　test: /\.(png|jpg)$/,
　　　　　　loader: 'url-loader?limit=8192'
　　　　}
　　]
}
```

## base64

[base64](https://zh.wikipedia.org/wiki/Base64)是一种编码的方法，可以用来表示**二进制**数据。所以图片也可以被编码成`base64`，形成一条字符串。

*试试将下面的这串字符复制在浏览器地址栏直接访问，看看是本文的出现的哪张图片。*

```
data:image/png;base64,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
```

这条字符串有特定的格式的，这种格式叫[**Data URL scheme**](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/data_URIs)，意为data协议（类同http协议）。base64编码不仅仅可以表示图片，也可以表示其他类型的数据。

```
data:[<mediatype>][;base64],<data>
```

### 特性

1. 体积会比原来大1/3
2. 不需要请求服务器资源，减少HTTP请求次数
3. 编码、解码方便，算法可逆，不适用于私密信息通信
4. 无法缓存，不建议使用在改动频繁的地方

js创建`base64`的方法：

1. `canvas` 将图片转化为 `base64` 编码

2. `FileReader` 将图片转化`base64`格式 

### 使用场景

`base64`的使用场景比较少，个人之前的工作经历是img url 有token认证机制，直接使用`<img src="https://HOST/xx.jpg">`，接口状态码返回403。而后端整个api系统都是有token认证的机制，不太好改，img标签又不支持添加HTTP请求头。最后用js发起http请求，设置token请求头。

1. 使用XHR发送http请求，设置响应类型 `xhr.responseType = 'blob'`
2. 构建 `new FileReader()`实例，实例事件 `onloadend`获取`base64`
3. 将`base64 `赋值给`<img>`标签的`src`属性

其他常见的编码格式

- Unicode
- UTF-8
- URL12
- Unix时间戳
- Ascii/Native
- Hex
- Html

## 小结

我们介绍了从各个话题介绍了浏览器中使用的图片，现在是时候来一波总结了。

1. `img` / `background` - 原生`html`、`css`实现，分别作为**内容主体**、**样式装饰**功能
2. `CSS Sprites` （技术方案） - 一种优化图片方案，有不同的实现方式
3. `icon-font` - 基于`h5`的`web-font`特性实现，使用在线工具可生成一套矢量图片库，样式控制灵活
4. `svg` - 一种很灵活的图片格式，浏览器原生支持，可转换成传统图片格式或者制作成`icon-font` 
5. `webpack`中使用`img` - img在工程化中的简单实现
6. `base64` - 一种编码方式，格式为Data URL scheme， 可表示图片等二进制文件流

## 结尾

此本从开发者拿到一张图片素材开始。以在不同场景在，选择最合适的实现方式。尽管写得比较长，可还是少了一点东西。比如`canvas`没有讲，不过一般`canvas`用于脚本绘制渲染可视化数据多一些，当然能渲染成img，场景少，就没在这里讨论。本意也是觉得一张图片在浏览器上有多种使用方式，就整理了一下，写下以上内容，算是个人的知识总结回顾吧。

