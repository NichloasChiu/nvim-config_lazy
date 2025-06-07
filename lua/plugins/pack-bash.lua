return {
  recommended = function()
    -- 只有在打开的文件类型是 "sh"（Shell 文件）时，才加载这个模块
    return LazyVim.extras.wants({
      ft = { "sh" },
    })
  end,

  -- mason.nvim：自动安装和管理 LSP / DAP / Formatter / Linter 等工具
  {
    "williamboman/mason.nvim",
    optional = true, -- 可选加载
    opts = { ensure_installed = { "bash-language-server", "shfmt", "shellcheck" } },
    -- 自动安装 bash 相关的工具：
    -- - bash-language-server: 提供 Bash 的 LSP 支持
    -- - shfmt: Bash 文件格式化工具
    -- - shellcheck: Bash 语法和潜在问题检查
  },

  -- treesitter：高亮、语法解析、文本对象等
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = function(_, opts)
      if opts.ensure_installed ~= "all" then
        -- 确保 Bash 语法高亮也被安装
        opts.ensure_installed = require("utils").list_insert_unique(opts.ensure_installed, { "bash" })
      end
    end,
  },

  -- LSP 服务器配置：neovim/nvim-lspconfig
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        bashls = {}, -- 配置 Bash 的 LSP：bash-language-server
      },
    },
  },

  -- conform.nvim：代码格式化工具集成
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        sh = { "shfmt" }, -- 指定 sh 文件用 shfmt 格式化
      },
    },
  },
}
