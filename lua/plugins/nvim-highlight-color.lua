-- 插件介绍：brenoprata10/nvim-highlight-colors
--
--     brenoprata10/nvim-highlight-colors 是一个用于 Neovim 的插件，功能是高亮显示代码中出现的颜色值，例如：
--
--         #ff0000（十六进制色值）
--
--         red（命名色值）
--
--         rgb(255, 0, 0)（RGB 颜色）
--
--     它能直接在编辑器中以实际颜色或符号方式高亮显示这些色值，特别适合写 CSS、Tailwind、前端样式文件时使用。
--
return {
  "brenoprata10/nvim-highlight-colors", -- 引入 nvim-highlight-colors 插件
  event = { "LazyFile", "InsertEnter" }, -- 触发条件：懒加载（文件打开或进入插入模式时加载）
  cmd = "HighlightColors", -- 也可通过 :HighlightColors 命令手动启用
  opts = {
    virtual_symbol = "󱓻", -- 用于显示的符号（实际显示效果：小方块）
    virtual_symbol_suffix = " ", -- 符号后面加一个空格
    enabled_named_colors = false, -- 禁用命名色值（如 red, blue）
    render = "virtual", -- 以虚拟文本的形式渲染（不影响代码本身）
    virtual_symbol_position = "inline", -- 虚拟符号显示在行内（不在行首或行末）
    enable_tailwind = false, -- 不启用 Tailwind CSS 颜色支持
    enable_short_hex = false, -- 不启用短 hex（如 #fff）
    enable_named_colors = false, -- 不启用命名颜色
    enable_hex = false, -- 不启用十六进制颜色（#RRGGBB）高亮
  },
}
