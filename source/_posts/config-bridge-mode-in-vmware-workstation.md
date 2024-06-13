---
title: 如何在 VMware Workstation 中配置桥接模式
date: 2024-06-13 10:45:50
categories: DevOps
tags:
  - linux
---
1. 准备工作
   - 确保宿主机的物理网卡已启用并正常工作。
   - 确保 VMware Workstation 和虚拟机的网络驱动程序是最新的，并且与操作系统兼容。

2. 配置 VMware Workstation 的虚拟网络编辑器
   - 打开 VMware Workstation，点击 "编辑" 菜单，选择 "虚拟网络编辑器"。
   - 选择 "VMnet0"（默认用于桥接模式的虚拟交换机），确保它处于 "桥接模式"。
   - 在 "桥接到" 下拉菜单中，选择 "自动" 或宿主机上用于桥接的特定物理网卡。
   - 点击 "确定" 保存设置。

3. 配置虚拟机的网络适配器
   - 关闭虚拟机（如果正在运行）。
   - 在 VMware Workstation 主界面，选择虚拟机，点击 "编辑虚拟机设置"。
   - 在 "硬件" 选项卡下，选择 "网络适配器"。
   - 将 "网络连接" 更改为 "桥接模式"，并选择 "复制物理网络连接状态"。
   - 点击 "确定" 保存设置。

4. 配置虚拟机内部的网络
   - 启动虚拟机。
   - 编辑 `/etc/netplan/01-network-manager-all.yaml` 文件（如果文件名不同，请相应调整），配置内容如下：

     ```yaml
     network:
       version: 2
       renderer: NetworkManager
       ethernets:
         ens33:
           dhcp4: yes
     ```

   - 应用新的网络配置：

     ```bash
     sudo netplan apply
     ```

   - 检查虚拟机是否已获得与宿主机同一网段的 IP 地址：

     ```bash
     ip addr show ens33
     ```

5. 验证和故障排除
   - 确保虚拟机的网络接口已启用，并已获得正确的 IP 地址。
   - 尝试从虚拟机 ping 宿主机和其他网络设备，以验证连通性。
   - 如果遇到问题，请检查：
     - VMware Workstation 的虚拟网络编辑器设置
     - 虚拟机的网络适配器设置
     - 虚拟机内部的 netplan 配置
     - 宿主机的网络连接和物理网卡状态

```shell
sudo systemctl restart NetworkManager
```