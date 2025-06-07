-- 插件介绍：kylechui/nvim-surround
--
--     kylechui/nvim-surround 是一个 Neovim 插件，用于更方便地操作“包裹字符”：
--
--         比如快速添加、修改、删除括号、引号、HTML 标签等包裹字符。
--
--         类似于 vim-surround，但专门为 Neovim 设计，支持更现代的 Lua API。
--
return {
  "kylechui/nvim-surround", -- 引入 nvim-surround 插件
  version = "*", -- 使用任意版本号以保证稳定性（也可删除该行，使用最新版）
  event = "VeryLazy", -- 懒加载，延迟加载以加快启动速度
  opts = {
    keymaps = {
      insert = false, -- 插入模式下不启用 surround 快捷键
      insert_line = false, -- 行插入模式下不启用 surround 快捷键
      visual = "gs", -- 视觉模式下使用 "gs" 快捷键进行 surround 操作
    },
  },
}
