---
title: 浏览器图片机制
date: 2020-11-06 18:48:40
categories:
tags: web
---

## 前言

<!-- 图片、背景图片、icon-font、svg、canvas database64 -->

浏览器中引用图片是一种很常见的情况，使用方式的不同，他们的意义也不同。比如————作为“内容主体”、“背景”、“图标”等，而设计师有时候也会提供不同的格式图片（img/png/svg/）。在不同的场景，我们对同一份图片素材，要根据图片在web界面中的意义合理运用。个人会列举浏览器常用使用图片的方式。

- img
- background-image
- icon-font
- svg
- webpack 与 img
- database64

<!-- more -->

## img、background-image

`HTML`的`img`标签、`css`的`background-image`样式是最原始的使用图片方式，在H5时代前，相当长的一段时间都是用这两方式引用图片资源的。

`<img>`标签，将图片作为**内容主体**引入web页面，故其是**占位**的；而`background-image`样式，起**修饰**作用，**不占位**。

### 基本用法

**img**

```html
<img src="https://mdn.mozillademos.org/files/7693/catfront.png" />
```

<img src="https://mdn.mozillademos.org/files/7693/catfront.png" />

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

### css雪碧图

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

如果有用过`icon-font`，会知道我们可以用多个svg制作成一套字体图标库。虽然字体图标然比传统的`img`，`background`方式有着更好的css样式灵活性，可终究直接使用的时候是纯色的。而svg有着更好的色彩表现能力，同样也是矢量图形，且可以进行DOM操作，这也意味着我们可以**随时动态地改变图片的结构**。而且svg不仅仅可以制作成字体图标库，也可以转换成png、jpg等传统图片格式甚至是`canvas`。

>  svg文件格式现在已经是主流web开发图片使用方案了，而且是目前最灵活的图片文件格式。

## webpack 与 img

1. webpack  require img
2. 小图片转成database64

## database64

...

## 结尾

...