return {
  -- 导入 ESLint 相关配置（代码 linting 工具）
  { import = "lazyvim.plugins.extras.linting.eslint" },

  -- 导入 Prettier 相关配置（代码格式化工具）
  { import = "lazyvim.plugins.extras.formatting.prettier" },

  -- 导入 neoconf 配置（Neovim 配置管理工具）
  { import = "lazyvim.plugins.extras.lsp.neoconf" },

  -- 导入代码重构工具包
  { import = "lazyvim.plugins.extras.editor.refactoring" },

  -- 导入任务运行工具 Overseer
  { import = "lazyvim.plugins.extras.editor.overseer" },

  -- 导入测试相关工具（如单元测试）
  { import = "lazyvim.plugins.extras.test" },

  -- 导入 GitHub Copilot 配置（AI 代码补全）
  { import = "lazyvim.plugins.extras.ai.copilot" },
}
