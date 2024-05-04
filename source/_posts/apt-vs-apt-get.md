---
title: apt vs apt-get
date: 2023-06-20 11:52:03
categories: geek
tags:
  - linux
  - ubuntu
---
apt和apt-get都是Ubuntu的包管理工具，在较新的系统推荐用apt，apt比apt-get更新，后者的兼容性会更好。apt也会让其依赖项一起升级。

<!-- more -->

# `apt` vs `apt-get`

On Ubuntu, both `apt` and `apt-get` are package management commands used to handle software packages. Here's an overview of the differences between the two:

1. **User Interface**: `apt` provides a more user-friendly and streamlined interface compared to `apt-get`. It aims to simplify package management tasks by offering clearer and more concise output, progress bars during installation, and easier-to-understand prompts.

2. **Command Syntax**: The command syntax for `apt` and `apt-get` is different. `apt` uses a more straightforward and intuitive command structure, while `apt-get` has a slightly more complex and traditional syntax.

3. **Package Dependency Handling**: `apt` includes automatic handling of package dependencies by default. It automatically resolves and installs any necessary dependencies when you use the `apt install` command. In contrast, with `apt-get`, you may need to use the separate `apt-get build-dep` command to install build dependencies for source packages.

4. **Compatibility**: `apt-get` is more established and has been around for a longer time. It is compatible with older versions of Ubuntu and other Debian-based distributions. `apt`, introduced in Ubuntu 16.04, is designed to be backward-compatible with `apt-get`, meaning you can still use `apt-get` commands on newer Ubuntu versions without issues.

In general, if you're using a newer version of Ubuntu, `apt` is recommended due to its improved user experience and simplified syntax. However, both `apt` and `apt-get` are capable package management tools, and you can choose the one that best suits your preferences and requirements.

It's worth noting that there are other package management commands available on Ubuntu, such as `apt-cache` for querying package information and `aptitude` for a more advanced package management interface.

# `apt update` vs `apt upgrade`

update 命令只会获得系统上所有包的最新信息，并不会下载或者安装任何一个包。 而是 apt upgrade 命令来把这些包下载和升级到最新版本。

[技术|apt 的 update 和 upgrade 命令的区别是什么？](https://linux.cn/article-14994-1.html)