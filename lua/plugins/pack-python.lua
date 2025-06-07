-- basedpyright：是一个基于 Microsoft Pyright 的 Python 静态类型检查器，但有些定制，能更好支持某些项目或者用法。
--
-- LazyVim.extras.wants：判断是否启用这个插件配置，主要通过文件类型（python）和项目根文件判断，避免无谓加载。
--
-- 诊断设置主要偏向于“基础类型检查”和减少干扰的提示，比如把未使用导入、函数、变量报成信息级别，屏蔽部分非重要的类型错误提示，提高使用体验。
--
-- 结合了 LazyVim 现成的 Python 支持，配置 LSP 服务器的细节参数。
-- 设置全局变量，告诉 LazyVim Python 的 LSP 服务器使用 basedpyright 而不是 pyright
vim.g.lazyvim_python_lsp = "basedpyright"

return {
  -- 判断是否启用本配置的条件：
  -- 文件类型为 python，且项目根目录含有常见 Python 项目文件之一
  recommended = function()
    return LazyVim.extras.wants({
      ft = "python",
      root = {
        "pyproject.toml",
        "setup.py",
        "setup.cfg",
        "requirements.txt",
        "Pipfile",
        "pyrightconfig.json",
      },
    })
  end,

  -- 导入 LazyVim 默认的 Python 语言支持配置
  { import = "lazyvim.plugins.extras.lang.python" },

  -- LSP 服务器配置
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- 配置 basedpyright 语言服务器
        basedpyright = {
          settings = {
            basedpyright = {
              analysis = {
                typeCheckingMode = "basic", -- 类型检查模式：基础检查
                autoImportCompletions = true, -- 启用自动导入补全
                autoSearchPaths = true, -- 自动搜索库路径
                diagnosticMode = "openFilesOnly", -- 只对打开的文件做诊断，减少性能开销
                useLibraryCodeForTypes = true, -- 使用第三方库的代码类型提示
                reportMissingTypeStubs = false, -- 不报告缺少的类型存根
                diagnosticSeverityOverrides = { -- 诊断严重程度的覆盖设置
                  reportUnusedImport = "information", -- 未使用导入提示为信息级别
                  reportUnusedFunction = "information", -- 未使用函数信息提示
                  reportUnusedVariable = "information", -- 未使用变量信息提示
                  reportGeneralTypeIssues = "none", -- 不报告一般类型问题
                  reportOptionalMemberAccess = "none", -- 不报告可选成员访问问题
                  reportOptionalSubscript = "none", -- 不报告可选下标访问问题
                  reportPrivateImportUsage = "none", -- 不报告私有导入使用问题
                },
              },
            },
          },
        },
      },
    },
  },
}
