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
- repo

<!-- more -->

## 配置

1. 打开Git Bash，配置用户名字和邮件地址

```bash
$ git config --global user.name "Your Name"![Uploading 图片.png…]()

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

![github-new-ssh.png](/git-note/github-new-ssh.png)

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

个人常用命令，整理到一块，以后忘记了就直接复制，省事也方便。

### 克隆仓库

```shell
# 克隆仓库
$ git clone <remote_repo>

# 克隆仓库到指定path（path推荐相对目录）
$ git clone <remote_repo> -- <path>
#
# 克隆仓库指定源
$ git clone -b <branch> <remote_repo>
```

### 工作区暂存区文件管理

```bash
# 清除工作区指定路径(<path>)下的所有文件修改（重置文件） / 重置未暂存的文件
$ git checkout -- <path>

# 清空暂存区指定路径(<path>)文件（不重置修改）/ 取消已暂存文件
$ git reset -- <path>

# 清空工作和暂存区的所有更改（重置本次提交，不会处理untracked files）
$ git reset HEAD --hard

# 删除 untracked files(-f) 包括目录(-d)
$ git clean -fd
```

### 比对文件

```bash
# 比对指定路径（<path>）文件和暂存区的区别
$ git diff <commit> -- <path>

# 比对已经暂存起来的文件(staged)和上次提交时的快照之间(HEAD)的差异
$ git diff --cached
$ git diff --staged

# 比对指定路径（<path>）两次提交
$ git diff <hash1> <hash2> -- <path>

# 比对行改动，不显示具体内容
$ git diff --stat
```

### 提交文件

```bash
# 全部暂存并提交
$ git commit -am "commit log"

# 多行插入空行提交
$ git commit -m '1.line-1' - m '2.line-2'

# 多行提交
$ git commit -m '
1. line-1
2. line-2
'

# 修改上一次提交信息
$ git commit --amend -m "New commit message"
```

### 工作日志

```bash
# 简化工作日志
$ git log --pretty=oneline

# 查看分支合并情况
$ git log --graph

# 查看分支合并情况，简化提交信息、hash简写
$ git log --graph --pretty=oneline --abbrev-commit

# 美化输出、查看分支合并情况、简化提交信息、hash简写
$ git log --color --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'  --graph  --abbrev-commit
```

### 分支

```bash
# 查看本地分支
$ git branch

# 查看本地分支简单信息（分支名 最后一次commit id， commit message）
$ git branch -v

# 查看所有分支信息（本地还有远端)
$ git branch -a

# 查看本地跟踪远端分支情况
$ git branch -vv

# 组合使用 -vv -v -a
$ git branch -vv -v -a
$ git branch -vvav

# 重命令分支
$ git branch -m <old_name> <new_name>

# 切换分支
$ git checkout <branch>

# 指定提交检出新分支
$ git checkout <hash> -b <branch_name>

# 拉取远端分支到本地新分支
$ git checkout -b <new_branch> <remote> <branch>

# 合并分支
$ git merge <branch>
```

### 远端

```bash
# 远端版本信息
$ git remote -v

# 添加git远端仓库
$ git remote add <url>

# 拉取远端分支提交
$ git pull origin master

# 推送远端分支提交
$ git push origin master

# 拉取远端分支到本地新分支
$ git checkout -b <new_branch> <remote>/<branch>
```

### 配置

```bash
# 查看全局配置列表
$ git config --global --list

# 查看本地仓库配置列表
$ git config --local --list
```

### 其他

```bash
# 命令历史
$ git reflog

# 变基
$ git rebase -i

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

### 别名

GIt 支持为命令自定义别名，比如我们希望**全局设置** `git br` 映射为 `git branch`，**仓库设置** `git st` 映射为 `git status`，我们可以在终端这样配置。

```bash
# 配置别名
git config --global alias.br branch
git config --local alias.st status
```

现在就可以使用`git br` 、`git st`了，不过`git st`是**仓库级别**的设置，切换到其他仓库就无效了。我不需要省敲几个键，这样子的映射对我无效，我需要映射的是一些很长难输入又实用的命令。我们先删除它，再配置我自己偏好的别名。

```bash
# 删除别名
git config --global --unset alias.br
git config --local --unset alias.st
```
我们本地还有全部的别名都被删除了，当然你也可以直接修改配置文件，但是不推荐。

```bash
git config --global alias.logs "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
git config --global alias.detail-log "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
```

现在`git logs` 还有`git detail-log`都可以输出漂亮的git日志 :-)

## 速查表

![git-guide.jpg](/git-note/git-guide.jpg)

<!--
- [Git log 高级用法](https://www.cnblogs.com/zhangjianbin/p/7778625.html)
- [Git config 配置](https://www.cnblogs.com/fireporsche/p/9359130.html)
- [Git diff](https://www.cnblogs.com/qianqiannian/p/6010219.html)
- [Git使用中的一些奇技淫巧](https://mp.weixin.qq.com/s?__biz=MzIxMjE5MTE1Nw==&mid=2653194157&idx=2&sn=dca9f9c61f064f508c3c17824e0c6b13&chksm=8c99f577bbee7c61d5eb51d26f007f724197435b80006b05e17381d0a11eb7b5347b58a92a05&mpshare=1)
-->
