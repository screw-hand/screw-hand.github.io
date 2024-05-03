---
title: 如何让mac的vscode-insiders支持在web上直接安装扩展
date: 2023-08-1416:27
categories: geek
tags:
  - mac
  - vscode
---
mac使用vscode-insiders，无法直接在网页上直接安装扩展。

<!-- more -->

Dracula Official - Visual Studio Marketplace
https://marketplace.visualstudio.com/items?itemName=dracula-theme.theme-dracula

# `vscode://`

在 macOS 上，更改默认的应用程序来处理特定的 URL 方案（如 `vscode://`）可能需要一些手动的操作：

1. **查找 VS Code Insiders 的 Bundle Identifier**：首先，找到 VS Code Insiders 的 Bundle Identifier。这可以通过在终端中运行以下命令来实现：
    
    bashCopy code
    
    `osascript -e 'id of app "Visual Studio Code - Insiders"'`
    
    请确保应用程序的名称是正确的。
    
2. **更改 URL 方案的关联**：使用一个名为 [Duti](https://github.com/moretension/duti) 的开源工具来更改 URL 方案的关联。首先，安装 Duti，可以通过 Homebrew 安装：
    
    bashCopy code
    
    `brew install duti`
    
3. **设置新的关联**：安装完成后，使用下面的命令来设置 `vscode:` URL 方案与 VS Code Insiders 的关联。使用之前找到的 Bundle Identifier 替换 `com.microsoft.VSCodeInsiders`：
    
    bashCopy code
    
    `duti -s com.microsoft.VSCodeInsiders vscode`

# `code`
命令行也变成了`code-insiders`，可以设置别名还原。临时作用，长期使用需要自行加入`~/.bashrc`文件。
```bash
alias code=code-insiders 
```