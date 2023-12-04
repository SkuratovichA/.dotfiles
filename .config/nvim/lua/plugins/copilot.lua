return {
  "github/copilot.vim",
  init = function()
    vim.keymap.set("i", "<C-<CR>>", [[copilot#Accept("\<CR>")]], {
      silent = true,
      expr = true,
      script = true,
      replace_keycodes = false,
    })
  end,
}
