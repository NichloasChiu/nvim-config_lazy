-- 返回插件配置表
return {
  -- 插件名称（GitHub 仓库地址格式）
  "akinsho/bufferline.nvim",

  -- 插件配置选项
  opts = {
    -- 插件的全局选项设置
    options = {
      -- 始终显示标签栏（即使只有一个 buffer 也显示）
      always_show_bufferline = true,

      -- 其他可用但未在此示例中设置的常见选项示例：
      -- mode = "buffers",  -- 可选 "tabs" 或 "buffers" 模式
      -- numbers = "ordinal",  -- 显示缓冲区编号
      -- close_command = "bdelete! %d",  -- 关闭命令
      -- separator_style = "slant",  -- 分隔线样式
      -- diagnostics = "nvim_lsp",  -- 显示 LSP 诊断标记
      -- offsets = {
      --   {filetype = "NvimTree", text = "File Explorer"}
      -- }
    },
  },

  -- 其他可用但未在此示例中设置的配置示例：
  -- event = "BufAdd",  -- 触发加载的事件
  -- dependencies = { "nvim-tree/nvim-web-devicons" },  -- 依赖的图标插件
  -- version = "*",  -- 版本要求
  -- config = function() ... end  -- 更复杂的配置函数
}
