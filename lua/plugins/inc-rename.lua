return {
  {
    "smjonas/inc-rename.nvim",
    cmd = "IncRename",
    config = true,
    keys = {
      {
        "<leader>rn",
        function()
          vim.cmd("IncRename " .. vim.fn.expand("<cword>"))
        end,
        desc = "Incremental Rename",
      },
    },
  },
}
