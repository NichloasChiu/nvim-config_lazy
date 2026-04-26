-- neovim 主题
-- Set colorscheme to use
-- colorscheme = "catppuccin",
-- colorscheme = "astrotheme",
-- return "tokyonight"
-- return "catppuccin"
-- return "astrodark"
return {
  "catppuccin/nvim",
  name = "catppuccin",
  lazy = false,
  priority = 1000,
  config = function()
    require("catppuccin").setup({
      flavour = "mocha",
      transparent_background = true,
      integrations = {
        bufferline = true,
      },
    })

    vim.cmd.colorscheme("catppuccin")
    -- 强制修复浮动透明
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "WhichKeyFloat", { bg = "NONE" })
  end,
}
