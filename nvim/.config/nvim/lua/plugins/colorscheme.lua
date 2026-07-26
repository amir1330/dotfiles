local function read_theme()
  local f = io.open(os.getenv("HOME") .. "/.cache/current-theme", "r")
  if f then
    local theme = f:read("*l")
    f:close()
    return theme or "dark"
  end
  return "dark"
end

return {
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = function()
      local theme = read_theme()
      vim.o.background = theme
      require("gruvbox").setup({
        contrast = "hard",
      })
      vim.cmd.colorscheme("gruvbox")
    end,
  },
}
