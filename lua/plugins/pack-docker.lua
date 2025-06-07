return {
  recommended = function()
    -- 仅当编辑的文件类型是 dockerfile，或者在含有特定文件的工程根目录时，才启用这个模块
    return LazyVim.extras.wants({
      ft = "dockerfile", -- 文件类型：dockerfile
      root = { "Dockerfile", "docker-compose.yml", "compose.yml", "docker-compose.yaml", "compose.yaml" },
      -- 这些文件在项目根目录出现时也会触发启用
    })
  end,

  -- 直接导入 LazyVim 已内置的 Docker 语言插件配置
  { import = "lazyvim.plugins.extras.lang.docker" },

  -- 空表，通常用于占位或后续额外配置
  {},
}
