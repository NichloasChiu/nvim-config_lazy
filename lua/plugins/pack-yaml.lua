return {
  -- 推荐加载条件，判断文件类型是否为 yaml，满足时加载相关插件
  recommended = function()
    return LazyVim.extras.wants({
      ft = "yaml", -- 文件类型是 yaml 时推荐加载
    })
  end,

  -- 引入 LazyVim 预设的 YAML 语言支持插件
  { import = "lazyvim.plugins.extras.lang.yaml" },

  -- 可以在这里添加其他插件或配置项，目前为空表
  {},
}
