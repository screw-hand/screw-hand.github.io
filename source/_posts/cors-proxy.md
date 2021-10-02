---
title: 使用代理解决跨域问题
date: 2021-07-17 09:54:08
categories:
tags:
---

## 前言

如今主流开发模式**前后端分离**已是普遍的开发模式，相对于传统的前后端耦合，前后端各拥有自己的一套开发环境。开发完成后，又一起部署到是测试/线上环境。

因为后端的API服务并不部署在前端的开发环境上，所以在开发时，经常会遇到需要跨域的场景；即便是部署到测试/线上环境，也不一定是部署到同一台服务器（单体、集群式服务）。

内容：介绍跨域、同源策略的基本概念；收跨域影响的场景；常用的跨域方案、代理；反向代理、正向代理；开发、线上环境配置代理。

<!-- more -->

## 跨域、同源策略

我们经常遇到，跨域的问题。在讲跨域前。先来了解下同源策略吧。

> 同源策略是一个重要的安全策略，它用于限制一个origin的文档或者它加载的脚本如何能与另一个源的资源进行交互。它能帮助阻隔恶意文档，减少可能被攻击的媒介。 

[MDN-浏览器的同源策略](https://developer.mozilla.org/zh-CN/docs/Web/Security/Same-origin_policy) 说的很长，按照个人的理解的是————

**同源策略(Same Origin Policy)，是浏览器的一个安全策略，为了网站的安全，不同源的资源无法进行交互。**

解读：
1. 只有浏览器才受到同源策略的限制
2. 这是个安全策略，使用不当会影响网站的安全性
3. 影响不同源的资源交互

那么再延伸一个，什么是“源”？

> 如果两个 URL 的 protocol、port (en-US) (如果有指定的话)和 host 都相同的话，则这两个 URL 是同源。这个方案也被称为“协议/主机/端口元组”，或者直接是 “元组”。（“元组” 是指一组项目构成的整体，双重/三重/四重/五重/等的通用形式）。

**个人理解：协议(protocol)、域名(host)、端口(port)；三者一致，才是同源，其中一个不一样**，就不是同源，会受到同源策略的限制无法交互。**

理解了同源策略，再来看跨域。

跨域(cross domain)：是一种场景，也是一种方案，跨域名(源)资源交互。

个人理解：当我们请求**不同源**的资源，受到同源策略的限制，这个时候说明，我们**遇到了跨域的场景**，也需要用到相关的跨域方案，**绕过同源策略的限制**。

*ps：其实一直很疑惑，如果按照浏览器的同源策略命名，跨域(cross domain)应该叫做跨源(cross origin)。*

## 常用的跨域方案、代理

1. JSONP
2. CORS
3. postMessage(iframe)
4. websocket
5. proxy
6. window.name + iframe
7. location.hash + iframe
8. document.domain + iframe

看似方法很多，其实很多原理就两种:
1. 绕过同源策略 —— `JSONP`是动态创建一个`script`标签发起GET请求，服务端响应一个可以供`js`回调使用的函即可；`iframe`是其标签的特性就决定本身不受同源策略的限制，可以跨资源访问，加上使用其相关的一些api，进行通讯交互；`webscoket`同理，也是本身可跨资源访问，连接打开双端可互相通讯；proxy，前端不直接请求目的资源，向代理服务器请求，代理服务器转发请求，转发后端api响应的数据给前端。
2. 破解同源策略 —— CORS 直接在服务器设置HTTP相关的header，允许服务器资源可被跨域访问。

然后，在实际开发中... 很多方案能实现的机率，很少。
**`JSONP`、 `iframe` 需要双端配合**，有时候我们用的是第三方的服务器资源，我们很难要求第三方的API配合我们开发。**`websocket` 更是对后端的技术选型的一个要求。**为了解决跨域，是否值得让后端使用`websocket`也是一种取舍。`CORS`是需要在服务器上设置的，如果又是第三方的资源，也是没有条件设置。

代理则是在**双端之间加入代理层**，**转发客户端的请求**，由于同源策略只是限制浏览器，代理服务器不受其影响，可以**直接跨域**。

根据个人的经验，代理（proxy）是可实现性最高的一种。我愿称之为**代理是跨域最好、也是最后的解决方案。**

## 反向代理、正向代理

代理服务器(proxy server)是一个**中介**，位于客户端和目标服务器之间的一个服务器。将**请求转发**到目标地址，再响应目标地址的数据给客户端而已。

正向代理（forward proxy）：客户端发送请求到代理服务器，代理服务器**自己再去发送请求**到目标地址。这个请求其实是**由代理服务器发的**，代理服务器接收到目标地址的响应，再响应给客户端。**服务端不知道不知道代理服务器是否为真正的客户端。**

反向代理（reverse proxy）：客户端发送请求到代理服务器，代理服务器**直接转发**请求到目的地址。目标地址响应的数据，由代理服务器响应给客户端。**客户端不知道代理服务器的存在**。

## 配置开发环境的代理

前端目标主流的`vue`、`react`项目的开发环境（web server）都是基于`node`使用`webpack`运行的，`webpack`的[devServer.proxy](https://webpack.js.org/configuration/dev-server/#devserverproxy)支持配置正向代理，以完成跨域。
但其实`devServer.proxy`是基于[http-proxy-middleware](https://github.com/chimurai/http-proxy-middleware)实现的，也就是说`http-proxy-middleware`才真正的代理服务器，`webpack`只是集成了其工具，开放了一个`devServer.proxy`的配置入口来配置相应的功能。
**区别这点很重要，代理不知道怎么配置，应该查阅[http-proxy-middleware](https://github.com/chimurai/http-proxy-middleware)的相关资料！**
然而`vue`表面看起来并不使用`webpack`，事实上是：`vue-cli`是基于`webpack`封装后实现的，[vue.config.js](https://cli.vuejs.org/zh/guide/webpack.html#webpack-%E7%9B%B8%E5%85%B3https://cli.vuejs.org/zh/guide/webpack.html#webpack-%E7%9B%B8%E5%85%B3)可以配置相应的`webpack`。
而`react`，官方的脚手架`craete-react-app`隐藏了`webpack`的配置，可以使用`npm run eject`暴露出`webpack`的配置。个人对于官方脚手架，只觉得练习demo简洁，开发生产项目更偏好于[craco](https://www.npmjs.com/package/@craco/craco)。而craco本意上是指**C**reate **R**eact **A**pp **C**onfiguration **O**verride(create-react-app配置覆盖)，所以可以理解为基于官方脚手架的封装。

```shell
vue-cli => webpack => http-proxy-middleware
craco (=> craete-react-app) => webpack => http-proxy-middleware
```

### 前置准备

1. `react`项目，使用`craco`配置
2. url设计 127.0.0.1:9999/server => 127.0.0.1:9999/proxy
3. 创建文件

public/server/data.json
```json
{
  "code":1,
  "msg":"success",
  "data": { "key": "value"}
}
```

public/server/index.html
```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Document</title>
</head>
<body>
  <h1>Hello, World!</h1>
</body>
</html>
```
4. 检查web服务是否能正常访问到上一步的两个资源（建议使用postman）; http://127.0.0.1:9999/server 、 http://127.0.0.1:9999/server/data.json
5. 访问代理的url（由于还没开始设置代理，被代理url响应结果跟上面是不一致的） http://127.0.0.1:9999/proxy 、 http://127.0.0.1:9999/proxy/data.json

### 配置http-proxy-middleware

```js
// craco.config.js
module.exports = {
  devServer: {
    proxy: {
      "/proxy": {
        target: "http://localhost:9999",
        changeOrigin: true,
        pathRewrite: {
          "^/proxy": "server",
        },
      },
    },
  },
  // ...
};
```

编写两个请求，来验证在浏览器中的表现效果。

```js
// src/index.js
const webInit = () => {
  const path = "/data.json";
  checkServer(path);
  checkProxy(path);
};
​
// 检测local server
const checkServer = async (path) => {
  const serverRequest = await fetch(`//${window.location.host}/server/${path}`, {})
    .then(function(response) {
      return response.text();
    })
    .then(function(respText) {
      console.log(respText);
    });
  return serverRequest;
};
​
// 检测代理
const checkProxy = async (path) => {
  const proxyRequest = await fetch(`//${window.location.host}/proxy/${path}`, {})
    .then(function(response) {
      return response.text();
    })
    .then(function(respText) {
      console.log(respText);
    });
  return proxyRequest;
};
​
webInit();
```

重启项目后，在浏览器中访问，两个`fetch`请求的响应结果一致，即跨域成功。

## 生产环境

项目开发完成后，我们要打包后再部署到服务器。

```shell
$ npm run build
```

部署到服务器后，浏览器访问生产环境的url，会发现两个`fetch`还是会遇到跨域问题。这是为什么呢。
开发环境使用的`node`环境，拥有`webpack`和`http-proxy-middleware`的功能和配置；打包后只剩下静态资源文件———— `*.html`， `*.css` , `*.js` `*.jpg/png/gif` 等...
> 服务器上是用nginx作为HTTP web server，所以需要在nginx再配置一次代理。
> 如果是node，就用node配置，服务器上静态资源文件被哪种HTTP web server处理，就在哪个环境配置代理。

还是以 /server => /proxy 代理策略举例。

```nginx
http {
  #...
  server {
    listen 9999；
    location /proxy/ {
      proxy_pass http://127.0.0.1:9000/server/;
      proxy_set_header Host $host;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_read_timeout 300s;
    }
    #...
  }
  #...
}
```

说到nginx，也给一下CROS的配置方案吧。

```nginx
location /proxy/ {
  add_header Access-Control-Allow-Origin *;
  add_header Access-Control-Allow-Methods 'GET, POST, OPTIONS';
  add_header Access-Control-Allow-Headers 'DNT,X-Mx-ReqToken,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,Authorization';
}
```

## 结尾

这次我们以跨域为讨论主题，重点放在代理上，了解了正向代理，反向代理，开发环境(http-proxy-middleware)、线上环境(nginx)的配置。代理能做的事情不仅仅是跨域，还可以实现负载均衡、匿名访问等。可是在跨域中，代理是最好的解决方案，一劳永逸。
