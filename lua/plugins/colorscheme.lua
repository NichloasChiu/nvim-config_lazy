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
    })
    vim.cmd.colorscheme("catppuccin")
  end,
}
