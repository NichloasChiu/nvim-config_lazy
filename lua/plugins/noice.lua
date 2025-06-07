-- 插件介绍：folke/noice.nvim
--
--     folke/noice.nvim 是一个专为 Neovim 设计的增强型用户界面插件，旨在美化和改善通知、命令行、消息和 LSP 界面等交互体验。
--
--     功能包括：漂亮的 LSP 文档弹窗、改进的命令行、通知样式的消息弹窗等。
--
return {
  "folke/noice.nvim", -- 引入 noice.nvim 插件
  opts = {
    presets = {
      bottom_search = false, -- 搜索命令行不放到底部，使用 noice.nvim 的样式
      command_palette = false, -- 不使用居中命令面板样式
      long_message_to_split = true, -- 将过长的消息放入一个新的分屏中
      inc_rename = false, -- 不启用 inc-rename.nvim 的重命名输入框支持
      lsp_doc_border = true, -- 给 LSP hover 文档和签名提示添加边框
    },
    lsp = {
      signature = {
        enabled = false, -- 禁用 noice.nvim 的 LSP 签名提示
      },
    },
    routes = {
      {
        filter = {
          event = "notify", -- 监听的事件：notify 通知消息
          find = "No information available", -- 匹配包含 "No information available" 的消息
        },
        opts = { skip = true }, -- 直接跳过这些消息，不显示
      },
    },
  },
}
