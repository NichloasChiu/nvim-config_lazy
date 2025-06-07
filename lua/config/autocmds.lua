--  AutoCMD会自动加载在非常懒惰的事件中
-- 始终设置的默认autocmds：https：//github.com/lazyvim/lazyvim/blob/main/main/lua/lazyvim/config/autocmds.lua
--
-- 在此处添加任何其他AutoCMD
-- 使用`vim.api.nvim_create_autocmd`
--
-- 或通过其组名称删除现有的AutoCMD（默认值以lazyvim_`为前缀）
-- 例如vim.api.nvim_del_augroup_by_name（“ lazyvim_wrap_spell”）

-- 离开插入模式时关闭粘贴模式
--
local utils = require("utils")

vim.api.nvim_create_autocmd("InsertLeave", {
  pattern = "*",
  command = "set nopaste",
})

if utils.is_available("venv-selector.nvim") then
  vim.api.nvim_create_autocmd("VimEnter", {
    desc = "Auto select virtualenv Nvim open",
    pattern = "*",
    callback = function()
      local venv = vim.fn.findfile("pyproject.toml", vim.fn.getcwd() .. ";")
      if venv ~= "" then
        require("venv-selector").retrieve_from_cache()
      end
    end,
    once = true,
  })
end

-- 自动追踪上个文件  重新会话
-- if is_available "resession.nvim" then
--   local resession = require "resession"
--
--   vim.api.nvim_create_autocmd("VimEnter", {
--     desc = "Restore session on open",
--     group = augroup("resession_auto_open", { clear = true }),
--     callback = function()
--       -- Only load the session if nvim was started with no args
--       if vim.fn.argc(-1) == 0 then
--         -- Save these to a different directory, so our manual sessions don't get polluted
--         resession.load(vim.fn.getcwd(), { dir = "dirsession", silence_errors = true })
--       end
--     end,
--   })
-- end
--
-- 自动添加头批注
vim.cmd([[
autocmd BufNewFile *.cpp,*.[ch],*.sh,*.java,*.go exec ":call SetTitle()"
"""定义函数SetTitle，自动插入文件头
func SetTitle()
    "如果文件类型为.sh文件
    if &filetype == 'sh'
        call setline(1,"\#!/bin/bash")
        call append(line("."),"\###########################################################################################################")
        call append(line(".")+1,   "\# File Name:    ".expand("%"))
        call append(line(".")+2, "\# Author:       NichloasChiu")
        call append(line(".")+3, "\# mail:         NichloasChiu@outlook.com")
        call append(line(".")+4, "\# Created Time: ".strftime("%c"))
        call append(line(".")+5, "\##########################################################################################################")
        call append(line(".")+6, "")
    else
        call setline(1, "/* ************************************************************************")
        call append(line("."),   "> File Name:     ".expand("%"))
        call append(line(".")+1, "> Author:        NichloasChiu")
        call append(line(".")+2, "> mail:          NichloasChiu@outlook.com")
        call append(line(".")+3, "> Created Time:  ".strftime("%c"))
        call append(line(".")+4, "> Description:   ")
        call append(line(".")+5, " ************************************************************************/")
        call append(line(".")+6, "")
    endif
    "新建文件后，自动定位到文件末尾
    autocmd BufNewFile * normal G
endfunc
]])

vim.cmd([[
autocmd BufNewFile *.h,*.hpp exec ":call AddHHeader()"
func AddHHeader()
    let macro = "_".toupper(substitute(expand("%"), "[/.]", "_", "g"))."_"
    "normal o
    call setline(9, "#ifndef ".macro)
    call setline(10, "#define ".macro)
    call setline(11, "")
    call setline(12, "#endif  // ".macro)
endfunc
]])

-- 保存指针位置
vim.cmd([[
  if has("autocmd")
  autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \ exe "normal g'\"" |
  \ endif
  endif
]])

-- 保存自动格式化
vim.cmd([[autocmd BufWritePre <buffer> lua vim.lsp.buf.format()]])

-- 自动切换输入法
vim.api.nvim_create_autocmd({ "InsertLeave" }, {
  pattern = { "*" },
  callback = function()
    local input_status = tonumber(vim.fn.system("fcitx5-remote"))
    if input_status == 2 then
      vim.fn.system("fcitx5-remote -c")
    end
  end,
})

-- Neovim 的自动命令（autocmd）配置，主要功能是让 q 键可以快速关闭帮助窗口、手册页、quickfix 窗口和 DAP 浮动窗口等特殊窗口

vim.api.nvim_create_autocmd("BufWinEnter", {
  desc = "Make q close help, man, quickfix, dap floats",
  callback = function(args)
    -- Add cache for buffers that have already had mappings created
    if not vim.g.q_close_windows then
      vim.g.q_close_windows = {}
    end
    -- If the buffer has been checked already, skip
    if vim.g.q_close_windows[args.buf] then
      return
    end
    -- Mark the buffer as checked
    vim.g.q_close_windows[args.buf] = true
    -- Check to see if `q` is already mapped to the buffer (avoids overwriting)
    for _, map in ipairs(vim.api.nvim_buf_get_keymap(args.buf, "n")) do
      if map.lhs == "q" then
        return
      end
    end
    -- If there is no q mapping already and the buftype is a non-real file, create one
    if vim.tbl_contains({ "help", "nofile", "quickfix" }, vim.bo[args.buf].buftype) then
      vim.keymap.set("n", "q", "<Cmd>close<CR>", {
        desc = "Close window",
        buffer = args.buf,
        silent = true,
        nowait = true,
      })
    end
  end,
})

vim.api.nvim_create_autocmd("BufWinEnter", {
  desc = "Clean up q_close_windows cache",
  callback = function(args)
    if vim.g.q_close_windows then
      vim.g.q_close_windows[args.buf] = nil
    end
  end,
})
