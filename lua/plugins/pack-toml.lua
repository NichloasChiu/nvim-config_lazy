return {
  -- recommended 是一个函数，根据项目文件类型和根目录文件判断是否推荐加载此配置
  recommended = function()
    return LazyVim.extras.wants({
      ft = "toml", -- 文件类型是 toml
      root = "*.toml", -- 项目根目录存在以 .toml 结尾的文件时生效
    })
  end,

  -- 导入 LazyVim 内置的 TOML 语言支持插件
  { import = "lazyvim.plugins.extras.lang.toml" },

  -- 这里可以添加额外的配置项，目前为空表
  {},
}
