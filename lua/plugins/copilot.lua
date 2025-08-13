-- Copilot configuration for Neovim
return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  event = "InsertEnter",
  opts = {
    suggestion = {
      enabled = true,
      auto_trigger = true, -- 自动触发建议
      keymap = {
        accept = "<C-j>", -- 接受整个建议
        accept_word = "<C-n>", -- 接受下一个单词
        accept_line = "<C-l>", -- 接受整行
        next = "<M-]>", -- 下一个建议
        prev = "<M-[>", -- 上一个建议
        dismiss = "<C-]>", -- 关闭当前建议
      },
    },
    panel = { enabled = false },
  },
}
