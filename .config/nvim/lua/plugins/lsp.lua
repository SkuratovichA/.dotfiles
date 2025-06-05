return {
  -- LSP Configuration
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "onsails/lspkind.nvim", -- VS Code like pictograms
    },
    config = function()
      local mason = require("mason")
      local mason_lspconfig = require("mason-lspconfig")
      local lspconfig = require("lspconfig")
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local lspkind = require("lspkind")

      -- Mason setup
      mason.setup()
      mason_lspconfig.setup({
        ensure_installed = {
          "ts_ls",
          "phpactor",
          "pyright",
          "lua_ls",
          "eslint",
          "cssls",
          "html",
          "jsonls",
        },
      })

      -- LSP capabilities with additional completion capabilities
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      capabilities.textDocument.completion.completionItem.snippetSupport = true
      capabilities.textDocument.completion.completionItem.resolveSupport = {
        properties = {
          "documentation",
          "detail",
          "additionalTextEdits",
        },
      }

      -- LSP servers configuration
      local servers = {
        ts_ls = {
          settings = {
            typescript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
              suggest = {
                includeCompletionsForModuleExports = true,
                autoImports = true,
              },
            },
            javascript = {
              inlayHints = {
                includeInlayParameterNameHints = "all",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayVariableTypeHints = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
              },
              suggest = {
                includeCompletionsForModuleExports = true,
                autoImports = true,
              },
            },
          },
          init_options = {
            preferences = {
              includePackageJsonAutoImports = "on",
            },
          },
        },
        phpactor = {},
        pyright = {
          settings = {
            python = {
              analysis = {
                autoImportCompletions = true,
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                typeCheckingMode = "basic",
              },
            },
          },
        },
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = {
                globals = { "vim" },
              },
              workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
              },
              telemetry = {
                enable = false,
              },
            },
          },
        },
        eslint = {
          on_attach = function(client, bufnr)
            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer = bufnr,
              command = "EslintFixAll",
            })
          end,
        },
        cssls = {},
        html = {},
        jsonls = {},
      }

      -- Setup LSP servers
      for server, config in pairs(servers) do
        config.capabilities = capabilities
        lspconfig[server].setup(config)
      end

      -- Completion setup with auto-import support
      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ 
            select = true,
            behavior = cmp.ConfirmBehavior.Replace,
          }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }, {
          { name = "buffer" },
          { name = "path" },
        }),
        formatting = {
          format = lspkind.cmp_format({
            mode = "symbol_text",
            maxwidth = 50,
            ellipsis_char = "...",
            before = function(entry, vim_item)
              -- Show source
              vim_item.menu = ({
                nvim_lsp = "[LSP]",
                luasnip = "[Snippet]",
                buffer = "[Buffer]",
                path = "[Path]",
              })[entry.source.name]
              return vim_item
            end,
          }),
        },
        experimental = {
          ghost_text = true,
        },
      })

      -- LSP keymaps with enhanced functionality
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          map("gd", vim.lsp.buf.definition, "Go to definition")
          map("gD", vim.lsp.buf.declaration, "Go to declaration")
          map("gr", vim.lsp.buf.references, "Go to references")
          map("gi", vim.lsp.buf.implementation, "Go to implementation")
          map("<leader>D", vim.lsp.buf.type_definition, "Type definition")
          map("<leader>rn", vim.lsp.buf.rename, "Rename")
          map("<leader>ca", vim.lsp.buf.code_action, "Code action")
          map("K", vim.lsp.buf.hover, "Hover documentation")
          map("<C-k>", vim.lsp.buf.signature_help, "Signature help")
          
          -- Additional keymaps for imports and formatting
          map("<leader>oi", function()
            vim.lsp.buf.code_action({
              apply = true,
              context = {
                only = { "source.addMissingImports.ts" },
                diagnostics = {},
              },
            })
          end, "Organize imports")
          
          map("<leader>fm", function()
            vim.lsp.buf.format({ async = true })
          end, "Format document")
        end,
      })
      
      -- Auto-import on completion confirm
      vim.api.nvim_create_autocmd("CompleteDone", {
        callback = function()
          local completed_item = vim.v.completed_item
          if not completed_item or not completed_item.user_data then
            return
          end
          
          local item = vim.fn.json_decode(completed_item.user_data)
          if not item or not item.data then
            return
          end
          
          -- Trigger code action to add import if needed
          vim.lsp.buf.code_action({
            apply = true,
            context = {
              only = { "source.addMissingImports.ts" },
              diagnostics = {},
            },
          })
        end,
      })
    end,
  },

  -- Formatting and linting
  {
    "nvimtools/none-ls.nvim",
    dependencies = { 
      "nvim-lua/plenary.nvim",
      "nvimtools/none-ls-extras.nvim",
    },
    config = function()
      local null_ls = require("null-ls")
      
      null_ls.setup({
        sources = {
          -- TypeScript/JavaScript
          null_ls.builtins.formatting.prettier.with({
            filetypes = { "javascript", "typescript", "css", "scss", "html", "json", "yaml", "markdown", "graphql", "md", "txt" },
          }),
          require("none-ls.diagnostics.eslint_d"),
          
          -- PHP
          null_ls.builtins.formatting.phpcsfixer,
          null_ls.builtins.diagnostics.phpcs,
          
          -- Python
          null_ls.builtins.formatting.black,
          null_ls.builtins.diagnostics.flake8,
          
          -- Lua
          null_ls.builtins.formatting.stylua,
        },
        on_attach = function(client, bufnr)
          if client.supports_method("textDocument/formatting") then
            -- Format on save
            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format({ bufnr = bufnr })
              end,
            })
          end
        end,
      })
      
      -- Keymaps for manual formatting
      vim.keymap.set("n", "<leader>cf", vim.lsp.buf.format, { desc = "Format file" })
      vim.keymap.set("v", "<leader>cf", vim.lsp.buf.format, { desc = "Format selection" })
    end,
  },
  
  -- Better UI for LSP
  {
    "nvimdev/lspsaga.nvim",
    event = "LspAttach",
    config = function()
      require("lspsaga").setup({
        code_action = {
          num_shortcut = true,
          keys = {
            quit = "q",
            exec = "<CR>",
          },
        },
        lightbulb = {
          enable = true,
          enable_in_insert = true,
          sign = true,
          sign_priority = 40,
          virtual_text = true,
        },
        rename = {
          quit = "<C-c>",
          exec = "<CR>",
          in_select = true,
        },
        symbol_in_winbar = {
          enable = true,
          separator = " › ",
          hide_keyword = true,
          show_file = true,
          folder_level = 2,
        },
      })
      
      -- Lspsaga keymaps
      vim.keymap.set("n", "<leader>lf", "<cmd>Lspsaga finder<CR>", { desc = "LSP finder" })
      vim.keymap.set("n", "<leader>la", "<cmd>Lspsaga code_action<CR>", { desc = "Code action" })
      vim.keymap.set("v", "<leader>la", "<cmd>Lspsaga code_action<CR>", { desc = "Code action" })
      vim.keymap.set("n", "<leader>lr", "<cmd>Lspsaga rename<CR>", { desc = "Rename" })
      vim.keymap.set("n", "<leader>ld", "<cmd>Lspsaga peek_definition<CR>", { desc = "Peek definition" })
      vim.keymap.set("n", "<leader>lD", "<cmd>Lspsaga goto_definition<CR>", { desc = "Go to definition" })
      vim.keymap.set("n", "<leader>lt", "<cmd>Lspsaga peek_type_definition<CR>", { desc = "Peek type definition" })
      vim.keymap.set("n", "<leader>lT", "<cmd>Lspsaga goto_type_definition<CR>", { desc = "Go to type definition" })
      vim.keymap.set("n", "<leader>lo", "<cmd>Lspsaga outline<CR>", { desc = "Code outline" })
      vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", { desc = "Hover doc" })
    end,
  },
}
