-- 定义一个局部函数，用于获取补全项的图标
local function get_icon(ctx)
  -- 引入 mini.icons 模块用于获取图标
  local mini_icons = require("mini.icons")
  -- 获取补全项的来源名称（如 LSP、Path 等）
  local source = ctx.item.source_name
  -- 获取补全项的显示标签
  local label = ctx.item.label
  -- 获取补全项的文档说明（可能包含颜色值）
  local color = ctx.item.documentation

  -- 如果补全项来自 LSP
  if source == "LSP" then
    -- 检查文档是否是有效的十六进制颜色值（如 #RRGGBB）
    if color and type(color) == "string" and color:match("^#%x%x%x%x%x%x$") then
      -- 创建高亮组名称（前缀 hex-）
      local hl = "hex-" .. color:sub(2)
      -- 检查高亮组是否已存在
      if #vim.api.nvim_get_hl(0, { name = hl }) == 0 then
        -- 如果不存在则创建新的高亮组
        vim.api.nvim_set_hl(0, hl, { fg = color })
      end
      -- 返回图标、高亮组和不使用默认图标的标记
      return "󱓻", hl, false
    else
      -- 如果不是颜色项，获取默认的 LSP 类型图标
      return mini_icons.get("lsp", ctx.kind)
    end
  -- 如果补全项来自文件路径
  elseif source == "Path" then
    -- 判断是文件还是目录：检查是否有文件扩展名
    return (label:match("%.[^/]+$") and mini_icons.get("file", label) or mini_icons.get("directory", label))
  -- 如果补全项来自 codeium
  elseif source == "codeium" then
    -- 获取特定的事件类型图标
    return mini_icons.get("lsp", "event")
  -- 其他来源的补全项
  else
    -- 使用默认的图标和高亮组
    return ctx.kind_icon, "BlinkCmpKind" .. ctx.kind, false
  end
end

-- 返回插件配置表
return {
  -- 插件名称
  "saghen/blink.cmp",
  -- 插件加载时机：插入模式和命令行模式
  event = { "InsertEnter", "CmdlineEnter" },
  -- 插件依赖项
  dependencies = {
    {
      -- 兼容层插件
      "saghen/blink.compat",
      -- 插件选项
      opts = {},
      -- 延迟加载
      lazy = true,
      -- 版本要求
      version = "*",
    },
    {
      -- dotenv 补全支持
      "SergioRibera/cmp-dotenv",
    },
  },
  -- 插件配置函数
  opts = function(_, opts)
    -- 合并默认配置和自定义配置
    return require("utils").extend_tbl(opts, {
      -- 补全源配置
      sources = {
        -- 设置最小关键字长度函数
        min_keyword_length = function(ctx)
          -- 仅当在命令行模式且未输入空格时（即命令名阶段）
          if ctx.mode == "cmdline" and string.find(ctx.line, " ") == nil then
            -- 需要至少2个字符才触发补全
            return 2
          end
          -- 其他情况不限制
          return 0
        end,
        -- 向兼容源列表中添加 dotenv 支持
        compat = require("utils").list_insert_unique(opts.sources.compat or {}, { "dotenv" }),
        -- 补全提供者配置
        providers = {
          -- dotenv 补全配置
          dotenv = {
            -- 补全项类型
            kind = "DotEnv",
            -- 分数偏移（降低优先级）
            score_offset = -100,
            -- 异步加载
            async = true,
          },
          -- LSP 补全配置
          lsp = {
            -- 转换补全项的函数
            transform_items = function(ctx, items)
              -- 遍历所有补全项
              for _, item in ipairs(items) do
                -- 如果是代码片段类型
                if item.kind == require("blink.cmp.types").CompletionItemKind.Snippet then
                  -- 降低代码片段的优先级
                  item.score_offset = item.score_offset - 3
                end
              end

              -- 过滤补全项（禁用诊断警告）
              ---@diagnostic disable-next-line: redundant-return-value
              return vim.tbl_filter(function(item)
                -- 获取光标位置信息
                local c = ctx.get_cursor()
                local cursor_line = ctx.line
                local cursor = {
                  row = c[1],
                  col = c[2] + 1,
                  line = c[1] - 1,
                }
                -- 获取光标前的内容
                local cursor_before_line = string.sub(cursor_line, 1, cursor.col - 1)

                -- 移除纯文本类型的补全项
                if item.kind == require("blink.cmp.types").CompletionItemKind.Text then
                  return false
                end

                -- Vue 文件特殊处理
                if vim.bo.filetype == "vue" then
                  -- 匹配事件绑定 (@)
                  if cursor_before_line:match("(@[%w]*)%s*$") ~= nil then
                    -- 只显示以 @ 开头的补全项
                    return item.label:match("^@") ~= nil
                  -- 匹配属性绑定 (:)
                  elseif cursor_before_line:match("(:[%w]*)%s*$") ~= nil then
                    -- 只显示以 : 开头且不以 :on- 开头的补全项
                    return item.label:match("^:") ~= nil and not item.label:match("^:on%-") ~= nil
                  -- 匹配插槽 (#)
                  elseif cursor_before_line:match("(#[%w]*)%s*$") ~= nil then
                    -- 只显示方法类型的补全项
                    return item.kind == require("blink.cmp.types").CompletionItemKind.Method
                  end
                end

                -- 默认保留所有其他补全项
                return true
              end, items)
            end,
          },
        },
      },
      -- 启用函数签名提示
      signature = { enabled = true },
      -- 命令行补全配置
      cmdline = {
        -- 启用命令行补全
        enabled = true,
        -- 键位映射配置
        keymap = {
          -- Tab 键接受补全
          ["<Tab>"] = { "accept" },
          -- Enter 键接受补全并换行
          ["<CR>"] = { "accept_and_enter", "fallback" },
        },
        -- 补全菜单配置
        completion = { menu = { auto_show = true } }, -- 自动显示菜单
        -- 根据命令类型选择补全源
        sources = function()
          -- 获取当前命令类型
          local type = vim.fn.getcmdtype()
          -- 搜索命令 (/, ?) 使用缓冲区补全
          if type == "/" or type == "?" then
            return { "buffer" }
          end
          -- 普通命令 (:) 和寄存器命令 (@) 使用命令行补全
          if type == ":" or type == "@" then
            return { "cmdline" }
          end
          -- 其他情况不使用补全
          return {}
        end,
      },
      -- 补全列表配置
      completion = {
        -- 列表选择配置
        list = { selection = { preselect = true, auto_insert = false } },
        -- 菜单绘制配置
        menu = {
          -- 禁用滚动条
          scrollbar = false,
          -- 自定义绘制组件
          draw = {
            components = {
              -- 类型图标组件
              kind_icon = {
                -- 启用省略号
                ellipsis = true,
                -- 图标文本
                text = function(ctx)
                  -- 获取图标
                  local icon, _, _ = get_icon(ctx)
                  -- 返回图标加间隔
                  return icon .. ctx.icon_gap
                end,
                -- 高亮设置
                highlight = function(ctx)
                  -- 获取高亮组
                  local _, hl, _ = get_icon(ctx)
                  return hl
                end,
              },
              -- 类型文本组件
              kind = {
                -- 启用省略号
                ellipsis = true,
              },
            },
          },
        },
      },
      -- 键位映射预设
      keymap = {
        ["<Tab>"] = { "accept" }, -- Tab 键接受补全
        ["<S-Tab>"] = { "select_prev" }, -- Shift+Tab 键选择上一个补全项
      },
    })
  end,
}
