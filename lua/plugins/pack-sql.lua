-- sql_ft 定义了受支持的 SQL 相关文件类型。
--
-- sql_formatter_linter(name) 函数生成一个表，键为文件类型，值为格式化或诊断工具名称，用于告诉 Conform 和 nvim-lint 绑定对应文件类型。
--
-- create_sqlfluff_config_file() 从配置目录复制 .sqlfluff 文件到当前项目目录。
--
-- formatting() 返回 sqlfmt 格式化时使用的参数：--dialect polyglot。
--
-- diagnostic() 构造执行 sqlfluff lint --format=json --config <config_file> 的参数列表，优先用项目目录配置。
--
-- remove_special_chars(input_str) 清除表名里的特殊字符，用于生成 buffer 名称。
--
-- 配置了 Mason 自动安装 sqlfluff 和 sqlfmt。
--
-- 配置 Conform 使用 sqlfmt 格式化 SQL。
--
-- 配置 nvim-lint 使用 sqlfluff 诊断 SQL。
--
-- 配置了 vim-dadbod 及其补全和 UI 插件，但 enabled = false（你可以通过修改 enabled 变量来启用）。
--
-- vim-dadbod-ui 相关配置初始化，包括 buffer 名称生成逻辑、窗口宽度和位置、执行查询时机（默认不自动执行）。
--
-- 自动命令绑定 <leader>cG 快捷键调用创建 .sqlfluff 配置文件函数。
--
-- 是否启用 dadbod 系列插件（数据库补全和 UI）
local enabled = false

-- 定义支持的 SQL 文件类型
local sql_ft = { "sql", "mysql", "plsql", "dbt" }

-- 根据传入格式化或诊断工具名称，返回一个表，表示每个 SQL 文件类型对应使用哪个工具
local function sql_formatter_linter(name)
  local f_by_ft = {}
  for _, ft in ipairs(sql_ft) do
    f_by_ft[ft] = { name }
  end
  return f_by_ft
end

-- 复制 sqlfluff 配置文件到当前项目目录
local function create_sqlfluff_config_file()
  local source_file = vim.fn.stdpath("config") .. "/.sqlfluff" -- 配置文件源路径
  local target_file = vim.fn.getcwd() .. "/.sqlfluff" -- 目标路径为当前工作目录
  require("utils").copy_file(source_file, target_file) -- 复制文件
end

-- sqlfmt 格式化时需要的参数，这里指定 dialect 为 polyglot
local function formatting()
  return { "--dialect", "polyglot" }
end

-- 生成 sqlfluff 诊断工具的命令参数列表
local function diagnostic()
  local system_config = vim.fn.stdpath("config") .. "/.sqlfluff" -- 全局配置文件路径
  local project_config = vim.fn.getcwd() .. "/.sqlfluff" -- 项目目录配置文件路径

  local sqlfluff = { "lint", "--format=json" }
  table.insert(sqlfluff, "--config") -- 需要指定配置文件

  -- 优先使用项目目录下的配置文件，如果不存在则使用全局配置
  if vim.fn.filereadable(project_config) == 1 then
    table.insert(sqlfluff, project_config)
  else
    table.insert(sqlfluff, system_config)
  end

  return sqlfluff
end

-- 移除字符串中的特殊字符，用于安全生成文件名或 buffer 名
local function remove_special_chars(input_str)
  local pattern = "[%+%*%?%.%^%$%(%)%[%]%%%-&%#]"
  local resultStr = input_str:gsub(pattern, "")
  return resultStr
end

-- 返回插件配置表
return {
  -- 只在打开指定 SQL 文件类型时加载本配置
  recommended = function()
    return LazyVim.extras.wants({
      ft = sql_ft,
    })
  end,
  -- Mason 管理并自动安装 sqlfluff 和 sqlfmt 命令行工具
  {
    "williamboman/mason.nvim",
    optional = true,
    opts = { ensure_installed = { "sqlfluff", "sqlfmt" } },
  },
  -- 使用 conform.nvim 作为格式化插件管理器，注册 sqlfmt 格式化器
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = function(_, opts)
      return require("utils").extend_tbl(opts, {
        default_format_opts = {
          timeout = 30000, -- 格式化超时时间，30秒
        },
        formatters = {
          sqlfmt = {
            prepend_args = formatting(), -- 调用自定义参数函数
          },
        },
        formatters_by_ft = sql_formatter_linter("sqlfmt"), -- 按文件类型绑定格式化工具
      })
    end,
  },
  -- 使用 nvim-lint 做诊断，注册 sqlfluff 作为 linter
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = function(_, opts)
      return require("utils").extend_tbl(opts, {
        linters = {
          sqlfluff = {
            args = diagnostic(), -- 传入动态参数
          },
        },
        linters_by_ft = sql_formatter_linter("sqlfluff"), -- 绑定 linter 到文件类型
      })
    end,
  },
  -- 数据库自动补全插件，根据 enabled 变量控制启用
  {
    "kristijanhusak/vim-dadbod-completion",
    enabled = enabled,
  },
  -- 核心数据库交互插件
  {
    "tpope/vim-dadbod",
    enabled = enabled,
  },
  -- 数据库 UI 插件，附带初始化配置
  {
    "kristijanhusak/vim-dadbod-ui",
    enabled = enabled,
    init = function()
      local data_path = vim.fn.stdpath("data")

      -- 各种界面配置
      vim.g.db_ui_auto_execute_table_helpers = 1 -- 自动执行辅助查询
      vim.g.db_ui_save_location = data_path .. "/dadbod_ui" -- 数据保存路径
      vim.g.db_ui_show_database_icon = true -- 显示数据库图标
      vim.g.db_ui_tmp_query_location = data_path .. "/dadbod_ui/tmp" -- 临时查询文件路径
      vim.g.db_ui_use_nerd_fonts = true -- 使用 nerd 字体图标
      vim.g.db_ui_use_nvim_notify = true -- 使用 nvim-notify 通知
      vim.g.db_ui_winwidth = require("utils").size(vim.o.columns, 0.3) -- 窗口宽度为屏幕 30%
      vim.g.db_ui_win_position = "right" -- UI 窗口位置
      vim.g.db_ui_disable_info_notifications = 1 -- 关闭信息通知

      -- 自定义 buffer 名称生成，去掉特殊字符，添加时间戳，方便区分
      vim.g.Db_ui_buffer_name_generator = function(opts)
        local table_name = opts.table

        if table_name and table_name ~= "" then
          return string.format("%s_%s.sql", remove_special_chars(table_name), os.time())
        else
          return string.format("console_%s.sql", os.time())
        end
      end

      -- 默认关闭保存时自动执行 SQL 查询（避免大查询自动运行导致卡顿）
      vim.g.db_ui_execute_on_save = false

      -- 给 SQL 文件绑定快捷键，方便快速创建 sqlfluff 配置文件
      vim.api.nvim_create_autocmd("FileType", {
        desc = "create sqlfluff config file",
        pattern = sql_ft,
        callback = function()
          vim.keymap.set(
            "n",
            "<leader>cG",
            create_sqlfluff_config_file,
            { buffer = true, desc = "Create sqlfluff config file" }
          )
        end,
      })
    end,
  },
}
