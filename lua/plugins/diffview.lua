-- 定义一个 Git diffview 的前缀快捷键前缀
local prefix_diff_view = "<leader>g"

return {
  -- 指定插件名
  "sindrets/diffview.nvim",

  -- 当使用这些命令时才加载插件，懒加载方式
  cmd = { "DiffviewOpen" },

  -- 定义快捷键映射
  keys = {
    {
      prefix_diff_view .. "d", -- <leader>g + d
      function()
        vim.cmd([[DiffviewOpen]]) -- 打开 Diffview 面板，显示 Git diff
      end,
      desc = "Open Git Diffview", -- 映射描述
    },
    {
      prefix_diff_view .. "t", -- <leader>g + t
      function()
        vim.cmd([[DiffviewFileHistory]]) -- 查看当前分支的提交历史
      end,
      desc = "Open current branch git history",
    },
    {
      prefix_diff_view .. "T", -- <leader>g + T
      function()
        vim.cmd([[DiffviewFileHistory %]]) -- 查看当前文件的提交历史
      end,
      desc = "Open current file git history",
    },
  },

  -- diffview.nvim 的插件配置
  opts = {
    -- 高亮 diff
    enhanced_diff_hl = true,

    -- 窗口视图配置
    view = {
      -- 默认视图
      default = {
        winbar_info = false, -- 不显示 winbar 信息
        disable_diagnostics = true, -- 禁用诊断信息
      },
      -- 文件历史视图
      file_history = {
        winbar_info = false, -- 不显示 winbar 信息
        disable_diagnostics = true, -- 禁用诊断信息
      },
    },

    -- 文件面板配置
    file_panel = {
      win_config = { -- 见 :help diffview-config-win_config
        position = "bottom", -- 面板显示在底部
        height = require("utils").size(vim.o.lines, 0.25), -- 面板高度为窗口行数的 25%
      },
    },

    -- 定义一些进入和离开 diffview 时的钩子函数
    hooks = {
      view_enter = function()
        -- 进入 diffview 时，<leader>gd 会变成“关闭 diffview”
        vim.keymap.set("n", prefix_diff_view .. "d", function()
          vim.cmd([[DiffviewClose]]) -- 关闭 diffview
        end, { desc = "Close Git Diffview", noremap = true, silent = true })
      end,
      view_leave = function()
        -- 离开 diffview 时，<leader>gd 会变成“打开 diffview”
        vim.keymap.set("n", prefix_diff_view .. "d", function()
          vim.cmd([[DiffviewOpen]]) -- 打开 diffview
        end, { desc = "Open Git Diffview", noremap = true, silent = true })
      end,
    },
  },
}
