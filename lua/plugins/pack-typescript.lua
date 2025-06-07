return {
  -- 推荐加载条件函数
  recommended = function()
    return LazyVim.extras.wants({
      ft = {
        "javascript",
        "javascriptreact",
        "javascript.jsx", -- 也可能是jsx文件
        "typescript",
        "typescriptreact",
        "typescript.tsx", -- tsx文件
      },
      root = { "tsconfig.json", "package.json", "jsconfig.json" }, -- 项目根目录有这些文件时推荐
    })
  end,

  -- 引入 LazyVim 内置的 Typescript 语言支持插件
  { import = "lazyvim.plugins.extras.lang.typescript" },

  -- 集成测试框架 Neotest 及其 Vitest 和 Jest 适配器
  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = {
      "marilari88/neotest-vitest", -- Vitest 适配器
      "nvim-neotest/neotest-jest", -- Jest 适配器
    },
    opts = {
      adapters = {
        ["neotest-jest"] = {}, -- 启用 Jest 适配器
        ["neotest-vitest"] = {}, -- 启用 Vitest 适配器
      },
    },
  },

  -- LSP 服务器配置，vtsls 是基于 tsserver 的自定义服务
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        vtsls = {
          settings = {
            typescript = {
              tsserver = { maxTsServerMemory = 8192 }, -- tsserver 最大内存 8GB，防止大项目卡顿
            },
          },
        },
      },
    },
  },
}
