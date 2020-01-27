---
title: git笔记
date: 2020-01-27 23:04:27
categories: git
tags: git
---

## 简介

部分重要概念。

- HEAD
- Working Directory / Repository / Stage
- branch
- remote
- tag

<!-- more -->

## 配置

1. 打开Git Bash，配置用户名字和邮件地址

```bash
$ git config --global user.name "Your Name"
$ git config --global user.email "email@example.com"
```

2. 本机创建SSH，Github配置SSH

一路回车

```bash
$ ssh-keygen -t rsa -C "youremail@example.com"
```

`win+r`输入`%USERPROFILE%/.ssh`,成功打开且有以下文件则成功.

1. id_ras：私钥，不能泄露
2. id_ras.pub：公钥，可以告诉任何人

**以下操作需要Github账号，若无需注册。**

添加SSH密钥 [传送门](https://github.com/settings/keys/new)

![github-new-ssh.png](github-new-ssh.png)

3. 测试配置

- Github新建仓库，初始化
- 本地clone下来，修改后提交，查看提交者信息是否正确
- 推送至远端仓库，输入密码
- 再次修改后提交，若SHH配置成功，无须输入密码

操作省略..

## 文件状态

| 简写 | 英文 | 翻译 |
| --- | --- | :---: |
| M | modified | 修改 |
| R | renamed | 重命名 |
| C | both modified | 冲突 |
| R | Untracked | 未跟踪 |

## 命令分析

一些常用的命令分析，我很喜欢命令行，不过[source tree](https://www.sourcetreeapp.com/)也挺方便的。

### `git status`

**输出信息**
- 当前分支
- 远端分支状态（是否拉取/更新）
- 暂存区
- 工作区

**实例分析**

```bash
On branch master
Your branch is ahead of 'origin/master' by 1 commit.
  (use "git push" to publish your local commits)

Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)

        modified:   src/main.js

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)

        modified:   src/components/person-filed/index.vue
        modified:   src/router.js
        modified:   src/views/loop-action/index.vue

# ===== 翻译分割线 =====

位于master分支
您的分支超前“origin / master”一次提交。
   （使用“git push”发布您的本地提交）

要提交的更改：
   （使用“git reset HEAD <file> ...”取消暂存）

         修改：src / main.js

未提交更改的更改：
   （使用“git add <file> ...”来更新将要提交的内容）
   （使用“git checkout  -  <file> ...”来丢弃工作目录中的更改）

         修改：src / components / person-filed / index.vue
         修改：src / router.js
         修改：src / views / loop-action / index.vue
```

### `git commit`

**输出信息**

- 提交分支
- commit hash值
- 修改文件数量
- 增删行数

**实例分析**

```bash
[master 2918d65] 1
 1 file changed, 1 insertion(+)
 
# ===== 翻译分割线 =====

 [master 2918d65] 1
  1个文件已更改，1行插入（+）
```

### `git checkout`

自修改后还没有被放到暂存区--回到版本库的状态；
已经添加到暂存区后，又作了修改--就回到添加到暂存区后的状态。

git checkout其实是用版本库里的版本替换工作区的版本，
无论工作区是修改还是删除，都可以“一键还原”。


## 常用命令

```bash
# 清除工作区指定路径(<paths>)下的所有文件修改
$ git checkout -- <paths>

# 清空暂存区指定路径(<paths>)文件（不重置修改）
$ git reset -- <paths>

# 清空工作和暂存区的所有更改（重置本次提交）
$ git reset HEAD --hard

# 删除 untracked files(-f) 包括目录-d
$ git clean -fd

# 比对指定路径（<path>）文件
$ git diff <commit> -- <path>

# 查看已经暂存起来的文件(staged)和上次提交时的快照之间(HEAD)的差异
$ git diff --cached
$ git diff --staged

# 比对两次提交
$ git diff <hash1> hash2 -- <path>

# 比对行改动，不显示具体内容
$ git diff --stat

# 全部提交
$ git commit -am "commit log"

# 多行插入空行提交
$ git commit -m '1.line-1' - m '2.line-2'

# 多行提交
$ git commit -m '
1. line-1
2. line-2
'

# 简化工作日志
$ git log --pretty=oneline

# 查看分支合并图
$ git log --graph

# 查看分支的合并情况，简化提交信息、hash简写
$ git log --graph --pretty=oneline --abbrev-commit

#命令历史
$ git reflog

# 重命令分支
$ git branch -m <old_name> <new_name>

# 切换分支
$ git checkout <branch>

# 合并分支
$ git merge <branch>

# 远端版本信息
$ git remote -v

# 添加git远端仓库
$ git remote add <url>

# 拉取远端分支提交
$ git pull origin master

# 推送远端分支提交
$ git push origin master

# 拉取远端分支到本地新分支
$ git checkout -b <new_branch> <remote> <branch>
```

## skill

一些简简单单的小技巧。

### 忽略文件/目录

根目录创建.gitignore文件。

windows系统需使用命令行创建，打开cmd，定位。

```shell
> type nul > .gitignore
```

.gitignore文件添加需要忽略的文件/目录即可。

一般不需要自己编辑，github官方也提供了不同语言的.gitignore [传送门](https://github.com/github/gitignore)

### 提交空目录

创建 .gitkeep 文件，内容如下

```
# Ignore everything in this directory 
* 
# Except this file !.gitkeep 
```

![git-guide.jpg](git-guide.jpg)

<!--
- [Git log 高级用法](https://www.cnblogs.com/zhangjianbin/p/7778625.html)
- [Git diff](https://www.cnblogs.com/qianqiannian/p/6010219.html)
-->
