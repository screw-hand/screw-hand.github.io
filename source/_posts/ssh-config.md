---
title: ssh配置
date: 2023-07-05 19:48:57
categories: cli
tags: cli, ssh
---

- 多个账号配置ssh key
- ssh免密码登录

...

<!-- more -->

# 多个账号配置ssh key

```shell
cd ~/.ssh
ssh-keygen -t rsa -C "youremail1@xxx.com"
Generating public/private rsa key pair.
Enter file in which to save the key (/Users/wu/.ssh/id_rsa): [ssh-key-name]

# ~/.ssh/下创建config文件
# ~/.ssh/config start
Host github.com
    HostName github.com
    PreferredAuthentications publickey
    # 使用HostName的时候，指定使用~/.ssh/github的ssh密钥
    IdentityFile ~/.ssh/github

Host 192.168.110.220
    HostName 192.168.110.220
    PreferredAuthentications publickey
    Port 22
    IdentityFile ~/.ssh/192.168.110.220
# ~/.ssh/config end

ssh -T git@192.168.110.220 -p 22
# Welcome to GitLab, @chris!
```

# ssh免密码登录

```shell
cd ~/.ssh
# 创建ssh密钥
ssh-keygen -t rsa -C "youremail1@xxx.com"
Generating public/private rsa key pair.
Enter file in which to save the key (/Users/wu/.ssh/id_rsa): [ssh-key-name]

# 复制指定ssh密钥到服务器，以后登录的时候就不需要输入密码了
ssh-copy-id -i ~/.ssh/id_rsa.pub root@$SERVER

# 登录远端服务器
ssh root@$SERVER
cat ~/.ssh/authorized_keys
exit

# 测试跟服务器的连接
ssh -T root@$SERVER
```

# 结尾

- [Using the SSH Config File | Linuxize](https://linuxize.com/post/using-the-ssh-config-file/)
- [ssh免密码登录-腾讯云开发者社区-腾讯云](https://cloud.tencent.com/developer/article/1456064)

...