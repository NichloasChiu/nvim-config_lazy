-- 插件介绍 — live-server.nvim
--
-- 这是一个 Neovim 插件，封装了一个基于 Node.js 的 live-server 工具。
-- live-server 是一个轻量的开发服务器，能自动刷新浏览器页面，
-- 非常适合前端开发调试 HTML、CSS、JS 文件。
--
-- 这个插件让你直接在 Neovim 中启动和停止 live-server，
-- 不需要切换命令行，提升工作效率。
--
-- 定义一个快捷键前缀变量，方便后面快捷键定义
local prefix = "<leader>c"

return {
  -- 插件仓库地址，live-server.nvim 用于启动一个实时刷新服务器，方便调试 HTML
  "barrett-ruth/live-server.nvim",

  -- 只在打开 HTML 文件时加载该插件，实现按需加载
  ft = { "html" },

  -- 插件安装后执行的构建命令，安装全局 npm 包 live-server
  build = "npm install -g live-server",

  -- 指定可用命令，方便用户手动调用启动和停止 live server
  cmd = { "LiveServerStart", "LiveServerStop" },

  -- 插件配置，这里没有传入额外配置，使用默认即可
  opts = {},

  -- 键盘快捷键绑定表
  keys = {
    {
      -- 快捷键 <leader>cw，用于启动 live server
      prefix .. "w",
      function()
        -- 调用 Neovim 命令启动 live server
        vim.cmd([[LiveServerStart]])
      end,
      desc = "Start live server", -- 绑定描述，方便查看和提示
    },
    {
      -- 快捷键 <leader>cW，用于停止 live server
      prefix .. "W",
      function()
        -- 调用 Neovim 命令停止 live server
        vim.cmd([[LiveServerStop]])
      end,
      desc = "Stop live server",
    },
  },
}
