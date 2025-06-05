1. Which-key in floating window

Updated the which-key configuration to show hints in a floating window in the bottom right corner
Set it to display in a single column with rounded borders

2. Git blame plugin

Added gitsigns.nvim which provides:

Git blame inline (toggle with <leader>tb)
Git blame for current line (<leader>hb)
Git signs in the gutter
Hunk navigation and staging



3. WebStorm-like Git Changes view

Added diffview.nvim for split diff view:

<leader>gd - Open diff view (shows changed files with side-by-side diff)
<leader>gc - Close diff view
<leader>gh - File history
<leader>gH - Branch history


Added neogit.nvim for commit interface:

<leader>gs - Open Neogit status (similar to WebStorm's Changes panel)
<leader>gC - Open commit interface
In Neogit, you can stage files with s, unstage with u, and commit with c



4. Auto-imports and better code actions

Enhanced TypeScript/JavaScript LSP configuration for auto-imports
Added lspsaga.nvim for better UI for code actions
Configured completion to automatically add imports when selecting suggestions
Added keymap <leader>oi to organize imports
Code actions available with <leader>ca or <leader>la

5. Prettier/Lint integration

Already configured in your setup, but I added:

<leader>cf - Format file/selection
Auto-format on save for ESLint
Better integration with none-ls for multiple formatters



Additional improvements I included:

Added lualine.nvim for a better status line
Added bufferline.nvim for better buffer/tab management
Added noice.nvim for improved UI for messages and command line
Added alpha-nvim for a nice dashboard when opening Neovim
Added better indent guides with indent-blankline.nvim
Added lspkind.nvim for VS Code-like icons in completions

Key Bindings Summary:

Git operations: <leader>g prefix
LSP operations: <leader>l prefix
Code formatting: <leader>cf
File explorer: <leader>e
Telescope: <leader>f prefix

The configuration should work out of the box. Make sure to run :Lazy sync after updating the files to install all the new plugins.