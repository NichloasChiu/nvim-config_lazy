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
  vim.ui.select({
    "repl|console",
    "console|scopes",
    "console",
    "repl",
    "stacks",
    "breakpoints",
    "watches",
    "scopes",
    "all elements",
  }, {
    prompt = "Select Dap Layout: ",
    default = "repl&console",
  }, function(select)
    if not select then
      return
    end

    if is_dap_window_open() then
      close_all_window()
    end

    if select == "console|scopes" then
      require("dapui").open({ layout = 1, reset = true })
    elseif select == "console" then
      require("dapui").open({ layout = 2, reset = true })
    elseif select == "repl|console" then
      require("dapui").open({ layout = 9, reset = true })
    else
      require("dapui").open({ layout = 8, reset = true })
      require("dapui").open({ layout = 9, reset = true })
    end

    if callback then
      callback()
    end
  end)
end

return {
  -- 导入 LazyVim 的默认 DAP 配置
  { import = "lazyvim.plugins.extras.dap.core" },
  { import = "lazyvim.plugins.extras.dap.nlua" },

  -- 配置调试时的代码补全
  {
    "saghen/blink.cmp",
    optional = true,
    dependencies = {
      {
        "rcarriga/cmp-dap",
        commit = "db7ad7856309138ec31627271ac17a30e9d342ed",
      },
    },
    opts = function(_, opts)
      return require("utils").extend_tbl(opts, {
        enabled = function()
          return (vim.bo.buftype ~= "prompt" or require("cmp_dap").is_dap_buffer()) and vim.b.completion ~= false
        end,
        sources = {
          compat = require("utils").list_insert_unique(opts.sources.compat or {}, { "dap" }),
          providers = {
            dap = {
              kind = "Dap",
              score_offset = 100,
              async = true,
              enabled = function()
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
      {
        "Weissle/persistent-breakpoints.nvim",
        event = "VeryLazy",
        opts = {
          load_breakpoints_event = { "BufReadPost" },
        },
      },
    },
    keys = function(_, keys)
      if LazyVim.has("persistent-breakpoints.nvim") then
        require("utils").list_insert_unique(keys, {
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

          {
            prefix .. "u",
            function()
              if is_dap_window_open() then
                close_all_window()
              else
                choose_dap_element()
              end
            end,
            desc = "Dap UI",
          },

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
              local window = {
                width = require("utils").size(vim.o.columns, 0.8),
                height = require("utils").size(vim.o.lines, 0.8),
                position = "center",
                enter = true,
              }

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

          -- ⭐⭐⭐⭐⭐ 关键修复：F5 自动打开 dapui ⭐⭐⭐⭐⭐
          {
            "<F5>",
            function()
              require("dapui").open() -- ✅ 关键新增
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
        })
      end
      return keys
    end,
  },

  -- 调试界面配置
  {
    "rcarriga/nvim-dap-ui",
    opts = {
      layouts = {
        {
          elements = {
            { id = "console", size = 0.4 },
            { id = "scopes", size = 0.6 },
          },
          size = require("utils").size(vim.o.lines, 0.3),
          position = "bottom",
        },

        {
          elements = {
            { id = "scopes", size = 0.25 },
            { id = "breakpoints", size = 0.25 },
            { id = "stacks", size = 0.25 },
            { id = "watches", size = 0.25 },
          },
          size = require("utils").size(vim.o.columns, 0.2),
          position = "right",
        },
      },

      render = {
        max_type_length = 100,
        max_value_lines = 100,
      },
    },

    config = function(_, opts)
      local dapui = require("dapui")
      local dap = require("dap")

      -- ⭐⭐⭐⭐⭐ 关键修复：自动打开 UI hooks ⭐⭐⭐⭐⭐
      dap.listeners.after.event_initialized.dapui_config = function()
        dapui.open()
      end

      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end

      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end

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
      }

      for _, event in ipairs(events) do
        dap.listeners.after[event].dapui_config = function()
          require("dapui.controls").refresh_control_panel()
        end
      end

      dapui.setup(opts)
    end,
  },

  {
    "theHamsta/nvim-dap-virtual-text",
    enabled = false,
  },
}
