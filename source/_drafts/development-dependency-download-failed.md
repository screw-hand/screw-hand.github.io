---
title: 如何解决开发依赖下载失败
date: 2024-01-28 13:54:03
categories: 
tags:
---

<!--

[谷歌翻译不能用的解决方案 | 划词翻译](https://hcfy.app/blog/2022/09/28/ggg#%E6%96%B9%E6%A1%88-b%E4%BF%AE%E6%94%B9-ip)

-->

很多时候，由于软件依赖是国外的资源。在国内的网络环境，直接连接国外的资源，要么下载速度堪忧，要么直接资源无法访问，结果下载失败。使得无法正常使用一些软件开发软件，影响开发环境，导致无法开发。包括但不限于以下软件资源：

- node
- npm/yarn/pnpm
- Android SDK
- Gradle
- python/pip
- homebrew
- apt
- ... 其他国外资源

<!-- more -->

这是一篇偏思路的经验贴子，不是保姆式的step by step教程，如果某些步骤的操作无法完成，请适量寻找谷歌/AI的帮助。搜索时注意明确自己使用的使用环境——操作系统，代理软件，SHELL种类。以下实例演示为mac+zsh+clash。某些区别比较大的环境，操作步骤完全不能共用。

<!--  more -->

一些区别比较大的环境：
- windows操作系统跟类unix(mac、linux)操作系统区别很大
- mac跟linux的操作系统区别比较小
- cmd、powershell跟bash/zsh/git-bash(常在win系统做为bash的次级替代品)的区别很大
- git-bash/bash的区别很大，但是常用类unix命令， 环境变量的配置一致
- bash、zsh的区别很小，但是环境变量的配置文件不一样

由于一般shell(命令行)环境比GUI(图形界面)软件下载依赖更加困难，这里以命令行软件举例，当然GUI也会稍微提及。

解决方法（由易到难、由一次性解决到永久解决）：
1. 镜像
2. 代理软件
3. shell设置代理
4. TUN Mode

如果仍未解决，也提供一些排查的思路。

不建议自行跳读章节，能跳读的章节，会特别说明。

# 速通

此章节为没耐心、想快速解决现在的下载问题的用户而写，提供引导。

如果本次问题解决了，还是希望回来阅读全文，对提高解决此类问题的技能，以及相关领域的知识面。

1. 代理软件开启全局模式
2. 查询代理软件监听的端口
3. 为相应的shell设置临时代理（只有本次生效）
4. 输入命令`curl -I https://google.com` 检查与google是否能正常连接
5. 执行下载资源的操作
6. 下载完成后，把代理软件的全局模式改成规则模式

## 查询代理软件监听的端口

常用代理软件的默认监听端口如下：

| 代理软件  | 协议类型 | 默认地址和端口       |
|----------|--------|-------------------|
| Shadowsocks | SOCKS5 | 127.0.0.1:1080    |
|           | HTTP   | 127.0.0.1:8123    |
| V2Ray    | SOCKS5 | 127.0.0.1:1080 |
|           | HTTP/HTTPS | 127.0.0.1:8080 |
| Clash    | HTTP   | 127.0.0.1:7890    |
|           | SOCKS5 | 127.0.0.1:7891    |
|           | 管理界面 | 127.0.0.1:9090   |

如果更改了默认端口，或者不确定监听端口是否默认端口，建议自行在代理软件自行检查。

## 设置临时代理
监听的端口以`7788`举例。`socks5`协议如果知道端口可以设置，不知道的话，默认为http/https端口。cmd/powershell默认不支持`socks5`。

```shell
# cmd
set http_proxy=http://127.0.0.1:7788 & set https_proxy=http://127.0.0.1:7788 

# powershell
$Env:http_proxy="http://127.0.0.1:7788";$Env:https_proxy="http://127.0.0.1:7788" 

# bash/zsh/git-bash
export https_proxy=http://127.0.0.1:7788 http_proxy=http://127.0.0.1:7788 all_proxy=socks5://127.0.0.1:7788
```

# 镜像
不能正常代理订阅流的情况下，只能使用镜像去解决依赖下载失败问题。

镜像站点是指那些提供与原始站点相同内容但位于不同物理位置的服务器或网站。镜像站点通常用于提高数据的可访问性和下载速度，尤其是在地理位置较远或网络连接较慢的情况下。

可以通过\[资源名称\]+镜像的关键字直接去网上搜索：
- ubuntu镜像
- docker镜像
- xx镜像

找到了镜像的资源后，都需要自己对软件进行配置，镜像网站会提供相应的资料。

这里有常用的镜像网站汇总：[myd7349/mirrors: 开源软件国内镜像](https://github.com/myd7349/mirrors)

## 使用npm的开发者
[mirror-config-china - npm](https://www.npmjs.com/package/mirror-config-china)
为中国内地的Node.js开发者准备的镜像配置，大大提高node模块安装速度。

```shell
npm i -g mirror-config-china --registry=https://registry.npmmirror.com
```

[nnrm - npm](https://www.npmjs.com/package/nnrm)
新的 npm 源管理器， 可分别为：npm，yrm，pnpm配置镜像源。

```shell
npm i -g nnrm --registry=https://registry.npmmirror.com
```

镜像虽然使用方便，但是并不全能。有些软件资源并没有提供镜像；而提供镜像的，质量很依赖平台的实现，有些跟官方源同步比较慢，有些可能稳定不好，或者资源有问题。

所以下面的章节会介绍使用代理软件对官方源进行网络连接下载。

# 代理软件

操作系统作用域：GUI类型的软件，一般搭配代理软件的**系统代理**模式使用即可。
软件级别作用域：可以不启动系统代理模式，单独在GUI软件设置网络代理。以Android Studio举例：[Configure Android Studio  |  Android Developers](https://developer.android.com/studio/intro/studio-config)

查看操作系统的系统代理：
win："开始"->"设置"->"网络和Internet"->"代理"->"使用代理服务器（开）"

## 三个重要的问题

1. 系统代理是什么？

设置代理的**作用范围**
- 不开启：需要在每个软件手动配置软件的网络代理
- 开启：大部分软件的网络都会经过代理软件处理，有些软件不遵循系统代理的设置就需要另外单独设置（比如shell）

2. 代理模式的全局/规则/重定向是什么？

表示分流模式设置：
- 全局：不分流，所有经过代理软件的请求都发送到同一代理节点
- 规则：不同的网络请求会根据分流配置文件，发送到不同的节点去处理
- 重定向/直连：所有经过代理软件的网络请求都直接重定向到目标服务器，不走节点，类似直连

3. shell为什么在系统代理+全局模式的设置下不走代理？

从以上2点可总结：因为系统代理对shell无效，网络请求不经过代理软件；全局模式只是针对经过代理软件的网络请求做分流限制，所以代理模式无论是否全局都无效。

**系统代理对终端环境无效**，所以我们不得不采取“软件级别作用域”的策略，给shell单独设置网络代理。

接下来介绍的三种方式，其实都是在终端软件给shell配置代理。每次配置完成后，都建议使用`curl -I https://google.com` 检查是否能正常连接外网。

三种方式其实都是设置环境变量， 区别只是**临时**、**配置文件**、**脚本**的方式去执行罢了。

## 临时代理

参考：[速通 > 临时代理](#设置临时代理)

单次使用特别方便，就是不具备持久性。长长的一段命令行需要单独找另外的地方保持起来，用的时候要复制粘贴到终端。

## 配置文件

### bash/zsh/git-bash

bash每次启动的时候，会去执行`~/.bashrc`这个配置文件的命令，所以我们只要bash设置代理的命令直接放到`~/.bashrc`就可以了。

```shell
# ~/.bashrc
export https_proxy=http://127.0.0.1:7788 http_proxy=http://127.0.0.1:7788 all_proxy=socks5://127.0.0.1:7788
```

win用户，使用git-bash也可以配置`~/.bashrc`。

对于zsh，配置文件是`~/.zshrc`，具体配置同上。

配置完成后，当前终端需要执行一下命令以更新环境变量。也可以打开一个新的终端窗口。

```shell
# bash/git-bash
source ~/.bashrc

# zsh
source ~/.zshrc
```

注意：git-bash配置了代理，由于跟cmd、powershell是不同的shell，在哪个shell配置，只有那个shell才有代理。bash/zsh也是同理。

配置完成，curl检查谷歌连接...

### cmd && powershell

其实更建议win用户使用git-bash，比较接近bash，cmd/powershell可供参考以下资料。

[设置Windows系统的cmd命令行终端的代理 - Sureing - 博客园](https://www.cnblogs.com/pengpengboshi/p/17188143.html)

[windows命令行设置代理、powershell设置代理 - IT伙伴-小泥吧科技](https://ithb.vip/478.html)

**记得关闭当前终端，重新打开，否则环境变量不更新。**

配置完成，curl检查谷歌连接...

## 代理脚本

1. 编写以下文件`~/bin/proxy`，不要文件格式。
```shell
#!/bin/bash

export https_proxy=http://127.0.0.1:7788
export http_proxy=http://127.0.0.1:7788
export all_proxy=socks5://127.0.0.1:7788

echo "\$https_proxy=$https_proxy"
echo "\$http_proxy=$http_proxy"
echo "\$all_proxy=$all_proxy"
```

2. `~/bin/reset-proxy`

```shell
#!/bin/bash

export https_proxy=''
export http_proxy=''
export all_proxy=''

echo "\$https_proxy=$https_proxy"
echo "\$http_proxy=$http_proxy"
echo "\$all_proxy=$all_proxy"
```

相对于之前的一行命令代理，既然用文件写脚本了，就适当换行，检查相应环境变量。

不需要指定文件格式，不然执行命令需要带上`.sh`。

3. 给文件添加**执行权限**。

```shell
chmod +x ~/bin/proxy
chmod +x ~/bin/reset-proxy
```

```
bash-3.2$ ls -l ~/bin/*proxy
-rwxr-xr-x@ 1 wu  staff  232 Feb  4 17:56 /Users/wu/bin/proxy
-rwxr-xr-x@ 1 wu  staff  173 Feb  4 17:59 /Users/wu/bin/reset-proxy
```

`-rwxr-xr-x`最后一个字符为`x`，执行命令出现`Permission denied`应该检查文件**执行权限**问题，
编辑完可以在终端使用以下命令启动/关闭代理。

```shell
# 启动代理
source ~/bin/proxy

# 关闭代理
source ~/bin/reset-proxy
```

curl检查谷歌连接...

4. 使用别名优化命令
上面的命令太长了，`source` 可以优化成`.`，`~/bin/proxy`需要设置环境变量，但是也可以用别名。

```shell
alias proxy='. ~/bin/proxy'
alias reset-proxy='. ~/bin/reset-proxy'
```

同样的，`alias`跟`export`一样都是临时命令，需要把以上命令添加成对应的shell配置文件，参考[代理软件 > 配置文件](#配置文件)

现在就可以直接在命令行使用`source` / `reset-proxy`切换代理了。

同样，curl检查谷歌连接...

## 应该使用哪种方式设置代理?
策略|优点|缺点|原因|
|----------|--------|-------------------|-------------------|
|临时代理|最简单、快捷，不需要学习shell脚本|一次性,每次都需要复制命令行|不建议：每次都需要复制命令行，麻烦|
|配置文件|方便，shell自动使用代理|若代理规则有误，容易造成多余流量使用|建议：较强的容错机制，不用等出现资源下载失败了再来排查|
|代理脚本|灵活，可随时切换是否使用代理|每次都需要使用者自行判断是否使用代理|建议：对软件资源比较熟悉的开发者提供了更高的自由度|

# TUN Mode
如果是国内的云服务器，不建议使用TUN Mode，使用上一章节的[临时代理](临时代理)/[配置文件](临时代理)即可。



# 小结
- 镜像 - 建议，作为主要方案
- shell临时代理 - 临时方案，不建议长久使用
- shell配置文件 - 推荐，自动使用代理
- shell脚本文件 - 推荐，手动管理代理
- TUN - 永久解决方案 ，不需要自己管理软件代理

我自己本地的方案（生效权重优先级）：
1. 配置镜像 - 节约订阅流的使用流量
2. TUN Mode - 镜像失效/错误时，取消镜像配置

云服务方案（生效权重优先级）：
1. 配置镜像 - 节约订阅流的使用流量
2. 代理脚本 - 默认不使用代理，若无法下载资源，则启动脚本，而后关闭

# 仍未解决

- 日志排查
- 代理软件分流
- DNS污染

# FQA
Q：怎么确定自己是不是使用了代理？
A：检查代理软件的连接输出或者日志记录，如果有出现相应的记录，则说明使用了代理。

Q：网络连接在代理软件有相应的记录，但还是无法成功下载？
A：一般这种情况很少，但可能是分流规则不够完善。在软件上检查相应记录的详情：如果是`DIRECT`，则说明你跟目标源是**直连**的，此时不走机场。如果是

Q: 所有的shell都支持`curl`命令吗？
A: cmd/powershell/git-bash/zsh都支持`curl`命令，无需安装任何依赖。

```shell
# cmd
> where curl
C:\Windows\System32\curl.exe 

# powershell
> Get-Command curl
CommandType     Name                                               Version    Source
-----------     ----                                               -------    ------
Cmdlet          Invoke-WebRequest                                  3.1.0.0    Microsoft.PowerShell.Utility 

# bash
$ whereis curl
curl: /usr/bin/curl /usr/share/man/man1/curl.1

$ which curl
/usr/bin/curl
```