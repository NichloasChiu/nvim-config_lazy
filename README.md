# LazyNvim 私有配置

这是我个人的 LazyNvim 配置仓库，基于 LazyNvim 框架，定制化我的 Neovim 开发环境和插件设置。

---

## 目录

- [简介](#简介)
- [安装](#安装)
- [主要插件](#主要插件)
- [配置结构](#配置结构)
- [自定义](#自定义)
- [更新](#更新)
- [常见问题](#常见问题)
- [联系](#联系)

---

## 简介

本仓库包含我个人的 Neovim 配置，使用 LazyNvim 作为配置管理器，方便快捷地管理插件和功能。  
配置支持自动安装插件、语言服务器、调试等常用功能。

---

## 安装

1. 克隆本仓库到本地（假设你已经安装了 Neovim）：

```bash
git clone git@github.com:NichloasChiu/nvim-config_lazy.git ~/.config/nvim

```

2. 打开 Neovim，LazyNvim 会自动安装并同步插件。

3. 你也可以运行命令手动同步插件：

```vim
:Lazy sync
```

## 主要插件

- `lazy.nvim` — 插件管理器

- `telescope.nvim` — 模糊查找

- `nvim-treesitter` — 代码高亮和解析

- `lualine.nvim` — 状态栏

- `markdown-preview.nvim` — Markdown 实时预览

- `snacks.nvim` — 快速文件浏览

（可根据你的实际情况替换或补充）

## 配置结构

- `lua/plugins/` — 插件列表和配置

- `lua/config/` — 具体插件配置和全局设置

- `lua/keymaps.lua` — 快捷键映射

- `init.lua` — Neovim 入口配置文件

## 自定义

- 你可以在 `lua/config/ `下添加或修改配置文件，根据个人喜好定制 Neovim 功能。
- 快捷键在 `lua/keymaps.lua` 里统一管理。

## 更新

更新配置时，拉取最新代码后执行：

```vim
:Lazy sync
```

或者重启 Neovim，插件和配置会自动更新。

## 常见问题

- 插件没安装？ 确认网络通畅，执行 `:Lazy sync` 重试。

- 配置不生效？ 检查配置文件语法，确认文件路径正确。

- 如何添加新插件？ 在 `lua/plugins/` 添加插件配置，然后执行 `:Lazy sync`。

## 联系

如果有问题或建议，欢迎联系我：

> GitHub: [https://github.com/NichloasChiu]

> 邮箱: NichloasChiu@outlook.com
