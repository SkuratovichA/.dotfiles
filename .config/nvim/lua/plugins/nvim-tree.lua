return {
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        sort_by = "case_sensitive",
        view = {
          width = 30,
        },
        renderer = {
          group_empty = true,
          -- Add icons to show git status
          icons = {
            git_placement = "after",
            show = {
              git = true,
            },
          },
        },
        filters = {
          dotfiles = false,
          -- Show gitignored files
          git_ignored = false,
          -- Don't hide any custom patterns
          custom = {},
        },
        -- Show git status
        git = {
          enable = true,
          ignore = false,  -- This shows gitignored files
          show_on_dirs = true,
          show_on_open_dirs = true,
        },
        -- Update focused file
        update_focused_file = {
          enable = true,
          update_root = false,
          ignore_list = {},
        },
      })

      vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<cr>", { desc = "Toggle file explorer" })
      vim.keymap.set("n", "<leader>o", "<cmd>NvimTreeFocus<cr>", { desc = "Focus file explorer" })
      vim.keymap.set("n", "<leader>E", "<cmd>NvimTreeFindFile<cr>", { desc = "Reveal current file in explorer" })
      
      -- Add keymaps to toggle gitignore filter
      vim.keymap.set("n", "<leader>tg", function()
        local api = require("nvim-tree.api")
        local current = require("nvim-tree.explorer.filters").config.filter_git_ignored
        require("nvim-tree.explorer.filters").config.filter_git_ignored = not current
        api.tree.reload()
        print("Git ignored files: " .. (current and "shown" or "hidden"))
      end, { desc = "Toggle gitignored files in tree" })
      
      -- Alternative: You can also use this to reveal and focus
      vim.keymap.set("n", "<leader>O", function()
        require("nvim-tree.api").tree.find_file({ open = true, focus = true })
      end, { desc = "Find and focus current file in explorer" })
    end,
  },
}
