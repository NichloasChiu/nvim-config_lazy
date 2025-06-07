return {
  "mg979/vim-visual-multi", -- 多光标插件
  event = "LazyFile", -- 延迟加载，在打开文件时加载
  config = function()
    -- 禁用默认的快捷键映射，方便自定义
    vim.g["VM_default_mappings"] = 0

    -- 自定义快捷键映射：
    vim.g["Find Under"] = "<C-n>" -- 查找光标下单词（多光标查找）
    vim.g["Find Subword Under"] = "<C-n>" -- 查找光标下子单词（细粒度查找）

    vim.g["Add Cursor Up"] = "<C-S-k>" -- 向上添加光标，Shift + Ctrl + k
    vim.g["Add Cursor Down"] = "<C-S-j>" -- 向下添加光标，Shift + Ctrl + j

    vim.g["Select All"] = "<C-S-n>" -- 选中所有匹配，Shift + Ctrl + n

    vim.g["Skip Region"] = "<C-x>" -- 跳过当前匹配，Ctrl + x
  end,
}
