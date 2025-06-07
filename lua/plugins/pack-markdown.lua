--     lint：用 markdownlint-cli2 进行 Markdown 语法和风格检查，优先使用项目内的 .markdownlint.jsonc 配置文件，否则用系统级配置。
--
--     表格转换：vim-maketable 支持将 CSV 选中内容快速转换成 Markdown 表格，支持交互式设置分隔符。
--
--     图片粘贴：img-clip.nvim 允许从系统剪贴板直接粘贴图片，自动保存到指定目录并插入 Markdown 语法。
--
--     LSP：使用 marksman 语言服务器增强 Markdown 编辑体验。
--
--     快捷键：定义了几个方便的快捷键用于图片粘贴和表格生成。
--
--     预览：通过设置控制 Markdown 预览插件行为。

local utils = require("utils") -- 引入自定义工具模块，包含一些通用函数

-- 定义一个函数，返回 markdownlint-cli2 的命令参数列表（包含配置文件路径）
local function diagnostic()
  -- 系统级配置路径：在 Neovim 配置目录下的 .markdownlint.jsonc
  local system_config = vim.fn.stdpath("config") .. "/.markdownlint.jsonc"
  -- 项目级配置路径：当前工作目录下的 .markdownlint.jsonc
  local project_config = vim.fn.getcwd() .. "/.markdownlint.jsonc"

  -- 引用 lint 插件中的 markdownlint-cli2 规则
  local markdownlint = require("lint").linters["markdownlint-cli2"]

  -- 如果参数列表中没有 --config 参数，则清空参数并加上 --config
  if not utils.contains_arg(markdownlint.args or {}, "--config") then
    markdownlint.args = {}
    table.insert(markdownlint.args, "--config")
  end

  -- 优先使用项目目录下的配置文件
  if vim.fn.filereadable(project_config) == 1 then
    if not utils.contains_arg(markdownlint.args, project_config) then
      table.insert(markdownlint.args, project_config)
    end
  else
    -- 否则使用系统配置文件
    if not utils.contains_arg(markdownlint.args, system_config) then
      table.insert(markdownlint.args, system_config)
    end
  end

  return markdownlint.args -- 返回参数列表
end

-- 用于交互式改变 Markdown 表格分隔符的函数
local markdown_table_change = function()
  vim.ui.input({ prompt = "Separate Char: " }, function(input)
    if not input or #input == 0 then
      return
    end
    -- 运行可视模式选中行的 MakeTable 命令，参数为输入的分隔符
    local execute_command = ([[:'<,'>MakeTable! ]] .. input)
    vim.cmd(execute_command)
  end)
end

-- 设置 Markdown Preview 插件参数
vim.g.mkdp_auto_close = 0 -- 预览窗口关闭时不自动关闭
vim.g.mkdp_combine_preview = 1 -- 合并预览窗口

return {
  recommended = function()
    -- 只在编辑 markdown 和 markdown.mdx 文件，且项目根目录有 README.md 时启用
    return LazyVim.extras.wants({
      ft = { "markdown", "markdown.mdx" },
      root = "README.md",
    })
  end,

  -- 导入 LazyVim 内置的 Markdown 支持配置
  { import = "lazyvim.plugins.extras.lang.markdown" },

  -- vim-maketable 插件，支持快速把 CSV 文本转换成 Markdown 表格
  {
    "mattn/vim-maketable",
    cmd = "MakeTable", -- 仅在调用 MakeTable 命令时加载
    ft = { "markdown", "markdown.mdx" }, -- 仅在 markdown 文件中加载
  },

  -- img-clip.nvim 插件，支持从剪贴板粘贴图片到 markdown 并生成图片链接
  {
    "HakonHarnes/img-clip.nvim",
    cmd = { "PasteImage", "ImgClipDebug", "ImgClipConfig" }, -- 相关命令触发加载
    opts = {
      default = {
        prompt_for_file_name = false, -- 不提示输入图片文件名，自动生成
        embed_image_as_base64 = false, -- 不用 base64 嵌入图片
        drag_and_drop = {
          enabled = true, -- 支持拖放图片
          insert_mode = true, -- 在插入模式支持拖放
        },
        use_absolute_path = vim.fn.has("win32") == 1, -- Windows 下使用绝对路径
        relative_to_current_file = true, -- 使用相对当前文件路径
        show_dir_path_in_prompt = true, -- 提示时显示路径
        dir_path = "assets/imgs/", -- 图片存放目录
      },
    },
  },

  -- LSP 配置，启用 marksman（Markdown 语言服务器）
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        marksman = {
          on_attach = function()
            -- 绑定快捷键：<leader>cP 触发图片粘贴
            vim.keymap.set(
              "n",
              "<leader>cP",
              "<cmd>PasteImage<cr>",
              { desc = "Paste image from system clipboard", noremap = true, silent = true, buffer = true }
            )
            -- 绑定快捷键：<leader>ct 使用默认分隔符（tab）将选中 CSV 转成表格
            vim.keymap.set(
              "n",
              "<leader>ct",
              [[:'<,'>MakeTable! \t<CR>]],
              { desc = "Markdown csv to table(Default:\\t)", noremap = true, silent = true, buffer = true }
            )
            -- 绑定快捷键：<leader>cT 交互式指定分隔符转表格
            vim.keymap.set(
              "n",
              "<leader>cT",
              markdown_table_change,
              { desc = "Markdown csv to table with separate char", noremap = true, silent = true, buffer = true }
            )
          end,
        },
      },
    },
  },

  -- markdownlint-cli2 作为 lint 工具集成，用于检查 Markdown 格式
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters = {
        ["markdownlint-cli2"] = {
          args = diagnostic(), -- 通过前面定义的 diagnostic() 函数获取命令行参数
        },
      },
      linters_by_ft = {
        markdown = { "markdownlint-cli2" }, -- 仅对 markdown 文件启用该 linter
      },
    },
  },
}
