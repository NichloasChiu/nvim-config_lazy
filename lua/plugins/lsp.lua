-- Neovim 的 LSP（语言服务器协议）配置，主要用来调整诊断信息和内嵌提示（inlay hints）的显示效果
return {
  {
    -- Neovim 官方的 LSP 配置插件，用于配置和管理语言服务器
    "neovim/nvim-lspconfig",

    -- 插件的配置选项
    opts = {
      diagnostics = {
        -- 诊断信息的虚拟文本配置（代码旁边显示的错误/警告文字）
        virtual_text = {
          prefix = "", -- 在虚拟文本前加一个特定符号作为标记，图标更醒目
        },
        update_in_insert = false, -- 插入模式下不更新诊断信息，避免打字时干扰
        underline = true, -- 出错的代码是否加下划线提示
      },
      inlay_hints = {
        enabled = false, -- 关闭内嵌参数提示功能（有些语言支持在代码里显示类型或参数提示）
      },
    },
  },
}
