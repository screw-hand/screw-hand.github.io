---
title: github中的fork操作，为pr做准备
date: 2023-06-21 11:32:27
categories: github
tags: github
---

# 前言

为什么要fork？ 我们有时候在github上看到一些比较好的开源项目，但并不是每个开源项目都是100%完美适合我们的，我们可能需要对其代码进行一些修改。
但是我们无法对原仓库(org repo)进行直接修改，github提供了一个fork功能，可以将其仓库“分叉”(fork)到我们的账号信息下，成为分叉仓库（fork repo）。
这个时候我们就可以可以对其修改代码，并提交推送(push)到github平台。
如果我们愿意的话，也可以给原仓库提一个pull request(pr),原作者审批同意后，原仓库(org repo)就拥有了我们fork之后改动的功能。

阅读完这篇文章，你讲学到：

- 如何fork一个开源项目
- 如何知道fork与原仓库的改动
- 如何同步原仓库
- 如何将fork类型仓库转成自己的仓库

<!-- more -->

# 术语

为了表述简洁，以及提供阅读理解，先提供一些术语。
哪怕不理解也可以先眼熟一下，在下文看到了仍然不理解，重新回来再看看。

- repo: `repository`，开源项目的代码仓库
- org repo: 原来的代码仓库
- fork repo: 执行分叉后的仓库，一般在github的repo页面会提供fork自哪个org repo
- owner: 代码仓库的主人
- pull request: pr，用于申请fork repo的代码改动合并到org repo(需要org repo的owner同意)

*这些术语也不一定是专业、准确性100%，只是我个人惯称。*

github官方也提供了一个词汇表。[1]

# fork 操作

...

# 将fork类型仓库转成自己的仓库

...

# 结尾

[1] [GitHub 词汇表 - GitHub 文档](https://docs.github.com/zh/get-started/quickstart/github-glossary)

...