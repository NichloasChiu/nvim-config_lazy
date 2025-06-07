-- 条件加载：只有当打开 .css、.html 文件或者项目里有相关文件时才加载，避免无谓开销。
--
-- Treesitter：
--
--     安装并启用 html、css、scss 语法解析。
--
--     将 less、postcss 也注册为 scss，方便共享语法树。
--
-- Mason：自动安装三个语言服务器，分别负责 HTML、CSS 及 CSS Modules 支持。
--
-- mini.icons：为 postcss 文件提供漂亮图标。
--
-- LSP 配置：
--
--     禁用 HTML 和 CSS 语言服务器的格式化功能（方便用别的格式化工具接管）。
--
--     对 CSS、LESS、SCSS 的 lint 规则中忽略未知的 CSS At-Rules（比如自定义的 Tailwind 或其他框架指令），避免误报。
--
--     关闭 SCSS 的验证（validate = false），可能避免一些误报或冲突。
--
return {
  recommended = function()
    -- 只有文件类型是 css 或 html，且项目根目录有相关文件时启用本模块
    return LazyVim.extras.wants({
      ft = { "css", "html" },
      root = { "*.html", "*.css", "*.less", "*.scss" },
    })
  end,

  -- Treesitter 配置
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = function(_, opts)
      if opts.ensure_installed ~= "all" then
        -- 确保 html、css、scss 语法解析器被安装
        opts.ensure_installed = require("utils").list_insert_unique(opts.ensure_installed, { "html", "css", "scss" })
      end
      -- 将 less 和 postcss 语言注册为 scss（方便共用语法解析）
      vim.treesitter.language.register("scss", "less")
      vim.treesitter.language.register("scss", "postcss")
    end,
  },

  -- Mason 插件，自动安装相关 LSP 及工具
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = { "html-lsp", "cssmodules-language-server", "css-lsp" },
      -- 自动安装三个语言服务器：
      -- html-lsp: HTML 语言服务器
      -- cssmodules-language-server: 支持 CSS Modules
      -- css-lsp: CSS 语言服务器
    },
  },

  -- mini.icons 插件，为特定文件类型提供图标
  {
    "echasnovski/mini.icons",
    optional = true,
    opts = {
      filetype = {
        postcss = { glyph = "󰌜", hl = "MiniIconsOrange" },
        -- 为 postcss 文件类型设置专属图标和颜色
      },
    },
  },

  -- LSP 配置
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        html = { init_options = { provideFormatter = false } },
        -- 禁用 html-lsp 自带的格式化（用其他工具格式化）

        cssls = {
          init_options = { provideFormatter = false },
          settings = {
            css = {
              lint = {
                unknownAtRules = "ignore", -- 忽略未知的 At-Rules
              },
            },
            less = {
              lint = {
                unknownAtRules = "ignore",
              },
            },
            scss = {
              validate = false, -- 关闭 scss 的验证
              lint = {
                unknownAtRules = "ignore",
              },
            },
          },
        },
      },
    },
  },
}
