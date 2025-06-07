-- 定义调试快捷键前缀（<leader>d + 其他键）
local prefix = "<leader>d"

-- 检查 DAP 调试界面窗口是否已打开
-- @return boolean 是否至少有一个窗口处于打开状态
local is_dap_window_open = function()
  local windows = require("dapui.windows")
  local is_window_open = false
  -- 遍历所有预定义的布局窗口
  for i = 1, #windows.layouts, 1 do
    if windows.layouts[i]:is_open() then
      is_window_open = true
    end
  end
  return is_window_open
end

-- 关闭所有 DAP 调试界面窗口
local close_all_window = function()
  local windows = require("dapui.windows")
  -- 强制关闭所有布局窗口
  for i = 1, #windows.layouts, 1 do
    windows.layouts[i]:close()
  end
end

-- 交互式选择 DAP 调试界面布局
-- @param callback 选择布局后执行的回调函数
local choose_dap_element = function(callback)
  -- 显示交互选择菜单
  vim.ui.select({
    "repl|console", -- 布局1：REPL + 控制台组合
    "console|scopes", -- 布局2：控制台 + 作用域组合
    "console", -- 布局3：仅控制台
    "repl", -- 布局4：仅REPL
    "stacks", -- 布局5：调用栈
    "breakpoints", -- 布局6：断点列表
    "watches", -- 布局7：监视表达式
    "scopes", -- 布局8：变量作用域
    "all elements", -- 布局9：全部元素
  }, {
    prompt = "Select Dap Layout: ",
    default = "repl&console",
  }, function(select)
    if not select then
      return
    end -- 未选择时退出

    -- 先关闭已打开的窗口
    if is_dap_window_open() then
      close_all_window()
    end

    -- 根据选择打开对应布局
    -- layout 参数对应预定义的9种布局（见下方dap-ui配置）
    if select == "console|scopes" then
      require("dapui").open({ layout = 1, reset = true }) -- 布局1
    elseif select == "console" then
      require("dapui").open({ layout = 2, reset = true }) -- 布局2
    -- ...其他布局条件判断...
    elseif select == "repl|console" then
      require("dapui").open({ layout = 9, reset = true }) -- 布局9
    else
      -- 默认打开两个主要布局
      require("dapui").open({ layout = 8, reset = true }) -- 侧边栏布局
      require("dapui").open({ layout = 9, reset = true }) -- 底部组合布局
    end

    -- 执行回调（如继续调试）
    if callback then
      callback()
    end
  end)
end

return {
  -- 导入 LazyVim 的默认 DAP 配置
  { import = "lazyvim.plugins.extras.dap" },

  -- 配置调试时的代码补全
  {
    "saghen/blink.cmp",
    optional = true,
    dependencies = {
      -- 临时使用特定提交版本的 cmp-dap（等待PR合并）
      {
        "rcarriga/cmp-dap",
        commit = "db7ad7856309138ec31627271ac17a30e9d342ed",
      },
    },
    opts = function(_, opts)
      return require("utils").extend_tbl(opts, {
        -- 仅在非提示缓冲区或DAP缓冲区启用补全
        enabled = function()
          return (vim.bo.buftype ~= "prompt" or require("cmp_dap").is_dap_buffer()) and vim.b.completion ~= false
        end,
        sources = {
          -- 添加 dap 补全源
          compat = require("utils").list_insert_unique(opts.sources.compat or {}, { "dap" }),
          providers = {
            dap = {
              kind = "Dap", -- 补全项类型
              score_offset = 100, -- 优先级调整
              async = true, -- 异步加载
              enabled = function() -- 仅在DAP缓冲区启用
                return require("cmp_dap").is_dap_buffer()
              end,
            },
          },
        },
      })
    end,
  },

  -- 核心调试插件配置
  {
    "mfussenegger/nvim-dap",
    specs = {
      -- 集成持久化断点插件
      {
        "Weissle/persistent-breakpoints.nvim",
        event = "VeryLazy",
        opts = {
          load_breakpoints_event = { "BufReadPost" }, -- 读取文件时加载断点
        },
      },
    },
    keys = function(_, keys)
      -- 如果存在持久化断点插件，添加相关快捷键
      if LazyVim.has("persistent-breakpoints.nvim") then
        require("utils").list_insert_unique(keys, {
          -- 断点管理快捷键
          {
            prefix .. "b",
            function()
              require("persistent-breakpoints.api").toggle_breakpoint()
            end,
            desc = "Toggle breakpoint",
          },
          {
            prefix .. "B",
            function()
              require("persistent-breakpoints.api").set_conditional_breakpoint()
            end,
            desc = "Conditional breakpoint",
          },
          {
            prefix .. "D",
            function()
              require("persistent-breakpoints.api").clear_all_breakpoints()
            end,
            desc = "Clear All Breakpoints",
          },

          -- 调试控制快捷键
          {
            prefix .. "q",
            function()
              require("dap").terminate()
              require("dap").close()
            end,
            desc = "Terminate",
          },
          {
            prefix .. "c",
            function()
              -- 智能判断是否需先选择布局再继续调试
              if not is_dap_window_open() then
                choose_dap_element(function()
                  require("dap").continue()
                end)
              else
                require("dap").continue()
              end
            end,
            desc = "Run/Continue",
          },

          -- 调试界面控制
          {
            prefix .. "u",
            function()
              -- 切换调试界面开关状态
              if is_dap_window_open() then
                close_all_window()
              else
                choose_dap_element()
              end
            end,
            desc = "Dap UI",
          },

          -- 其他调试功能
          {
            prefix .. "r",
            function()
              require("dap").restart_frame()
            end,
            desc = "Restart",
          },
          {
            prefix .. "H",
            function()
              -- 创建浮动调试面板
              local window = {
                width = require("utils").size(vim.o.columns, 0.8), -- 宽度占80%
                height = require("utils").size(vim.o.lines, 0.8), -- 高度占80%
                position = "center", -- 居中显示
                enter = true, -- 自动聚焦
              }
              -- 选择要浮动的调试组件
              vim.ui.select({
                "console",
                "repl",
                "stacks",
                "breakpoints",
                "watches",
                "scopes",
              }, function(select)
                if select then
                  require("dapui").float_element(select, window)
                end
              end)
            end,
            desc = "Dap ui float element",
          },

          -- 功能键映射
          {
            "<F5>",
            function()
              require("dap").continue()
            end,
            desc = "Debugger: Start",
          },
          {
            "<F9>",
            function()
              require("persistent-breakpoints.api").toggle_breakpoint()
            end,
            desc = "Debugger: Toggle Breakpoint",
          },
          -- ...其他功能键...
        })
      end
      return keys
    end,
  },

  -- 调试界面配置
  {
    "rcarriga/nvim-dap-ui",
    opts = {
      -- 定义9种调试布局
      layouts = {
        { -- 布局1：底部组合面板（控制台40% + 作用域60%）
          elements = {
            { id = "console", size = 0.4 },
            { id = "scopes", size = 0.6 },
          },
          size = require("utils").size(vim.o.lines, 0.3), -- 高度占30%
          position = "bottom",
        },
        -- ...其他布局定义...
        { -- 布局8：右侧综合面板
          elements = {
            { id = "scopes", size = 0.25 },
            { id = "breakpoints", size = 0.25 },
            { id = "stacks", size = 0.25 },
            { id = "watches", size = 0.25 },
          },
          size = require("utils").size(vim.o.columns, 0.2), -- 宽度占20%
          position = "right",
        },
      },
      render = {
        max_type_length = 100, -- 类型显示最大长度
        max_value_lines = 100, -- 值显示最大行数
      },
    },
    config = function(_, opts)
      local dapui = require("dapui")
      local dap = require("dap")

      -- 为所有调试事件添加界面刷新监听
      local events = {
        "event_continued",
        "event_exited",
        "event_initialized",
        "event_invalidated",
        "event_stopped",
        "event_terminated",
        "event_thread",
        "attach",
        "continue",
        "disconnect",
        "initialize",
        "launch",
        "next",
        "pause",
        "restart",
        "restartFrame",
        "stepBack",
        "stepIn",
        "stepInTargets",
        "stepOut",
        "terminate",
        "terminateThreads",
        "event_continued",
        "event_exited",
      }
      for _, event in ipairs(events) do
        dap.listeners.after[event].dapui_config = function()
          require("dapui.controls").refresh_control_panel()
        end
      end

      dapui.setup(opts) -- 应用配置
    end,
  },

  -- 禁用虚拟文本插件（与当前配置冲突）
  {
    "theHamsta/nvim-dap-virtual-text",
    enabled = false,
  },
}
