return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
    },
    config = function()
      local telescope = require("telescope")
      local builtin = require("telescope.builtin")
      local actions = require("telescope.actions")

      -- Define only binary file patterns to ignore
      local binary_patterns = {
        -- Binary files
        "%.jpg$", "%.jpeg$", "%.png$", "%.gif$", "%.bmp$", "%.ico$", "%.webp$",
        "%.pdf$", "%.doc$", "%.docx$", "%.xls$", "%.xlsx$", "%.ppt$", "%.pptx$",
        "%.zip$", "%.tar$", "%.gz$", "%.rar$", "%.7z$",
        "%.exe$", "%.dll$", "%.so$", "%.dylib$",
        "%.mp3$", "%.mp4$", "%.avi$", "%.mov$", "%.wmv$", "%.flv$", "%.webm$",
        "%.ttf$", "%.otf$", "%.woff$", "%.woff2$", "%.eot$",
        "%.db$", "%.sqlite$", "%.sqlite3$",
        -- Add more binary extensions if needed
        "%.class$", "%.jar$", "%.war$", "%.ear$",
        "%.pyc$", "%.pyo$",
        "%.o$", "%.a$", "%.lib$",
        "%.iso$", "%.dmg$",
        "%.min%.js%.map$", "%.min%.css%.map$",
      }

      telescope.setup({
        defaults = {
          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-u>"] = actions.preview_scrolling_up,
              ["<C-d>"] = actions.preview_scrolling_down,
            },
            n = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-u>"] = actions.preview_scrolling_up,
              ["<C-d>"] = actions.preview_scrolling_down,
            },
          },
          vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--trim", -- Remove leading whitespace
            "--no-ignore", -- Don't respect .gitignore files
            "--hidden", -- Search hidden files
          },
          file_ignore_patterns = binary_patterns,
          layout_strategy = "horizontal",
          layout_config = {
            horizontal = {
              preview_width = 0.55,
              results_width = 0.8,
            },
            vertical = {
              mirror = false,
            },
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120,
          },
          path_display = { "truncate" },
        },
        pickers = {
          find_files = {
            find_command = { "rg", "--files", "--hidden", "--no-ignore" },
          },
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
        },
      })

      -- Load extension with error handling
      pcall(telescope.load_extension, "fzf")

      -- Standard keymaps
      vim.keymap.set("n", "<leader>ff", function()
        builtin.find_files({
          find_command = { "rg", "--files", "--hidden", "--no-ignore" },
          file_ignore_patterns = binary_patterns,
        })
      end, { desc = "Find files (include gitignored)" })

      vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find buffers" })
      vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })
      vim.keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "Recent files" })
      vim.keymap.set("n", "<leader>fs", builtin.grep_string, { desc = "Find string under cursor" })

      -- Live grep (includes gitignored files by default)
      vim.keymap.set("n", "<leader>fg", function()
        builtin.live_grep({
          file_ignore_patterns = binary_patterns,
          additional_args = function()
            return { "--hidden", "--no-ignore" }
          end,
          prompt_title = "Live Grep (all files)",
        })
      end, { desc = "Live grep (include gitignored)" })

      -- Alternative: Search respecting gitignore
      vim.keymap.set("n", "<leader>fG", function()
        builtin.live_grep({
          file_ignore_patterns = binary_patterns,
          vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--hidden",
            -- Respect .gitignore in this search
          },
          prompt_title = "Live Grep (respect gitignore)",
        })
      end, { desc = "Live grep (respect gitignore)" })

      -- Search in specific directories only
      vim.keymap.set("n", "<leader>fD", function()
        vim.ui.input({ prompt = "Directory: " }, function(dir)
          if dir then
            builtin.live_grep({
              search_dirs = { dir },
              file_ignore_patterns = binary_patterns,
              additional_args = function()
                return { "--hidden", "--no-ignore" }
              end,
              prompt_title = "Live Grep in: " .. dir,
            })
          end
        end)
      end, { desc = "Live grep in directory" })

      -- Find files with custom pattern
      vim.keymap.set("n", "<leader>fF", function()
        vim.ui.input({ prompt = "File pattern (e.g., *.lua): " }, function(pattern)
          if pattern then
            builtin.find_files({
              find_command = { "rg", "--files", "--hidden", "--no-ignore", "--glob", pattern },
              file_ignore_patterns = binary_patterns,
              prompt_title = "Find Files: " .. pattern,
            })
          end
        end)
      end, { desc = "Find files with pattern" })

      -- Search in current buffer
      vim.keymap.set("n", "<leader>f/", builtin.current_buffer_fuzzy_find, { desc = "Search in current buffer" })

      -- Git-specific searches (these respect git by nature)
      vim.keymap.set("n", "<leader>gf", builtin.git_files, { desc = "Find git files" })
      vim.keymap.set("n", "<leader>gc", builtin.git_commits, { desc = "Search git commits" })
      vim.keymap.set("n", "<leader>gb", builtin.git_branches, { desc = "Search git branches" })
      vim.keymap.set("n", "<leader>gs", builtin.git_status, { desc = "Git status files" })

      -- Search excluding common directories (but still including gitignored files)
      vim.keymap.set("n", "<leader>fE", function()
        builtin.live_grep({
          file_ignore_patterns = vim.list_extend(vim.deepcopy(binary_patterns), {
            "node_modules/",
            "venv/",
            "__pycache__/",
            "dist/",
            "build/",
            ".git/",
            ".idea/",
          }),
          additional_args = function()
            return { "--hidden", "--no-ignore" }
          end,
          prompt_title = "Live Grep (exclude common dirs)",
        })
      end, { desc = "Live grep (exclude node_modules, etc)" })
    end,
  },
}
