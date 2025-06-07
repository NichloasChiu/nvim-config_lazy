-- ~/.config/nvim/lua/plugins/which-key.lua
return {
  {
    "folke/which-key.nvim", -- 插件名称：which-key.nvim，用于显示键盘快捷键提示
    config = function()
      local wk = require("which-key")
      -- 配置 which-key 插件
      wk.setup({
        win = {
          border = "single", -- 窗口边框样式，"single" 表示单线边框
          padding = { 1, 2 }, -- 窗口内容与边框的内边距，分别是上下和左右的空白宽度
          title = true, -- 是否显示窗口标题
          title_pos = "center", -- 标题的位置，"center" 表示居中显示
          zindex = 1000, -- 窗口的层级，数值越大窗口显示越靠前
          no_overlap = true, -- 是否避免与其他浮动窗口重叠
          row = math.huge, -- 窗口在屏幕中的默认行位置，math.huge表示默认自动计算或靠下
          col = 0, -- 窗口在屏幕中的默认列位置，从左侧第0列开始
        },
        layout = {
          width = { min = 20, max = 80 }, -- 窗口宽度的最小和最大限制（字符数）
          height = { min = 1, max = 5 }, -- 窗口高度的最小和最大限制（行数）
          spacing = 3, -- 各行之间的间距
          align = "left", -- 内容对齐方式，左对齐
        },
        show_help = false, -- 是否显示帮助信息，false表示不显示
        show_keys = true, -- 是否显示按键名称，true表示显示
        spec = {
          {
            mode = { "n", "v" },
            -- === 你的自定义映射 ===
            { "<leader>a", group = "󰍉 User" },
            { "<leader>ae", cmd = "<cmd>e ++enc=cp936<cr>", desc = "Sql乱码修正" },
            {
              "<leader>am",
              cmd = "<cmd>MarkdownPreviewStop<cr> | <cmd>MarkdownPreview<cr>",
              desc = "MarkDown预览",
            },
            { "<leader>at", cmd = "<cmd>TableModeToggle<cr>", desc = "MarkDown表模式" },
            {
              "<leader>as",
              function()
                -- 使用 expand() 解析 ~
                local dir = vim.fn.expand("~/WorkingDocument/NichloasChiu-Note/")
                vim.cmd("cd " .. dir)
                -- Snacks explorer：
                require("snacks").explorer()
              end,
              desc = "Move Note",
            },
            {
              "<leader>aw",
              function()
                local dir = vim.fn.expand("~/WorkingDocument/")
                vim.cmd("cd " .. dir)
                -- Snacks explorer：
                require("snacks").explorer()
              end,
              desc = "Move WorkingDocument",
            },
            {
              "<leader>an",
              function()
                local dir = vim.fn.expand("~/.config/nvim/")
                vim.cmd("cd " .. dir)
                require("snacks").explorer()
              end,
              desc = "Move Nvim Configuration",
            },

            { "<leader><tab>", group = "tabs" },
            { "<leader>c", group = "code" },
            { "<leader>d", group = "debug" },
            { "<leader>dp", group = "profiler" },
            { "<leader>f", group = "file/find" },
            { "<leader>g", group = "git" },
            { "<leader>gh", group = "hunks" },
            { "<leader>q", group = "quit/session" },
            { "<leader>s", group = "search" },
            { "<leader>u", group = "ui", icon = { icon = "󰙵 ", color = "cyan" } },
            { "<leader>a", group = "user", icon = { icon = "󰙵 ", color = "cyan" } },
            { "<leader>x", group = "diagnostics/quickfix", icon = { icon = "󱖫 ", color = "green" } },
            { "[", group = "prev" },
            { "]", group = "next" },
            { "g", group = "goto" },
            { "gs", group = "surround" },
            { "z", group = "fold" },
            {
              "<leader>b",
              group = "buffer",
              expand = function()
                return require("which-key.extras").expand.buf()
              end,
            },
            {
              "<leader>w",
              group = "windows",
              proxy = "<c-w>",
              expand = function()
                return require("which-key.extras").expand.win()
              end,
            },
            -- better descriptions
            { "gx", desc = "Open with system app" },
          },
        },
      })
    end,
  },
}
