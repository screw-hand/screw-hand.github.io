---
title: 原型链是如何贯穿js的
tags:
---

> 原型链是js的大动脉。

# 导读

js的原型链难以避免要牵扯到面向对象，这里我们先简单说说原型还有原型链。之后我们说到面向对象的演变过程，会再次涉及到原型链，还有更多的东西。相信看完的读者会对JavaScript会有更深的认识。

## 原型对象

本小节意在介绍js中几位朋友，读者只需要记住有它们的存在就行了，毕竟这几位朋友性格有点隐匿。

首先，我们要明白，声明一个对象，哪怕是空属性，js也生成一些内置的属性和方法。

{% codeblock lang:js %}
/* 两种方法声明对象 */
// 对象直接量
var obj_1 = {};
// new关键字声明对象
var obj_2 = new Object();

// 在Object的原型对象添加属性
Object.prototype.attr = 'myarr'

console.log(obj_1); // {}
console.log(obj_2); // {}

// js中的恒等符号对函数来说只比较引用
// obj_1.valuOf函数来源于Object.valueOf
// 更准确来说是Object.protoype.valueOf
console.log(obj_1.valueOf === Object.valueOf); // true

// obj_1并未声明attr属性，通过Object.prototype继承得到attr属性
console.log(obj_1.attr); // myarr
{% endcodeblock %}

![空对象属性的prototype](./obj_attr.jpg)
<p align="center">*firefox控制台中空对象仍然有`prototype`属性*</p>

  误区：每个浏览器的控制台输出都不太一样，Chrome和Edge并不显示`prototype`属性，因为我们并没有给obj_1的`prototype`属性定义任何属性和方法。
  由于历代浏览器的更新和ECMAScript的修正，有时难以体现`prototype`和`__proto__`的存在，但我们的js代码能体现出它们的确是真实存在的。

`prototype`在这里称之为`obj_1`的原型对象，通过对象直接量和`new`关键字声明的对象都具有原型对象，继承自`Object.prototype`；几乎每个对象都有其原型对象，null是特例。

## 双对象实现原型继承

需要原型对象是为了实现继承，但有了原型对象我们还无法把`obj_1`与`Object.prototype`链接起来。
我们还需要另一个对象：`__proto__`，该属性能指向构造函数的原形属性`constructor`。
一些老版本浏览器不识别，有些无法识别其内部信息，但不影响程序的正常运行。

![obj_1的__proto__](./obj_1__proto__.jpg)
<p align="center">*`obj_1`的`__proto__`对象, 该属性下又有`__proto__`和`constructor`属性*</p>

{% codeblock lang:js %}
obj_1.__proto__ === Object.prototype  // true
obj_1.__proto__.constructor === Object // true
{% endcodeblock %}

这里有三个概念先行抛出
- 继承：继承使子类（超类）可拥有父类的属性和方法，子类也可添加属性和方法
- 父类：提供属性和方法被子类继承
- 子类：被父类继承的对象，可调用父类的属性和方法，也能定义属性和方法（父类无法调用）

通过`Object.prototype.attr`与`obj_1.attr`，我们可以看出 `obj_1` (子类) 继承了 `Object` (父类)的原型对象的`attr`属性。
正是因为`obj_1`的`__proto__`指向`Object.prototype`，obj_1继承了父类原型对象，使之拥有了`attr`属性。
而子类的`__proto__.constructor`直接指向父类。

> **原型继承：每声明一个对象，其本身拥有用两个对象：原型对象(`prototype`)，与`__proto__`对象，原型对象即可供自身使用，子类继承后也可调用；自身的`__proto__`对象指向父类的原型对象，其`constructor`属性指向父类的构造函数**。通过原型对象的方法实现继承，叫原型继承。**

## 双对象与原型链

综合以上，我们知道了使用原型对象`prototype`和`__proto__`对象可以实现继承的功能。那么我们是不是可以一直继承下去呢？

{% codeblock lang:js %}
function People(name) {
  this.name = name;
}

function Engineer(type) {
  this.type = type;
}

Engineer.prototype = new People('Chris Chen'); // Engineer (子类)继承 People (父类)

function Programmer(skill) {
  this.skill = skill;
  this.showMsg = function () {
    return 'Hi, my name is ' + this.name + ', I am a ' + this.type + ' engineer, I can write ' + this.skill + ' code!';
  }
}

Programmer.prototype = new Engineer('front-end'); // Programmer (子类) 继承 Engineer (父类)

var me = new Programmer('js');

console.log(me); // Object { skill: "js", showMsg: showMsg() }
console.log(me.showMsg()); // Hi, my name is Chris Chen, I am a front-end engineer, I can write js code!
{% endcodeblock %}

代码看完，我们从子类开始解释，也就是从下往上的顺序：
1. `me`是`Programmer`的实例化对象
2. `Programmer`的原型指向`Engineer`的实例对象
3. `Engineer`的原型指向`People`的实例对象

我们再来一张图说明其关系

![proto_egg](./proto_egg.jpg)
*这个.. 一盘煎蛋？？*

好伐，煎蛋就煎蛋，来，我们继续。

请注意重点：**`Programmer`并无定义`type`, `name`属性，`Programmer`的`showMsg`中能显示`this.name` `this.type`分别来源于`Engineer`和`Programmer`的原型对象。**
很巧妙的一种属性搜索机制，**自身的构造函数没有该属性，就从自身的原型对象中找，如果父类的原型对象没有，那么继续往父类的父类原型对象找，找到了就赋值；或直到没有父类，返回`undefined`；**属性如此，方法也是同样的赋值机制。

说到底属性搜索机制就是原型链的一种具体体现，我们再上一张图。

![proto_link](./proto_link.jpg)

所以原型链的关键字是**继承**和**原型对象**！！

> **原型链：使用`prototype`和`_proto_`两个对象实现继承，由于是基于原型对象实现调用链，又称之为原型链。**

关于原型链的第一步介绍就到这里，接下来我们从头开始，说说面向对象。

# 面向对象

首先我们先来概述面向过程编程（opp）与面向对象（oop）。这是JS的两种编程范式，也可以理解为编程思想。
顾名思义，两者的重心不同。下面我们使用两种方法创建dom并挂载于页面。

{% codeblock lang:js %}
/* 面向过程 */
// 1. 定义dom
var dom = document.createElement('div');
// 2. 设置dom属性
dom.innerHTML = '面向过程';
dom.id = 'opp';
dom.style = 'color: skyblue';
// 3. 挂载dmo
var container = document.getElementById('container');
container.appendChild(dom);

/* 面向对象 */
// 1. 定义构造函数
function CreateElement(tagName, id, innerText, style) {
  var dom = document.createElement(tagName);
  dom.innerHTML = innerText;
  dom.id = id;
  dom.style = style;
  this.dom = dom;
}
// 2. 定义原型对象上的方法
CreateElement.prototype = {
  render: function (dom) {
    var container = document.getElementById(dom);
    container.appendChild(this.dom);
  }
}

// 实例化对象
var innerBox = new CreateElement('div', 'oop', '面向对象', 'color: pink;');
// 调用原型方法
innerBox.render('container');
{% endcodeblock %}

> 面向过程比较流水线，更注重程序的实现过程，面向对象的程序由一个又一个的单位————对象组成，不关心对象的内部属性和方法，只需实例化，调用方法即可使用。

或许上面的例子，还不是很有力得体现出两者的区别，那么如果现在，需要挂载多个元素呢？

{% codeblock lang:js %}
/* 面向过程 */
// var dom_1 = document.createElement('div');
// dom_1.innerHTML = '面向过程_1';
// dom_1.id = 'opp-1';
// dom_1.style = 'color: skyblue';

// var dom_2 = document.createElement('div');
// dom_2.innerHTML = '面向过程_2';
// dom_2.id = 'opp-2';
// dom_2.style = 'color: skyblue;';

// var container = document.getElementById('container');
// container.appendChild(dom_1);
// container.appendChild(dom_2);

/* 这种方法傻的可爱，我们包装成函数吧 */

function createElement(tagName, id, innerText, style) {
  var dom = document.createElement(tagName);
  dom.innerHTML = innerText;
  dom.id = id;
  dom.style = style;
  return dom;
}

var container = document.getElementById('container');
var box_1 = createElement('div', 'oop-1', '面向过程_1', 'color: skyblue;');
var box_2 = createElement('div', 'oop-2', '面向过程_2', 'color: skyblue;');
container.appendChild(box_1);
container.appendChild(box_2);

/* 面向对象 */
function CreateElement(tagName, id, innerText, style) {
  var dom = document.createElement(tagName);
  dom.innerHTML = innerText;
  dom.id = id;
  dom.style = style;
  this.dom = dom;
}
CreateElement.prototype = {
  render: function (dom) {
    var container = document.getElementById(dom);
    container.appendChild(this.dom);
  }
}

var innerBox_1 = new CreateElement('div', 'oop-1', '面向对象_1', 'color: pink;');
innerBox_1.render('container');

// 这里只需再实例化一个对象调用render方法即可
var innerBox_2 = new CreateElement('div', 'oop-2', '面向对象_2', 'color: pink;');
innerBox_2.render('container');
{% endcodeblock %}

重复调用同样的方法，面向过程如果不包装一个函数，显得代码很冗余且愚蠢，而面向对象只需再次实例化即可。
这里也提醒我们平时写代码的时候要考虑复用性。

好的，那我们现在需要给dom元素添加一些交互功能，又要怎么做？

{% codeblock lang:js %}
/* 面向过程 */
function createElement(tagName, id, innerText, style, event, fn) {
  var dom = document.createElement(tagName);
  dom.innerHTML = innerText;
  dom.id = id;
  dom.style = style;
  // 直接修改内部函数
  dom.addEventListener(event, fn);
  return dom;
}

var container = document.getElementById('container');
var box_1 = createElement('div', 'oop-1', '面向过程_1', 'color: skyblue;', 'click', function (e) {
  alert(e.target.innerHTML);
});
// 过于死板，就算没有传参dom.addEventListener也会调用两次
var box_2 = createElement('div', 'oop-2', '面向过程_2', 'color: skyblue;');
container.appendChild(box_1);
container.appendChild(box_2);

/* 面向对象 */
function CreateElement(tagName, id, innerText, style) {
  var dom = document.createElement(tagName);
  dom.innerHTML = innerText;
  dom.id = id;
  dom.style = style;
  this.dom = dom;
}
CreateElement.prototype = {
  render: function (dom) {
    var container = document.getElementById(dom);
    container.appendChild(this.dom);
  },
  // 在原型对象上添加方法
  addMethod: function (event, fn) {
    this.dom.addEventListener(event, fn);
  }
}

var innerBox_1 = new CreateElement('div', 'oop-1', '面向对象_1', 'color: pink;', 'click');
innerBox_1.render('container');

var innerBox_2 = new CreateElement('div', 'oop-2', '面向对象_2', 'color: pink;', 'click');
innerBox_2.render('container');
// 根据场景需求决定是否调用addMethod方法
innerBox_2.addMethod('click', function (e) {
  alert(e.target.innerHTML);
})
{% endcodeblock %}

从这里可以我们看出两者的扩展方法截然不同，面向过程模式需要直接在函数中修改，而面向对像在原型对象上直接追加方法。

> 面向对象比面向过程有更高的复用性和扩展性。

PS：面向过程也并非一无是处，比面向对象更直观化，也更理解。若不需要考虑太多的因素，使用面向过程开发反而效率会更快。

# 下文还在更新中，继续续写精彩...