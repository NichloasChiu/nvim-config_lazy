return {
  recommended = {
    ft = { "gitcommit", "gitconfig", "gitrebase", "gitignore", "gitattributes" },
    -- 只在这些文件类型出现时启用该模块
  },

  -- 引入 LazyVim 官方提供的 Git 相关配置模块
  { import = "lazyvim.plugins.extras.lang.git" },

  -- 空表，可用于后续自定义配置
  {},
}
