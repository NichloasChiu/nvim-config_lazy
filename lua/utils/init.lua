-- 创建一个空表 M，用于存放所有函数，最后 return M 使其可以被其他文件 require 调用。
local M = {}

-- 文件通常会在 Neovim 配置的最后阶段加载，适合放置
--
--用途：安全移除 Neovim 中已定义的快捷键（如覆盖默认映射时）
function M.remove_keymap(mode, key)
  for _, map in pairs(vim.api.nvim_get_keymap(mode)) do
    if map.lhs:upper() == key:upper() then -- 不区分大小写比较按键
      vim.api.nvim_del_keymap(mode, key) -- 删除匹配的按键映射
      return map -- 返回被删除的映射信息
    end
  end
end

function M.remove_keys(key_binding, remove_key_list)
  for i1, v1 in ipairs(remove_key_list) do
    for i2, v2 in ipairs(key_binding) do
      if v1:upper() == v2[1]:upper() then
        table.remove(key_binding, i2)
      end
    end
  end
end

-- 用途：判断一个列表（如命令行参数）中是否包含特定值
function M.contains_arg(args, arg)
  for _, v in ipairs(args) do
    if v == arg then
      return true
    end
  end
  return false
end

-- 用途：提供文件系统操作（路径处理、文件检查、复制等）
function M.get_parent_dir(path) -- 获取父目录路径（去掉最后一级）
  return path:match("(.+)/")
end

function M.file_exists(filepath) -- 检查文件是否存在
  return vim.fn.glob(filepath) ~= ""
end

function M.copy_file(source, target) -- 复制文件
  local target_dir = M.get_parent_dir(target)
  os.execute("mkdir -p " .. vim.fn.shellescape(target_dir)) -- 创建目标目录
  os.execute("cp " .. vim.fn.shellescape(source) .. " " .. vim.fn.shellescape(target)) -- 复制文件
  vim.notify("File copied: " .. target, vim.log.levels.INFO) -- 通知用户
end

-- 用途：提供通用工具（安全搜索、列表/表合并等）
function M.better_search(key) -- 增强搜索命令（带错误处理）
  return function()
    local ok, err = pcall(vim.cmd.normal, { args = { key }, bang = true })
    if not ok then
      vim.notify(err, vim.log.levels.ERROR)
    end
  end
end

-- 合并列表并去重
function M.list_insert_unique(dst, src)
  if not dst then
    dst = {}
  end
  local added = {}
  for _, val in ipairs(dst) do
    added[val] = true
  end
  for _, val in ipairs(src) do
    if not added[val] then
      table.insert(dst, val)
      added[val] = true
    end
  end
  return dst
end

function M.extend_tbl(default, opts) -- 深度合并两个表
  return vim.tbl_deep_extend("force", default or {}, opts or {})
end

-- 用途：检查插件是否存在
function M.is_available(plugin)
  local ok, _ = pcall(require, plugin)
  return ok
end

function M.size(max, value)
  return value > 1 and math.min(value, max) or math.floor(max * value)
end

-- 返回模块 M，使得其他文件可以通过 require("utils") 调用这些函数
return M
