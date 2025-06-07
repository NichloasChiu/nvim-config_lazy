-- 自动启用 TailwindCSS LSP，只要项目根目录含有 Tailwind 或 PostCSS 配置文件。
--
-- 配置 LSP 识别多种自定义 CSS 类函数，如 cva, cx, tw, clsx，这样在这些函数中写类名也能获得智能提示。
--
-- 允许过滤和扩展 Tailwind LSP 支持的文件类型。
--
-- 特殊支持 Elixir 模板文件识别为 HTML，方便在 Elixir 项目中使用 Tailwind。
--
-- 引入 LazyVim 自带的 Tailwind 插件配置，简化整体配置。

return {
  -- recommended 字段定义了该配置是否推荐启用，基于项目根目录是否存在 Tailwind 或 PostCSS 配置文件来判断
  recommended = function()
    return LazyVim.extras.wants({
      root = {
        "tailwind.config.js",
        "tailwind.config.cjs",
        "tailwind.config.mjs",
        "tailwind.config.ts",
        "postcss.config.js",
        "postcss.config.cjs",
        "postcss.config.mjs",
        "postcss.config.ts",
      },
    })
  end,

  -- 引入 LazyVim 自带的 Tailwind 语言插件配置
  { import = "lazyvim.plugins.extras.lang.tailwind" },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        tailwindcss = {
          -- Tailwind CSS LSP 服务器的设置
          settings = {
            tailwindCSS = {
              -- 这里定义了一些常见的 CSS 类函数名，LSP 会识别这些函数中的类名进行智能提示
              classFunctions = {
                "cva", -- class-variance-authority 库中常用的函数
                "cx", -- classnames 库的函数
                "tw", -- twin.macro 库的函数
                "clsx", -- clsx 库的函数
              },
            },
          },
        },
      },

      -- 自定义 LSP 配置的 setup 函数，扩展或过滤默认 filetypes 以及增加文件类型支持
      setup = {
        tailwindcss = function(_, opts)
          -- 获取 LazyVim 内置的 tailwindcss LSP 默认配置
          local tw = LazyVim.lsp.get_raw_config("tailwindcss")

          -- 如果没有配置文件类型，则初始化为空表
          opts.filetypes = opts.filetypes or {}

          -- 过滤掉 opts.filetypes_exclude 中指定的文件类型（如果有）
          --- @param ft string
          opts.filetypes = vim.tbl_filter(function(ft)
            return not vim.tbl_contains(opts.filetypes_exclude or {}, ft)
          end, opts.filetypes)

          -- 深度合并自定义设置，包括让 LSP 识别 Elixir 相关的模板语言文件为 HTML 类型
          opts.settings = vim.tbl_deep_extend("force", opts.settings, {
            tailwindCSS = {
              includeLanguages = {
                elixir = "html-eex",
                eelixir = "html-eex",
                heex = "html-eex",
              },
            },
          })

          -- 添加额外包含的文件类型（如果 opts.filetypes_include 有定义）
          vim.list_extend(opts.filetypes, opts.filetypes_include or {})
        end,
      },
    },
  },
}
