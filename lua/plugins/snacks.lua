-- 关闭了 snacks.nvim 的默认仪表盘。
--
-- 启用了终端内图片显示功能。
--
-- 配置了两个快捷键：
--
--     <leader>nh 显示图片悬浮预览。
--
--     <leader>nn 打开通知历史。
--
-- 用 which-key 插件给 <leader>n 分组加了工具分类和图标。
--
-- 通过工具函数避免快捷键重复冲突。
--
--
return {
  "snacks.nvim", -- 插件名
  opts = {
    dashboard = { enabled = false }, -- 禁用 snacks 的仪表盘界面
    terminal = {
      win = {
        wo = {
          winbar = "", -- 终端窗口不显示 winbar
        },
      },
    },
    images = {
      enabled = true, -- 启用图片显示功能
    },
    explorer = {
      width = 20, -- 这里生效了！
    },
  },
  keys = function(_, keys)
    -- 向已有的按键映射表插入唯一的新映射，避免重复
    require("utils").list_insert_unique(keys, {
      {
        "<leader>nh", -- 快捷键：leader + nh
        function()
          require("snacks").image.hover() -- 显示图片预览
        end,
        desc = "Show images", -- 映射说明
      },
      {
        "<leader>nn", -- 快捷键：leader + nn
        function()
          Snacks.picker.notifications() -- 打开通知历史列表
        end,
        desc = "Notification History", -- 映射说明
      },
    })

    -- 移除已有的 <leader>n 键，避免冲突
    require("utils").remove_keys(keys, { "<leader>n" })
    return keys -- 返回更新后的键映射表
  end,
  specs = {
    {
      "folke/which-key.nvim", -- which-key 插件，用于显示快捷键提示
      optional = true,
      opts = {
        spec = {
          {
            "<leader>n", -- 以 leader+n 为前缀的快捷键分组
            group = "tools", -- 分组名称
            icon = "", -- 分组图标（特殊字符）
            mode = { "n", "v" }, -- 在普通模式和可视模式下有效
          },
        },
      },
    },
  },
}
