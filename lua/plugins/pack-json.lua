return {
  recommended = function()
    -- 只有文件类型是 json/jsonc/json5，且项目根目录有 *.json 文件时才启用
    return LazyVim.extras.wants({
      ft = { "json", "jsonc", "json5" },
      root = { "*.json" },
    })
  end,

  -- 导入 LazyVim 官方提供的 JSON 语言支持配置
  { import = "lazyvim.plugins.extras.lang.json" },

  -- 空表，留作后续自定义扩展
  {},
}
