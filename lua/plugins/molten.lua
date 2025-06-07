-- molten.nvim 是 Neovim 里用来交互式执行 Python 代码块的插件，类似 Jupyter Notebook 的体验。
--
-- ensure_kernel_for_venv() 辅助函数检查或创建当前 Python 虚拟环境对应的 Jupyter 内核，方便 molten.nvim 连接执行代码。
--
-- 配置了多种快捷键方便运行、重启内核、进入输出窗口等操作。
--
-- 兼容 which-key.nvim，能让快捷键分组和提示更友好。
--
local prefix = "<leader>j" -- 定义快捷键前缀，方便后续绑定快捷键

-- 函数：确保当前 Python 虚拟环境（venv 或 conda）对应的 Jupyter kernel 已安装
local function ensure_kernel_for_venv()
  -- 从环境变量中获取虚拟环境路径
  local venv_path = os.getenv("VIRTUAL_ENV") or os.getenv("CONDA_PREFIX")
  if not venv_path then
    -- 没有找到虚拟环境时，弹出警告
    vim.notify("No virtual environment found.", vim.log.levels.WARN)
    return
  end

  -- 标准化虚拟环境路径（绝对路径）
  venv_path = vim.fn.fnamemodify(venv_path, ":p")

  -- 通过 jupyter kernelspec list --json 获取已有 kernel 列表
  local handle = io.popen("jupyter kernelspec list --json")
  local existing_kernels = {}
  if handle then
    local result = handle:read("*a")
    handle:close()
    local json = vim.fn.json_decode(result)
    -- 遍历所有 kernel，检查是否已有当前虚拟环境对应的 kernel
    for kernel_name, data in pairs(json.kernelspecs) do
      existing_kernels[kernel_name] = true -- 记录已有 kernel 名称，方便后续检查重复
      -- 标准化 kernel 的 python 路径
      local kernel_path = vim.fn.fnamemodify(data.spec.argv[1], ":p")
      -- 如果 kernel 的 python 路径包含当前虚拟环境路径，说明已存在
      if kernel_path:find(venv_path, 1, true) then
        vim.notify("Kernel spec for this virtual environment already exists.", vim.log.levels.INFO)
        return kernel_name
      end
    end
  end

  -- 如果没找到对应 kernel，提示用户输入新 kernel 名称（需唯一）
  local new_kernel_name
  repeat
    new_kernel_name = vim.fn.input("Enter a unique name for the new kernel spec: ")
    if new_kernel_name == "" then
      vim.notify("Please provide a valid kernel name.", vim.log.levels.ERROR)
      return
    elseif existing_kernels[new_kernel_name] then
      vim.notify(
        "Kernel name '" .. new_kernel_name .. "' already exists. Please choose another name.",
        vim.log.levels.WARN
      )
      new_kernel_name = nil
    end
  until new_kernel_name

  -- 使用 python -m ipykernel 安装新的 kernel spec
  print("Creating a new kernel spec for this virtual environment...")
  local cmd = string.format(
    '%s -m ipykernel install --user --name="%s"',
    vim.fn.shellescape(venv_path .. "/bin/python"),
    new_kernel_name
  )

  os.execute(cmd)
  vim.notify("Kernel spec '" .. new_kernel_name .. "' created successfully.", vim.log.levels.INFO)
  return new_kernel_name
end

return {
  "benlubas/molten-nvim", -- 主插件：Molten.nvim，用于交互式运行 Python 代码块，类似 Jupyter notebook 效果
  ft = { "python" }, -- 只在 Python 文件中加载
  version = "^1", -- 锁定版本 1.x，避免 2.0 破坏性改动
  build = ":UpdateRemotePlugins", -- 安装后执行更新 remote-plugins 命令
  config = function()
    -- 配置 molten.nvim 全局变量，调整输出显示和行为
    vim.g["molten_auto_image_popup"] = false
    vim.g["molten_auto_open_html_in_browser"] = false
    vim.g["molten_auto_open_output"] = false
    vim.g["molten_cover_empty_lines"] = true

    vim.g["molten_enter_output_behavior"] = "open_and_enter"
    vim.g["molten_image_location"] = "both"
    vim.g["molten_output_show_more"] = true
    vim.g["molten_use_border_highlights"] = true

    vim.g["molten_output_virt_lines"] = false
    vim.g["molten_virt_lines_off_by_1"] = false
    vim.g["molten_virt_text_output"] = false
    vim.g["molten_wrap_output"] = true

    -- 为 molten 输出窗口创建自动命令，按 q 关闭输出窗口
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "molten_output" },
      callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.schedule(function()
          vim.keymap.set("n", "q", function()
            vim.cmd("MoltenHideOutput")
          end, {
            buffer = event.buf,
            silent = true,
            desc = "Quit buffer",
          })
        end)
      end,
    })
  end,

  -- 快捷键绑定
  keys = {
    {
      prefix .. "e", -- <leader>je，运行操作符选择的代码块
      function()
        vim.cmd([[MoltenEvaluateOperator]])
      end,
      desc = "Run operator selection",
    },
    {
      prefix .. "l", -- <leader>jl，运行当前行
      function()
        vim.cmd([[MoltenEvaluateLine]])
      end,
      desc = "Evaluate line",
    },
    {
      prefix .. "c", -- <leader>jc，重新运行当前代码单元
      function()
        vim.cmd([[MoltenReevaluateCell]])
      end,
      desc = "Re-evaluate cell",
    },
    {
      prefix .. "k", -- <leader>jk，进入输出窗口
      ":noautocmd MoltenEnterOutput<cr>",
      desc = "Enter Output",
    },
    {
      prefix .. "K", -- <leader>jK，视觉模式下进入输出窗口，并退出选中
      function()
        vim.cmd("noautocmd MoltenEnterOutput")
        if vim.fn.mode() == "v" or vim.fn.mode() == "V" or vim.fn.mode() == "\22" then
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
        end
      end,
      desc = "Enter Output",
      mode = "v",
    },
    {
      prefix .. "mi", -- <leader>jmi，初始化 molten.nvim
      function()
        vim.cmd([[MoltenInit]])
      end,
      desc = "Initialize the plugin",
    },
    {
      prefix .. "mh", -- <leader>jmh，隐藏输出窗口
      function()
        vim.cmd([[MoltenHideOutput]])
      end,
      desc = "Hide Output",
    },
    {
      prefix .. "mI", -- <leader>jmI，中断当前内核运行
      function()
        vim.cmd([[MoltenInterrupt]])
      end,
      desc = "Interrupt kernel",
    },
    {
      prefix .. "mR", -- <leader>jmR，重启内核
      function()
        vim.cmd([[MoltenRestart]])
      end,
      desc = "Restart kernel",
    },
    {
      prefix .. "mp", -- <leader>jmp，针对 Python 虚拟环境自动初始化内核
      function()
        local kernel_name = ensure_kernel_for_venv()
        if kernel_name then
          vim.cmd(("MoltenInit %s"):format(kernel_name))
        else
          vim.notify("No kernel to initialize.", vim.log.levels.WARN)
        end
      end,
      desc = "Initialize for Python venv",
      silent = true,
    },
    {
      prefix .. "r", -- <leader>jr，视觉模式下运行选中代码
      ":<C-u>MoltenEvaluateVisual<CR>",
      desc = "Evaluate visual selection",
      mode = "v",
    },
    {
      "]c", -- ]c 跳转到下一个 molten 代码单元
      "<Cmd>MoltenNext<CR>",
      desc = "Next Molten Cell",
    },
    {
      "[c", -- [c 跳转到上一个 molten 代码单元
      "<Cmd>MoltenPrev<CR>",
      desc = "Previous Molten Cell",
    },
  },

  -- which-key 插件集成（可选）
  specs = {
    {
      "folke/which-key.nvim",
      optional = true,
      opts = {
        spec = {
          { prefix, group = "molten", icon = "󱓞", mode = { "n", "v" } },
          { prefix .. "m", group = "mommands", icon = "󱓞" },
        },
      },
    },
  },
}
