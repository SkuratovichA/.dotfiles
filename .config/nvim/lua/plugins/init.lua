return {
  -- Colorscheme
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd([[colorscheme tokyonight]])
    end,
  },

  -- Treesitter for syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "lua", "typescript", "php", "python", "html", "css", "json", "javascript", "tsx", "vim", "vimdoc" },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },

  -- Which-key for keybinding help (updated to show in floating window)
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      require("which-key").setup({
        layout = {
          -- height = 50,
          spacing = 4,
          align = "left",
          border = "rounded",
        },
        preset = "helix",

        -- width = 0.9,
        -- height = { min = 4, max = 25 },
        -- col = 0.5,
        -- row = -1,
        -- title = true,
        -- title_pos = "center",

        window = {
          border = "rounded",
          position = "bottom",
          margin = { 1, 0, 1, 0 },
          padding = { 4, 4, 4, 4 },
          winblend = 0
        },
        -- keys = {
        --   scroll_down = '',
        --   scroll_up = ''
        -- }
        show_help = true,
        show_keys = true,
      })
    end,
  },
}
