-- 插件介绍 — git-blame.nvim
--
-- git-blame.nvim 是一个 Neovim 插件，用于在编辑器里显示当前光标所在行对应的 Git 提交信息
-- （即“Git Blame”信息）。它可以显示谁在什么时候提交了这一行代码，提交的简短信息，
-- 以及对应的提交哈希（SHA）。插件通过虚拟文本（virtual text）或者状态栏等方式
-- 把这些信息展示出来，方便你了解代码的历史和作者。
--
-- 插件还支持一些实用功能，比如打开或复制对应的提交链接（如果远程仓库是 GitHub、GitLab 等），快速查看代码变更来源，提升代码审查和调试效率
return {
  -- 插件仓库地址，指定要安装和使用的插件
  "f-person/git-blame.nvim",

  -- 触发插件加载的事件，这里是 "LazyFile"，表示当打开文件时延迟加载插件
  event = "LazyFile",

  -- 通过命令触发插件加载的命令列表
  cmd = {
    "GitBlameToggle", -- 切换显示/隐藏 Git Blame 信息
    "GitBlameEnable", -- 启用 Git Blame
    "GitBlameOpenCommitURL", -- 打开当前行对应提交的网页 URL
    "GitBlameCopyCommitURL", -- 复制当前行对应提交的网页 URL
    "GitBlameOpenFileURL", -- 打开当前文件在远程仓库的网页 URL
    "GitBlameCopyFileURL", -- 复制当前文件在远程仓库的网页 URL
    "GitBlameCopySHA", -- 复制当前行对应提交的 SHA（提交哈希）
  },

  -- 插件参数配置表
  opts = {
    enabled = true, -- 默认启用 git-blame 功能
    date_format = "%r", -- 日期格式，使用 strftime 格式化字符串（%r 表示 12 小时制时间）
    -- 显示在状态栏或虚拟文本上的信息模板，包含作者、日期、提交摘要、提交 SHA
    message_template = "  <author> 󰔠 <date> 󰈚 <summary>  <sha>",
    -- 当当前行没有对应提交时显示的消息
    message_when_not_committed = "  Not Committed Yet",
  },
}
