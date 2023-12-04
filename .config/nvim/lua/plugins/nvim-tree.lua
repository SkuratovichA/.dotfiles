-- local Util = require("lazyvim.util")

return {
  {
    "nvim-neo-tree/neo-tree.nvim",

    branch = "v3.x",
    cmd = "Neotree",
    keys = {
      -- {
      --   "<C-n>",
      --   function()
      --     require("neo-tree.command").execute({ toggle = true, dir = Util.root() })
      --   end,
      --   desc = "Explorer NeoTree (root dir)",
      -- },

      {
        "<C-n>",
        function()
          require("neo-tree.command").execute({ toggle = true, dir = vim.loop.cwd() })
        end,
        desc = "Explorer NeoTree (cwd)",
      },
      -- { "<C->e", "<C->fe", desc = "Explorer NeoTree (root dir)", remap = true },
      -- { "<C-n>", "<C-n>", desc = "Explorer NeoTree (cwd)", remap = true },
      {
        "<C-n>g",
        function()
          require("neo-tree.command").execute({ source = "git_status", toggle = true })
        end,
        desc = "Git explorer",
      },
      -- {
      --   "<C->be",
      --   function()
      --     require("neo-tree.command").execute({ source = "buffers", toggle = true })
      --   end,
      --   desc = "Buffer explorer",
      -- },
    },
  },
}
