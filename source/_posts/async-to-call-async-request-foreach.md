---
title: 同步遍历调用异步请求
categories: js
date: 2020-10-06 11:11:50
tags: js
---

业务场景：一次性发送多个http请求，并且这些请求有**先后顺序**之分。

<!-- more -->

## 异步调用用单个http请求

```js
// mock http 请求，并且服务器响应了请求
function mockRequest(requestBody, delayTime) {
  return new Promise(resolve => {
    setTimeout(function () {
      // 随意resolve一个json即可
      resolve({
        statusCode: 200,
        requestId: Math.random().toString().split('.').join(''),
        data: requestBody
      })
    }, delayTime || 0)
  })
}

// 简单的这样调用是不够的，因为是异步请求，我们需要一个回调函数（call back）
mockRequest({
  id: '000',
  query: 'a'
}, 1000)

async function getSilgleRequestData () {
  const res = await mockRequest({
    id: '000',
    query: 'a'
  }, 2000)
  if (res && res.statusCode === 200) {
    console.log(res) // { statusCode: 200, requestId: '00896521783396853', data: { id: '000', query: 'a' } }
  }
}

getSilgleRequestData()
```

实际开发中比较常用的单个调用http请求我们已经实现了，那么也有在项目中一次操作（或者叫事件）触发多个请求，如果接口之间没有依赖关系，一般都是**并发执行**发送请求的。

## 异步并行调用多个http请求

```js
// 仍然保留之前定义的 mockRequest

// 第一条接口
async function getRequestA () {
  const res = await mockRequest({
    id: '00A',
    type: 'getRequestA'
  }, 2000)
  if (res && res.statusCode === 200) {
    return res
  }
}

// 第二条接口
async function getRequestB () {
  const res = await mockRequest({
    id: '00B',
    type: 'getRequestB'
  }, 1000)
  if (res && res.statusCode === 200) {
    return res
  }
}

async function getMutilRequestData () {
  console.time()
  const resA = await getRequestA()
  const resB = await getRequestB()
  console.timeEnd() // 输出为？？
  if (resA.statusCode === 200) {
    console.log(resA)
  }
  if (resB.statusCode === 200) {
    console.log(resB)
  }
}

getMutilRequestData()

```

因为上述两条api没有依赖关系，所以我们可以这些写：

```js
const resA = await getRequestA()
const resB = await getRequestB()
```

如果是有依赖关系的话——`getRequestA`的**响应数据(response data)**会被`getRequestB`作为**请求参数(request data)**使用，那么应该这样做：

```js
const resA = await getRequestA()
if (resA.statusCode === 200) {
  const resB = await getRequestB(resA.data.id)
  if (resB.statusCode === 200) {
    console.log(resB)
  }
}
```

## 同步遍历中发送异步http请求

所以结合以上所有，我们需要一次性发送多条api，有顺序的要求，那么我们可以定义一个数组，这个数组的每个元素都是请求参数，循环此数组，使用递归函数的方式调用api请求。

```js
// ... mockRequest

// 递归函数，遍历requestList元素，依次发送请求，当前请求响应成功后才会发送下一个请求
async function getData (requestList, callback, i = 0) {
  let delayTime = 0
  const res = await mockRequest(requestList[i], delayTime+=1000)
  if (res && res.statusCode === 200) {
    callback(res)
    if (++i < requestList.length) {
      getData(requestList, callback, i)
    }
  }
}

// 定义请求参数，每一个元素都是一次请求，元素的内容都是请求参数
const requestList = [
  {
    id: '001',
    query: 'x'
  },
  {
    id: '002',
    query: 'y'
  },
  {
    id: '003',
    query: 'z'
  }
]

getData(requestList, function (res) {
  console.log(res)
})
```

## 更多

这只是一个比较简陋的实现方案，并非最佳实践。比如此回调是每次请求成功的回调，有些业务场景需要全部请求完成后执再执行回调，还有这是依次发送请求的，也可以实现一个并行请求的方式，更多的扩展功能不再讲述。