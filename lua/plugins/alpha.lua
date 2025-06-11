return {
  "goolord/alpha-nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  event = "VimEnter",
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")
    local plenary = require("plenary.path")

    -- 🚀 Header: 简单大方
    dashboard.section.header.val = {
      "                                  🚀 Welcome, NichloasChiu 🚀",
      -- [[         /"\                                           去他妈的工作，去他们的生活!!!  ]],
      [[         /"\                                 ]],
      [[        |\ /|           ]],
      [[        |   |           ███╗   ██╗██╗ ██████╗██╗  ██╗██╗      ██████╗  █████╗ ███████╗       ██████╗██╗  ██╗██╗██╗   ██╗]],
      [[        | ~ |           ████╗  ██║██║██╔════╝██║  ██║██║     ██╔═══██╗██╔══██╗██╔════╝      ██╔════╝██║  ██║██║██║   ██║]],
      [[        |   |           ██╔██╗ ██║██║██║     ███████║██║     ██║   ██║███████║███████╗      ██║     ███████║██║██║   ██║]],
      [[     /'\|   |/'\        ██║╚██╗██║██║██║     ██╔══██║██║     ██║   ██║██╔══██║╚════██║      ██║     ██╔══██║██║██║   ██║]],
      [[ /"\|   |   |   | \     ██║ ╚████║██║╚██████╗██║  ██║███████╗╚██████╔╝██║  ██║███████║      ╚██████╗██║  ██║██║╚██████╔╝]],
      [[|   [ @ ]   |   |  \    ╚═╝  ╚═══╝╚═╝ ╚═════╝╚═╝  ╚═╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝       ╚═════╝╚═╝  ╚═╝╚═╝ ╚═════╝ ]],
      [[|   |   |   |   |   \   ███╗   ██╗  ██╗   ██╗  ██╗  ███╗   ███╗  ███████╗  ██████╗   ██╗  ████████╗   ██████╗   ██████╗]],
      [[| ~ ~  ~  ~ |    )   \  ████╗  ██║  ██║   ██║  ██║  ████╗ ████║  ██╔════╝  ██╔══██╗  ██║  ╚══██╔══╝  ██╔═══██╗  ██╔══██╗]],
      [[|                   /   ██╔██╗ ██║  ██║   ██║  ██║  ██╔████╔██║  █████╗    ██║  ██║  ██║     ██║     ██║   ██║  ██████╔╝]],
      [[ \                 /    ██║╚██╗██║  ╚██╗ ██╔╝  ██║  ██║╚██╔╝██║  ██╔══╝    ██║  ██║  ██║     ██║     ██║   ██║  ██╔══██╗]],
      [[  \               /     ██║ ╚████║   ╚████╔╝   ██║  ██║ ╚═╝ ██║  ███████╗  ██████╔╝  ██║     ██║     ╚██████╔╝  ██║  ██║]],
      [[   \    _____    /      ╚═╝  ╚═══╝    ╚═══╝    ╚═╝  ╚═╝     ╚═╝  ╚══════╝  ╚═════╝   ╚═╝     ╚═╝      ╚═════╝   ╚═╝  ╚═╝]],
      [[    |– //''\ – |       ]],
      [[    | (( =+= )) |       ]],
      [[    |– \\_|_//– |       ]],
    }

    -- -- 🚀 最近文件
    -- local function get_recent_files(max)
    --   local oldfiles = vim.v.oldfiles
    --   local recent_files = {}
    --   for _, file in ipairs(oldfiles) do
    --     if plenary:new(file):exists() then
    --       table.insert(recent_files, file)
    --       if #recent_files >= max then
    --         break
    --       end
    --     end
    --   end
    --   return recent_files
    -- end
    --
    -- local recent_files = get_recent_files(5)
    local buttons = {}
    --
    -- for i, file in ipairs(recent_files) do
    --   local short_file = vim.fn.fnamemodify(file, ":~")
    --   table.insert(buttons, dashboard.button(tostring(i), short_file, "<cmd>e " .. file .. "<CR>"))
    -- end
    --
    -- 🚀 自定义按钮（彩色）
    local custom_buttons = {
      { key = "n", label = "  New File", cmd = ":ene <BAR> startinsert<CR>", color = "Identifier" },
      { key = "f", label = "  Find File", cmd = ":Telescope find_files<CR>", color = "Function" },
      { key = "r", label = "  Recent Files", cmd = ":Telescope oldfiles<CR>", color = "Keyword" },
      { key = "c", label = "  Configuration", cmd = ":e $MYVIMRC<CR>", color = "Constant" },
      { key = "q", label = "  Quit Neovim", cmd = ":qa<CR>", color = "ErrorMsg" },
    }

    for _, btn in ipairs(custom_buttons) do
      local b = dashboard.button(btn.key, btn.label, btn.cmd)
      b.opts.hl = btn.color
      table.insert(buttons, b)
    end

    dashboard.section.buttons.val = buttons

    -- 🚀 Footer: 留空或可添加其他提示
    -- dashboard.section.footer.val = "⚡ Ready to start coding!"

    -- 🚀高亮颜色
    vim.cmd([[
      highlight AlphaHeader guifg=#7aa2f7
      highlight AlphaButtons guifg=#f7768e
      highlight AlphaFooter guifg=#b4f9f8
    ]])
    dashboard.section.footer.opts.hl = "AlphaFooter"

    -- 启用 alpha
    alpha.setup(dashboard.opts)
  end,
}
