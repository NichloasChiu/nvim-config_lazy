-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
local keymap = vim.keymap
-- 正常模式（n）下：
-- 按 H 光标移动到行首第一个非空字符（相当于按 ^）
-- 按 L 光标移动到行尾（相当于按 $）
keymap.set("n", "H", "^", { desc = "Go to start without blank" })
keymap.set("n", "L", "$", { desc = "Go to end without blank" })

-- 可视模式（v）下
-- 按 K 把选中行块上移一行
-- 按 J 把选中行块下移一行
keymap.set("v", "K", ":move '<-2<CR>gv-gv", { desc = "Move line up", noremap = true, silent = true })
keymap.set("v", "J", ":move '>+1<CR>gv-gv", { desc = "Move line down", noremap = true, silent = true })

-- 正常模式中重定义了搜索命令 n 和 N,默认搜索行为做了增强
keymap.set("n", "n", require("utils").better_search("n"), { desc = "Next Search", noremap = true, silent = true })
keymap.set("n", "N", require("utils").better_search("N"), { desc = "Previous Search", noremap = true, silent = true })

--重新绑定了 n 和 N：搜索到下一个或上一个匹配后，光标行会自动居中 (zz)
keymap.set("n", "n", "nzz", { noremap = true, silent = true })
keymap.set("n", "N", "Nzz", { noremap = true, silent = true })

-- 正常模式下，按 x 删除当前字符，但不会复制到剪贴板（使用黑洞寄存器 "_），防止覆盖粘贴缓冲区。
keymap.set("n", "x", '"_x', { noremap = true, silent = true })

-- 绑定 <leader>/ 触发 LazyVim 内置的 live_grep 功能，在当前工作目录执行模糊搜索
keymap.set("n", "<leader>/", LazyVim.pick("live_grep", { root = false }), { desc = "Grep (cwd)" })

-- LazyVim 检测到 mini.pairs 插件（用于自动补全括号、引号等）存在，
-- 就给插入模式定义几个快捷键：

-- <C-h>、<C-w>、<C-u> 会调用 MiniPairs.bs() 函数，实现更智能的删除行为（比如成对删除括号）
if LazyVim.has("mini.pairs") then
  -- for mini.pairs
  local map_bs = function(lhs, rhs)
    keymap.set("i", lhs, rhs, { expr = true, replace_keycodes = false })
  end
  map_bs("<C-h>", "v:lua.MiniPairs.bs()")
  map_bs("<C-w>", 'v:lua.MiniPairs.bs("\23")')
  map_bs("<C-u>", 'v:lua.MiniPairs.bs("\21")')
end

--  正常模式下，gl 打开当前行的诊断信息弹窗（如 LSP 报错或警告）
keymap.set("n", "gl", vim.diagnostic.open_float, { desc = "Line Diagnostics" })

--  插入模式下jk退出插入模式
keymap.set("i", "jk", "<Esc>", { noremap = true, silent = true, desc = "Exit insert mode with jk" })
