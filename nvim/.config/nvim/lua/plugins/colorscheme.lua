local theme_file = os.getenv("HOME") .. "/.cache/current-theme"

local function read_theme()
  local f = io.open(theme_file, "r")
  if f then
    local theme = f:read("*l")
    f:close()
    return theme or "dark"
  end
  return "dark"
end

local function apply_theme()
  local theme = read_theme()
  vim.o.background = theme
  require("gruvbox").setup({
    contrast = theme == "light" and "medium" or "hard",
  })
  vim.cmd.colorscheme("gruvbox")
end

return {
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = function()
      apply_theme()

      -- Auto-reload when wallpaper picker changes system theme
      local uv = vim.uv or vim.loop
      local watcher = uv.new_fs_event()
      if watcher then
        watcher:start(theme_file, {}, function(err)
          if err then
            return
          end
          vim.schedule(apply_theme)
        end)
      end
    end,
  },
}
