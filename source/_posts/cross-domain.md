---
title: 跨域
date: 2019-03-29 02:00:33
tags: web
---

### 同源策略

源：源由协议，域名和端口号组成，若url地址的协议、域名和端口号均相同则属于同源。

同源策略：浏览器的一个安全功能，不同源的客户端脚本在没有明确授权的情况下，不能读写对象自资源。其阻止的是数据的接受而不是请求的发送

不受同源策略限制：
页面中的链接，重定向以及表单提交；
可以引入跨域资源，但js不能读写加载内容。 如嵌入到页面中的`<script src="..."></script>`，`<img>`，`<link>`，`<iframe>`等。

### 跨域：受同源策略的限制，不同源的脚本不能操作其他源下面的对象，想操作另一个源下面的对象就是跨域。

<!-- more -->

实现方式：

- document.domain
- JSONP
- CORS
- window.name
- postMessage H5

需要跨域的场景：

1. 上传图片、文件
2. 富文本编辑器
3. 页面请求第三方接口


**降域 document.domain**

将两个不同源的域名document.domain设置为同一个即可；存在安全性问题，一个网站被攻击，另一个也有安全漏洞，只适用于cookie和iframe窗口。

**跨域资源共享 CORS**

设置服务器响应头 Access-Control-Allow-Origin 指定允许跨域的源，实现浏览器向跨源服务器，发出XMLHttpRequest请求，从而克服了AJAX只能同源使用的限制。

**JSON with Padding JSONP**

动态插入script标签，通过script标签引入一个js文件， 在服务端输出JSON数据，客户端执行回调函数，从而解决了跨域的数据请求。 jsonp+padding--将json填充到一个盒子里，（使用回调函数获取json数据）；兼容性好，简单易用，支持浏览器与服务器双向通信。当然也有一些缺点：权限漏洞，只能发送GET请求，需要防止XSS。

**window.name**

一个窗口的声明周期内，窗口载入的所有页面都是共享一个name属性的，每个页面都对window.name有读写权限，其属性持久存在，不因新页面载入而进行充值。

在原页面中使用一个隐藏的iframe充当中间人角色，由iframe去获取数据，src设为目标页面，再把src设置跟原页面同一个域，否则受到同源策略的限制。原页面再去得到iframe获取到的数据，iframe的window.name。

**postMessage**

H5提供的一个API