return {
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = function()
      require("gruvbox").setup({
        contrast = "hard", -- optional: "hard", "soft", or ""
      })
      vim.cmd.colorscheme("gruvbox")
    end,
  },
}
