-- 插件介绍 — helpview.nvim

-- helpview.nvim 是一个增强 Neovim 内置帮助系统的插件，
-- 它让你浏览 Vim/Neovim 帮助文档时，界面更友好，导航更方便，
-- 体验更佳。比如会改进帮助文档的展示和切换方式，支持更现代化的交互。
--
return {
  -- 指定插件仓库，helpview.nvim 用于增强 Neovim 的帮助文档查看体验
  "OXY2DEV/helpview.nvim",

  -- 仅在打开 help 文件类型时加载该插件，实现按需加载
  ft = "help",

  -- 声明插件依赖，这里依赖 nvim-treesitter（语法高亮和解析工具）
  dependencies = {
    {
      "nvim-treesitter/nvim-treesitter",
      optional = true, -- 标记为可选依赖，只有安装了才生效

      -- 自定义配置函数，修改 nvim-treesitter 的配置选项
      opts = function(_, opts)
        -- 判断当前 ensure_installed 字段是否为 "all"
        if opts.ensure_installed ~= "all" then
          -- 通过工具函数 list_insert_unique 向 ensure_installed 表里添加 "vimdoc"
          -- 意思是让 treesitter 也支持解析 vim 帮助文档的语法（vimdoc）
          opts.ensure_installed = require("utils").list_insert_unique(opts.ensure_installed, { "vimdoc" })
        end
      end,
    },
  },
}
