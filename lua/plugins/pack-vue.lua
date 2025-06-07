return {
  -- 推荐加载的条件函数，根据文件类型和项目根目录判断是否需要加载 Vue 相关插件
  recommended = function()
    return LazyVim.extras.wants({
      ft = "vue", -- 文件类型为 vue 时推荐
      root = { "vue.config.js" }, -- 项目根目录存在 vue.config.js 文件时推荐
    })
  end,

  -- 引入 LazyVim 预设的 Vue 语言支持插件
  { import = "lazyvim.plugins.extras.lang.vue" },

  -- 配置 LSP 服务器，针对 Vue 生态常用的 volar 语言服务器
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        volar = {
          settings = {
            vue = {
              server = {
                -- 给 volar 服务器配置更大的内存限制，防止大型项目卡顿
                maxOldSpaceSize = 8192,
              },
            },
          },
        },
      },
    },
  },
}
