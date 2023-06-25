---
title: 项目部署
date: 2020-01-17 00:30:34
tags:
---

工作中实操过的项目部署记录，使用的是Ubuntu系统，nignx 和 C# 的运行环境均已安装。

## 前期配置文件准备

```shell
# 以acs.HOST.cn举例 （HOST）为主域名

# 项目路径
/home/wwwroot/acs.xxx.cn

# 从服务器下载文件配置文件（需要本机使用pscp或其他支持ftp协议的程序）
pscp USERNAME@IP:/home/wwwroot/acs.HOST.cn/appsettings.json E:\PATH

# nginx 配置acs 所有项目(HOSTboss.conf)
usr/local/nginx/conf/HOSTboss.conf

# nginx 配置路径
usr/local/nginx/conf/nginx.conf

# 守护进程
/etc/systemd/system/apps.acs.serive
```

<!-- more -->

## 配置nginx

```shell
# 创建项目目录
sudo mkdir /home/wwwroot/acs.HOST.cn

# 设置文件夹权限为完全访问
sudo chmod 777 acs.HOST.cn

# 切换到nginx目录
cd /usr/local/nginx
cd ./conf

# 上传项目配置
# C:\Users\Admin\Downloads\pscp.exe
.\pscp.exe E:\PATH\HOSTboss.conf USERNAME@acs.HOST.cn:/home/wwwroot/acs.HOST.cn

# 移动文件
sudo mv HOSTboss.conf /usr/local/nginx/conf

# 检查include
sudo vim /usr/local/nginx/conf/nginx.conf

# 检查证书 HOST.cn.key  HOST.cn.pem
ls /usr/local/nginx/conf/cert

# 测试 重载nginx
cd /usr/local/nginx
cd ./sbin
sudo ./nginx -t # 测试
sudo ./nginx -s reload # 重载
```

## 项目部署、守护进程

```shell
# 上传已打包的项目到服务器
.\pscp.exe E:\PATH\acs.HOST.cn\FILENAME.zip USERNAME@acs.HOST.cn:/home/wwwroot/acs.HOST.cn

# 解压
cd /home/wwwroot/acs.HOST.cn
sudo unzip -o FILENAME.zip

# 检查证书 HOST.pfx
ls /home/wwwroot/acs.HOST.cn/

# 移动守护进程配置文件到指定目录
sudo mv ./apps.acs.service /etc/systemd/system

# 定义守护进程
sudo systemctl enable apps.acs.service

# 开启进程
sudo systemctl start apps.acs.service

# 查看状态
sudo systemctl status apps.acs.service
```

## 备注

web服务器只需部署nginx

- sso
- boss
- mgt

部署成功，对外开放三个地址

- `https://sso.HOST.cn`  单点登录
- `https://boss.HOST.cn` 门户网站
- `https://mgt.HOST.cn`  一体化管理中心
