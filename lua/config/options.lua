-- 选项会在懒惰之前自动加载。nvim启动
-- 始终设置的默认选项：https：//github.com/lazyvim/lazyvim/blob/main/main/lua/lazyvim/config/options.lua
-- 在此处添加所有其他选项
--

-- 在换行符前显示 ↪ 符号（用于 wrap 模式）
vim.opt.showbreak = "↪ "
-- 默认禁用自动换行（:set nowrap）
vim.opt.wrap = false
-- 设置 LazyVim 的默认文件选择器为 fzf（替代 telescope）
vim.g.lazyvim_picker = "fzf"
-- 设置 LazyVim 的补全引擎为 blink.cmp（可能是自定义补全插件）
vim.g.lazyvim_cmp = "blink.cmp"
-- 禁用 AI 补全（如 Copilot 或 Codeium）
vim.g.ai_cmp = false
-- 禁用 LazyVim 的插件加载顺序检查（优化性能）
vim.g.lazyvim_check_order = false
-- 禁用自动格式化（如保存时自动格式化）
-- vim.g.autoformat = false

LazyVim.on_very_lazy(function()
  vim.filetype.add({
    extension = {
      mdx = "markdown.mdx", -- `.mdx` 识别为 `markdown.mdx`
      qmd = "markdown", -- `.qmd` 识别为 `markdown`
      yml = require("utils").yaml_ft, -- `.yml` 使用 `utils` 模块动态判断
      yaml = require("utils").yaml_ft, -- `.yaml` 同上
      json = "jsonc", -- `.json` 识别为 `jsonc`（带注释的 JSON）
      MD = "markdown", -- `.MD` 识别为 `markdown`
      tpl = "gotmpl", -- `.tpl` 识别为 `gotmpl`（Go 模板）
    },
    filename = {
      [".eslintrc.json"] = "jsonc", -- `eslintrc.json` 识别为 `jsonc`
      ["vimrc"] = "vim", -- `vimrc` 识别为 `vim`
    },
    pattern = {
      ["/tmp/neomutt.*"] = "markdown", -- `/tmp/neomutt` 开头的文件识别为 `markdown`
      ["tsconfig*.json"] = "jsonc", -- `tsconfig.json` 及其变体识别为 `jsonc`
      [".*/%.vscode/.*%.json"] = "jsonc", -- `.vscode/*.json` 识别为 `jsonc`
      [".*/waybar/config"] = "jsonc", -- `waybar/config` 识别为 `jsonc`
    },
  })
end)

-- 是主题透明
-- vim.cmd([[
--   highlight Normal guibg=NONE ctermbg=NONE
--   highlight NormalNC guibg=NONE ctermbg=NONE
--   highlight NormalFloat guibg=NONE ctermbg=NONE
-- ]])
