---
title: github中的fork技巧
date: 2023-06-21 12:50:55
categories:
tags: github
---

## 前言

进阶fork技巧，对初学者不是那么友好，建议拥有以下前置技能：

1. 使用过github的fork/pr操作
2. 熟悉使用git命令的分支，远端操作

本文各个大标题内容独立，可根据自己需求跳读:

- 如何将fork类型仓库转成自己的仓库
- 如何同步多个上游仓库

<!-- more -->

# 如何将fork类型仓库转成自己的仓库

有什么好处？

- 可以将其设置成私有仓库：fork类型的仓库无法设置成私有仓库
- 不打算提pr到上游仓库，并且想要有github的contributions（俗称：绿点/绿墙）：fork类型的仓库，就算提交到了主分支，也不会有contributions.

**使用github support的分离复刻。**

[Forks - GitHub 支持](https://support.github.com/request/fork)

![](./fork-skill/detach_fork.png)

![](./fork-skill/virtual_assistant_1.png)

![](./fork-skill/virtual_assistant_2.png)

自动弹出这个对话框，执行以下操作：
- 选择Detach/Extract
- 输入`owner/repository-name`
- 选择`Yes` (committed to this fork) 、选`No`会让你自己手动复刻一遍
- 选择`I need to use my own GitLFS data allowances and/or data-packs`

等待邮件。

上图我选择了[screw-hand/layui](https://github.com/screw-hand/layui)，作为例子。
其实之前我已经用过一次了，这是[screw-hand/github-profile-trophy](https://github.com/screw-hand/github-profile-trophy)的邮箱通知：

![](./fork-skill/mail-received.png)
![](./fork-skill/mail-done.png)

转成自己的仓库，github官方需要时间去处理， 可以参考一下两封邮箱的相差时间。


刚才选`No`的结果：

![](./fork-skill/virtual_assistant_no.png)


## 结尾

为什么有时候提交了没contributions/绿点/绿墙： [Why are my contributions not showing up on my profile? - GitHub Docs](https://docs.github.com/en/account-and-profile/setting-up-and-managing-your-github-profile/managing-contribution-settings-on-your-profile/why-are-my-contributions-not-showing-up-on-my-profile)

...