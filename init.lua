-- ======================
-- Basic settings
-- ======================
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Performance optimizations
vim.loader.enable()
vim.opt.ttimeoutlen = 0
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.lazyredraw = true
vim.opt.ttyfast = true

-- Set options
local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true
opt.wrap = false
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = false
opt.incsearch = true
opt.termguicolors = true
opt.scrolloff = 8
opt.signcolumn = "yes"
opt.isfname:append("@-@")
opt.updatetime = 50
opt.colorcolumn = "80"
opt.mouse = "a"
opt.clipboard = "unnamedplus"
vim.opt.sessionoptions:append("localoptions")
vim.opt.laststatus = 3
vim.opt.showtabline = 2
vim.opt.showmode = false

vim.cmd("filetype plugin indent on")

-- Better diagnostics configuration
vim.diagnostic.config({
  virtual_text = {
    prefix = '●',
    source = true,
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = 'rounded',
    source = true,
    header = '',
    prefix = '',
  },
})

-- ======================
-- Bootstrap lazy.nvim
-- ======================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- ======================
-- Plugin setup with lazy.nvim
-- ======================
require("lazy").setup({

  -- Auto-save
  {
    "pocco81/auto-save.nvim",
    config = function()
      require("auto-save").setup({
        enabled = true,
        execution_message = {
          message = function() return "💾 Auto-saved at " .. vim.fn.strftime("%H:%M:%S") end,
          dim = 0.18,
          cleaning_interval = 1250,
        },
        trigger_events = {"InsertLeave", "TextChanged"},
        conditions = { exists = true, modifiable = true },
        write_all_buffers = false,
        debounce_delay = 135,
      })
    end,
  },

  -- Session manager
  {
    "rmagatti/auto-session",
    config = function()
      require("auto-session").setup({
        log_level = "info",
        auto_session_suppress_dirs = { "~/", "~/Downloads", "/" },
        auto_session_enabled = true,
        auto_save_enabled = true,
        auto_restore_enabled = true,
      })
    end,
  },

  -- Toggle terminal
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup({
        size = 15,
        open_mapping = [[<c-\>]],
        shade_terminals = true,
        shading_factor = 2,
        direction = "float",
        float_opts = { border = "curved", winblend = 3 },
      })
    end,
  },

  -- Colors / Themes
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        style = "night",
        transparent = false,
        styles = {
          comments = { italic = true },
          keywords = { italic = true },
          functions = {},
          variables = {},
          sidebars = "dark",
          floats = "dark",
        },
      })
    end,
  },
  "catppuccin/nvim",
  "ellisonleao/gruvbox.nvim",
  "Mofiqul/dracula.nvim",
  "EdenEast/nightfox.nvim",
  "navarasu/onedark.nvim",
  "shaunsingh/nord.nvim",
  "marko-cerovac/material.nvim",
  "projekt0n/github-nvim-theme",
  "neanias/everforest-nvim",

  -- File explorer
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        view = { width = 30 },
        renderer = { group_empty = true },
        filters = { dotfiles = true },
      })
    end,
  },

  -- Statusline
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup({
        options = {
          theme = 'auto',
          section_separators = { left = '', right = '' },
          component_separators = { left = '', right = '' },
          globalstatus = true,
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = { 'branch', 'diff', 'diagnostics' },
          lualine_c = { { 'filename', path = 1 } },
          lualine_x = { 'encoding', 'fileformat', 'filetype' },
          lualine_y = { 'progress' },
          lualine_z = { 'location', 'os.date("%H:%M")' },
        },
      })
    end,
  },

  -- Bufferline
  {
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
      require("bufferline").setup({
        options = {
          diagnostics = "nvim_lsp",
          offsets = {
            {
              filetype = "NvimTree",
              text = "File Explorer",
              highlight = "Directory",
              separator = true
            }
          }
        }
      })
    end,
  },

  -- Telescope
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.6',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('telescope').setup({})
    end,
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "javascript", "html", "python", "cpp", "rust" },
        sync_install = false,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end
  },

  -- LSP Configuration
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    dependencies = {
      {'neovim/nvim-lspconfig'},
      {'williamboman/mason.nvim'},
      {'williamboman/mason-lspconfig.nvim'},
      {'hrsh7th/nvim-cmp'},
      {'hrsh7th/cmp-nvim-lsp'},
      {'hrsh7th/cmp-buffer'},
      {'hrsh7th/cmp-path'},
      {'saadparwaiz1/cmp_luasnip'},
      {'hrsh7th/cmp-nvim-lua'},
      {'L3MON4D3/LuaSnip'},
      {'rafamadriz/friendly-snippets'},
    },
    config = function()
      local lsp_zero = require('lsp-zero')

      lsp_zero.on_attach(function(client, bufnr)
        lsp_zero.default_keymaps({buffer = bufnr})
        
        local opts = {buffer = bufnr, remap = false}
        local keymap = vim.keymap.set
        
        keymap("n", "gd", function() vim.lsp.buf.definition() end, opts)
        keymap("n", "K", function() vim.lsp.buf.hover() end, opts)
        keymap("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
        keymap("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
        keymap("n", "[d", function() vim.diagnostic.goto_next() end, opts)
        keymap("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
        keymap("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
        keymap("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
        keymap("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
        keymap("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
      end)

      require('mason').setup({})
      require('mason-lspconfig').setup({
        ensure_installed = {
          'lua_ls',
          'pyright',
          'clangd',
          'bashls',
          'tsserver',
          'rust_analyzer',
          'gopls',
          'jsonls',
          'yamlls',
          'html',
          'cssls',
          'emmet_ls',
        },
        handlers = {
          lsp_zero.default_setup,
          ['rust_analyzer'] = function()
            require('lspconfig').rust_analyzer.setup({
              settings = {
                ['rust-analyzer'] = {
                  diagnostics = {
                    enable = true,
                  },
                },
              },
            })
          end,
        },
      })

      local cmp = require('cmp')
      cmp.setup({
        sources = {
          { name = 'path' },
          { name = 'nvim_lsp' },
          { name = 'buffer', keyword_length = 3 },
          { name = 'luasnip', keyword_length = 2 },
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          ['<C-y>'] = cmp.mapping.confirm({ select = true }),
          ['<C-Space>'] = cmp.mapping.complete(),
        }),
      })
    end,
  },

  -- LSP Saga for better UI
  {
    'glepnir/lspsaga.nvim',
    branch = 'main',
    config = function()
      require('lspsaga').setup({
        ui = {
          colors = {
            normal_bg = '#022c3a'
          }
        },
        symbol_in_winbar = {
          enable = false,
        },
        lightbulb = {
          enable = false,
        },
      })
      
      local keymap = vim.keymap.set
      keymap("n", "gr", "<cmd>Lspsaga finder<CR>", { desc = "Show references" })
      keymap("n", "gd", "<cmd>Lspsaga peek_definition<CR>", { desc = "Peek definition" })
      keymap("n", "gD", "<cmd>Lspsaga goto_definition<CR>", { desc = "Go to definition" })
      keymap("n", "K", "<cmd>Lspsaga hover_doc<CR>", { desc = "Hover documentation" })
      keymap("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", { desc = "Code action" })
      keymap("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", { desc = "Rename" })
    end,
  },

  -- Git signs
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup()
    end,
  },

  -- Git diff view
  {
    'sindrets/diffview.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('diffview').setup()
      vim.keymap.set('n', '<leader>gd', '<cmd>DiffviewOpen<CR>', { desc = 'Open diffview' })
      vim.keymap.set('n', '<leader>gc', '<cmd>DiffviewClose<CR>', { desc = 'Close diffview' })
      vim.keymap.set('n', '<leader>gh', '<cmd>DiffviewFileHistory<CR>', { desc = 'File history' })
    end,
  },

  -- Git link
  {
    'ruifm/gitlinker.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('gitlinker').setup()
      vim.keymap.set('n', '<leader>gy', '<cmd>GitLink<CR>', { desc = 'Copy git link' })
    end,
  },

  -- Auto pairs
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup {}
    end,
  },

  -- Comments
  {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end,
  },

  -- Which key
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    config = function()
      require("which-key").setup()
      
      local wk = require("which-key")
      wk.add({
        { "<leader>f", group = "Find" },
        { "<leader>w", group = "Window" },
        { "<leader>b", group = "Buffer" },
        { "<leader>g", group = "Git" },
        { "<leader>l", group = "LSP" },
        { "<leader>t", group = "Terminal/Task" },
        { "<leader>c", group = "Code" },
        { "<leader>p", group = "Plugin" },
      })
    end,
  },

  -- Undo tree
  {
    "mbbill/undotree",
    config = function()
      vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "Toggle undo tree" })
    end,
  },

  -- Better quickfix
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
  },

  -- Smooth scrolling
  {
    "karb94/neoscroll.nvim",
    config = function()
      require("neoscroll").setup()
    end,
  },

  -- Indent guides
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {}
  },

  -- Better notifications
  {
    "rcarriga/nvim-notify",
    config = function()
      vim.notify = require("notify")
    end,
  },

  -- Dashboard
  {
    'nvimdev/dashboard-nvim',
    event = 'VimEnter',
    config = function()
      require('dashboard').setup({
        theme = 'doom',
        config = {
          header = {
            '                               ',
            '    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣤⣶⣶⣿⣿⣿⣿⣶⣶⣤⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ',
            '    ⠀⠀⠀⠀⠀⠀⢀⣤⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣤⡀⠀⠀⠀⠀⠀ ',
            '    ⠀⠀⠀⠀⣠⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣄⠀⠀⠀ ',
            '    ⠀⠀⢠⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡀⠀ ',
            '    ⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡀ ',
            '    ⢠⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇ ',
            '    ⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇ ',
            '    ⠸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠃ ',
            '    ⠀⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠀ ',
            '    ⠀⠈⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠃⠀ ',
            '    ⠀⠀⠈⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠋⠀⠀⠀ ',
            '    ⠀⠀⠀⠀⠈⠙⠻⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠛⠁⠀⠀⠀⠀ ',
            '    ⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠛⠿⠿⣿⣿⣿⣿⡿⠿⠟⠛⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀ ',
            '                               ',
            '          🚀 NEOVIM 🚀          ',
          },
          center = {
            {
              icon = '📂 ',
              desc = 'Find File           ',
              action = 'Telescope find_files',
            },
            {
              icon = '🔍 ',
              desc = 'Find Text           ',
              action = 'Telescope live_grep',
            },
            {
              icon = '📝 ',
              desc = 'Recent Files        ',
              action = 'Telescope oldfiles',
            },
            {
              icon = '⚙️  ',
              desc = 'Settings            ',
              action = 'edit ~/.config/nvim/init.lua',
            },
          },
          footer = function()
            local stats = require('lazy').stats()
            local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
            return { '⚡ ' .. stats.loaded .. '/' .. stats.count .. ' plugins loaded in ' .. ms .. 'ms' }
          end,
        },
      })
    end,
    dependencies = { {'nvim-tree/nvim-web-devicons'} }
  },

  -- Code formatting
  {
    'stevearc/conform.nvim',
    opts = {},
    config = function()
      require('conform').setup({
        formatters_by_ft = {
          lua = { 'stylua' },
          python = { 'black' },
          javascript = { 'prettierd', 'prettier' },
          typescript = { 'prettierd', 'prettier' },
          json = { 'prettierd', 'prettier' },
          yaml = { 'prettierd', 'prettier' },
          markdown = { 'prettierd', 'prettier' },
          go = { 'gofmt', 'goimports' },
          rust = { 'rustfmt' },
          sh = { 'shfmt' },
        },
        format_on_save = {
          timeout_ms = 500,
          lsp_fallback = true,
        },
      })
      
      vim.keymap.set('n', '<leader>f', function()
        require('conform').format({ lsp_fallback = true })
      end, { desc = 'Format file' })
    end,
  },

  -- Task runner
  {
    'stevearc/overseer.nvim',
    config = function()
      require('overseer').setup()
      vim.keymap.set('n', '<leader>tr', '<cmd>OverseerRun<CR>', { desc = 'Run task' })
      vim.keymap.set('n', '<leader>tt', '<cmd>OverseerToggle<CR>', { desc = 'Toggle task list' })
      vim.keymap.set('n', '<leader>tb', '<cmd>OverseerBuild<CR>', { desc = 'Build task' })
    end,
  },

  -- Markdown preview
  {
    'iamcco/markdown-preview.nvim',
    build = 'cd app && npm install',
    ft = 'markdown',
    config = function()
      vim.keymap.set('n', '<leader>mp', '<cmd>MarkdownPreview<CR>', { desc = 'Markdown preview' })
    end,
  },

  -- Color picker
  {
    'ziontee113/color-picker.nvim',
    config = function()
      require('color-picker').setup()
      vim.keymap.set('n', '<leader>cp', '<cmd>PickColor<CR>', { desc = 'Pick color' })
      vim.keymap.set('n', '<leader>cc', '<cmd>PickColorInsert<CR>', { desc = 'Pick color (insert)' })
    end,
  },
})

-- ======================
-- Theme Management
-- ======================
local themes = {
  "tokyonight-night",
  "catppuccin", 
  "gruvbox",
  "onedark",
  "nord"
}

local current_theme_index = 1

vim.api.nvim_create_user_command("ToggleTheme", function()
  current_theme_index = current_theme_index % #themes + 1
  vim.cmd.colorscheme(themes[current_theme_index])
  vim.notify("Switched to: " .. themes[current_theme_index])
end, { desc = "Cycle through themes" })

vim.api.nvim_create_user_command("NextTheme", function()
  current_theme_index = current_theme_index % #themes + 1
  vim.cmd.colorscheme(themes[current_theme_index])
  vim.notify("Theme: " .. themes[current_theme_index])
end, { desc = "Next theme" })

vim.api.nvim_create_user_command("PrevTheme", function()
  current_theme_index = (current_theme_index - 2) % #themes + 1
  vim.cmd.colorscheme(themes[current_theme_index])
  vim.notify("Theme: " .. themes[current_theme_index])
end, { desc = "Previous theme" })

-- Set default theme
vim.cmd.colorscheme("tokyonight-night")

-- ======================
-- Key mappings
-- ======================
local keymap = vim.keymap.set

-- Basic navigation
keymap("i", "jk", "<ESC>", { desc = "Exit insert mode" })
keymap("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })

-- Window navigation
keymap("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
keymap("n", "<C-j>", "<C-w>j", { desc = "Move to lower window" })
keymap("n", "<C-k>", "<C-w>k", { desc = "Move to upper window" })
keymap("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Enhanced window management
keymap("n", "<leader>ww", "<C-W>p", { desc = "Other window" })
keymap("n", "<leader>wd", "<C-W>c", { desc = "Delete window" })
keymap("n", "<leader>w-", "<C-W>s", { desc = "Split window below" })
keymap("n", "<leader>w|", "<C-W>v", { desc = "Split window right" })
keymap("n", "<leader>wv", "<C-w>v", { desc = "Vertical split" })
keymap("n", "<leader>wh", "<C-w>s", { desc = "Horizontal split" })

-- Buffer management
keymap("n", "<leader>bp", "<cmd>BufferLinePick<CR>", { desc = "Pick buffer" })
keymap("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete buffer" })

-- Telescope
keymap("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Find files" })
keymap("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "Live grep" })
keymap("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Find buffers" })
keymap("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "Help tags" })

-- Terminal
keymap("n", "<leader>to", "<cmd>ToggleTerm<CR>", { desc = "Toggle terminal" })

-- Quality of life
keymap("n", "<leader>nh", "<cmd>nohl<CR>", { desc = "Clear search highlights" })
keymap("n", "<C-s>", "<cmd>w<CR>", { desc = "Save file" })
keymap("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Search and replace word" })

-- Diagnostic keymaps
keymap('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic' })
keymap('n', '[d', vim.diagnostic.goto_prev, { desc = 'Previous diagnostic' })
keymap('n', ']d', vim.diagnostic.goto_next, { desc = 'Next diagnostic' })
keymap('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Diagnostic loclist' })

-- ======================
-- Auto-Commands
-- ======================
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking text",
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  desc = "Auto create directories when saving a file",
  group = vim.api.nvim_create_augroup("auto-create-dir", { clear = true }),
  callback = function(event)
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- ======================
-- Custom Functions
-- ======================
vim.api.nvim_create_user_command("ReloadConfig", function()
  for name,_ in pairs(package.loaded) do
    if name:match('^cnull') then
      package.loaded[name] = nil
    end
  end
  dofile(vim.env.MYVIMRC)
  vim.notify("Nvim configuration reloaded!", vim.log.levels.INFO)
end, { desc = "Reload Neovim configuration" })

local function welcome_message()
  local version = vim.version()
  local plugins = require('lazy').stats()
  local ms = (math.floor(plugins.startuptime * 100 + 0.5) / 100)
  
  local messages = {
    "🚀 Welcome to Neovim " .. version.major .. "." .. version.minor .. "." .. version.patch,
    "📦 " .. plugins.loaded .. " plugins loaded in " .. ms .. "ms",
    "🎨 Use :ToggleTheme to cycle through themes",
    "📋 Use :ReloadConfig to reload without restart",
    "💡 Press <leader>ff to find files",
  }
  
  for _, msg in ipairs(messages) do
    vim.notify(msg, vim.log.levels.INFO, { title = "Neovim" })
  end
end

-- Show welcome message after startup
vim.defer_fn(welcome_message, 100)-- ======================
-- Basic settings
-- ======================
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Performance optimizations
vim.loader.enable()
vim.opt.ttimeoutlen = 0
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.lazyredraw = true
vim.opt.ttyfast = true

-- Set options
local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true
opt.wrap = false
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = false
opt.incsearch = true
opt.termguicolors = true
opt.scrolloff = 8
opt.signcolumn = "yes"
opt.isfname:append("@-@")
opt.updatetime = 50
opt.colorcolumn = "80"
opt.mouse = "a"
opt.clipboard = "unnamedplus"
vim.opt.sessionoptions:append("localoptions")
vim.opt.laststatus = 3
vim.opt.showtabline = 2
vim.opt.showmode = false

vim.cmd("filetype plugin indent on")

-- Better diagnostics configuration
vim.diagnostic.config({
  virtual_text = {
    prefix = '●',
    source = true,
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = 'rounded',
    source = true,
    header = '',
    prefix = '',
  },
})

-- ======================
-- Bootstrap lazy.nvim
-- ======================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- ======================
-- Plugin setup with lazy.nvim
-- ======================
require("lazy").setup({

  -- Auto-save
  {
    "pocco81/auto-save.nvim",
    config = function()
      require("auto-save").setup({
        enabled = true,
        execution_message = {
          message = function() return "💾 Auto-saved at " .. vim.fn.strftime("%H:%M:%S") end,
          dim = 0.18,
          cleaning_interval = 1250,
        },
        trigger_events = {"InsertLeave", "TextChanged"},
        conditions = { exists = true, modifiable = true },
        write_all_buffers = false,
        debounce_delay = 135,
      })
    end,
  },

  -- Session manager
  {
    "rmagatti/auto-session",
    config = function()
      require("auto-session").setup({
        log_level = "info",
        auto_session_suppress_dirs = { "~/", "~/Downloads", "/" },
        auto_session_enabled = true,
        auto_save_enabled = true,
        auto_restore_enabled = true,
      })
    end,
  },

  -- Toggle terminal
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup({
        size = 15,
        open_mapping = [[<c-\>]],
        shade_terminals = true,
        shading_factor = 2,
        direction = "float",
        float_opts = { border = "curved", winblend = 3 },
      })
    end,
  },

  -- Colors / Themes
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        style = "night",
        transparent = false,
        styles = {
          comments = { italic = true },
          keywords = { italic = true },
          functions = {},
          variables = {},
          sidebars = "dark",
          floats = "dark",
        },
      })
    end,
  },
  "catppuccin/nvim",
  "ellisonleao/gruvbox.nvim",
  "Mofiqul/dracula.nvim",
  "EdenEast/nightfox.nvim",
  "navarasu/onedark.nvim",
  "shaunsingh/nord.nvim",
  "marko-cerovac/material.nvim",
  "projekt0n/github-nvim-theme",
  "neanias/everforest-nvim",

  -- File explorer
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        view = { width = 30 },
        renderer = { group_empty = true },
        filters = { dotfiles = true },
      })
    end,
  },

  -- Statusline
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup({
        options = {
          theme = 'auto',
          section_separators = { left = '', right = '' },
          component_separators = { left = '', right = '' },
          globalstatus = true,
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = { 'branch', 'diff', 'diagnostics' },
          lualine_c = { { 'filename', path = 1 } },
          lualine_x = { 'encoding', 'fileformat', 'filetype' },
          lualine_y = { 'progress' },
          lualine_z = { 'location', 'os.date("%H:%M")' },
        },
      })
    end,
  },

  -- Bufferline
  {
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
      require("bufferline").setup({
        options = {
          diagnostics = "nvim_lsp",
          offsets = {
            {
              filetype = "NvimTree",
              text = "File Explorer",
              highlight = "Directory",
              separator = true
            }
          }
        }
      })
    end,
  },

  -- Telescope
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.6',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('telescope').setup({})
    end,
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "javascript", "html", "python", "cpp", "rust" },
        sync_install = false,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end
  },

  -- LSP Configuration
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    dependencies = {
      {'neovim/nvim-lspconfig'},
      {'williamboman/mason.nvim'},
      {'williamboman/mason-lspconfig.nvim'},
      {'hrsh7th/nvim-cmp'},
      {'hrsh7th/cmp-nvim-lsp'},
      {'hrsh7th/cmp-buffer'},
      {'hrsh7th/cmp-path'},
      {'saadparwaiz1/cmp_luasnip'},
      {'hrsh7th/cmp-nvim-lua'},
      {'L3MON4D3/LuaSnip'},
      {'rafamadriz/friendly-snippets'},
    },
    config = function()
      local lsp_zero = require('lsp-zero')

      lsp_zero.on_attach(function(client, bufnr)
        lsp_zero.default_keymaps({buffer = bufnr})
        
        local opts = {buffer = bufnr, remap = false}
        local keymap = vim.keymap.set
        
        keymap("n", "gd", function() vim.lsp.buf.definition() end, opts)
        keymap("n", "K", function() vim.lsp.buf.hover() end, opts)
        keymap("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
        keymap("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
        keymap("n", "[d", function() vim.diagnostic.goto_next() end, opts)
        keymap("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
        keymap("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
        keymap("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
        keymap("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
        keymap("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
      end)

      require('mason').setup({})
      require('mason-lspconfig').setup({
        ensure_installed = {
          'lua_ls',
          'pyright',
          'clangd',
          'bashls',
          'tsserver',
          'rust_analyzer',
          'gopls',
          'jsonls',
          'yamlls',
          'html',
          'cssls',
          'emmet_ls',
        },
        handlers = {
          lsp_zero.default_setup,
          ['rust_analyzer'] = function()
            require('lspconfig').rust_analyzer.setup({
              settings = {
                ['rust-analyzer'] = {
                  diagnostics = {
                    enable = true,
                  },
                },
              },
            })
          end,
        },
      })

      local cmp = require('cmp')
      cmp.setup({
        sources = {
          { name = 'path' },
          { name = 'nvim_lsp' },
          { name = 'buffer', keyword_length = 3 },
          { name = 'luasnip', keyword_length = 2 },
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          ['<C-y>'] = cmp.mapping.confirm({ select = true }),
          ['<C-Space>'] = cmp.mapping.complete(),
        }),
      })
    end,
  },

  -- LSP Saga for better UI
  {
    'glepnir/lspsaga.nvim',
    branch = 'main',
    config = function()
      require('lspsaga').setup({
        ui = {
          colors = {
            normal_bg = '#022c3a'
          }
        },
        symbol_in_winbar = {
          enable = false,
        },
        lightbulb = {
          enable = false,
        },
      })
      
      local keymap = vim.keymap.set
      keymap("n", "gr", "<cmd>Lspsaga finder<CR>", { desc = "Show references" })
      keymap("n", "gd", "<cmd>Lspsaga peek_definition<CR>", { desc = "Peek definition" })
      keymap("n", "gD", "<cmd>Lspsaga goto_definition<CR>", { desc = "Go to definition" })
      keymap("n", "K", "<cmd>Lspsaga hover_doc<CR>", { desc = "Hover documentation" })
      keymap("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", { desc = "Code action" })
      keymap("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", { desc = "Rename" })
    end,
  },

  -- Git signs
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup()
    end,
  },

  -- Git diff view
  {
    'sindrets/diffview.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('diffview').setup()
      vim.keymap.set('n', '<leader>gd', '<cmd>DiffviewOpen<CR>', { desc = 'Open diffview' })
      vim.keymap.set('n', '<leader>gc', '<cmd>DiffviewClose<CR>', { desc = 'Close diffview' })
      vim.keymap.set('n', '<leader>gh', '<cmd>DiffviewFileHistory<CR>', { desc = 'File history' })
    end,
  },

  -- Git link
  {
    'ruifm/gitlinker.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('gitlinker').setup()
      vim.keymap.set('n', '<leader>gy', '<cmd>GitLink<CR>', { desc = 'Copy git link' })
    end,
  },

  -- Auto pairs
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup {}
    end,
  },

  -- Comments
  {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end,
  },

  -- Which key
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    config = function()
      require("which-key").setup()
      
      local wk = require("which-key")
      wk.add({
        { "<leader>f", group = "Find" },
        { "<leader>w", group = "Window" },
        { "<leader>b", group = "Buffer" },
        { "<leader>g", group = "Git" },
        { "<leader>l", group = "LSP" },
        { "<leader>t", group = "Terminal/Task" },
        { "<leader>c", group = "Code" },
        { "<leader>p", group = "Plugin" },
      })
    end,
  },

  -- Undo tree
  {
    "mbbill/undotree",
    config = function()
      vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "Toggle undo tree" })
    end,
  },

  -- Better quickfix
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
  },

  -- Smooth scrolling
  {
    "karb94/neoscroll.nvim",
    config = function()
      require("neoscroll").setup()
    end,
  },

  -- Indent guides
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {}
  },

  -- Better notifications
  {
    "rcarriga/nvim-notify",
    config = function()
      vim.notify = require("notify")
    end,
  },

  -- Dashboard
  {
    'nvimdev/dashboard-nvim',
    event = 'VimEnter',
    config = function()
      require('dashboard').setup({
        theme = 'doom',
        config = {
          header = {
            '                               ',
            '    ⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣤⣶⣶⣿⣿⣿⣿⣶⣶⣤⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀ ',
            '    ⠀⠀⠀⠀⠀⠀⢀⣤⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣤⡀⠀⠀⠀⠀⠀ ',
            '    ⠀⠀⠀⠀⣠⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣄⠀⠀⠀ ',
            '    ⠀⠀⢠⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡀⠀ ',
            '    ⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡀ ',
            '    ⢠⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇ ',
            '    ⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇ ',
            '    ⠸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠃ ',
            '    ⠀⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠀ ',
            '    ⠀⠈⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠃⠀ ',
            '    ⠀⠀⠈⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠋⠀⠀⠀ ',
            '    ⠀⠀⠀⠀⠈⠙⠻⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠛⠁⠀⠀⠀⠀ ',
            '    ⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠛⠿⠿⣿⣿⣿⣿⡿⠿⠟⠛⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀ ',
            '                               ',
            '          🚀 NEOVIM 🚀          ',
          },
          center = {
            {
              icon = '📂 ',
              desc = 'Find File           ',
              action = 'Telescope find_files',
            },
            {
              icon = '🔍 ',
              desc = 'Find Text           ',
              action = 'Telescope live_grep',
            },
            {
              icon = '📝 ',
              desc = 'Recent Files        ',
              action = 'Telescope oldfiles',
            },
            {
              icon = '⚙️  ',
              desc = 'Settings            ',
              action = 'edit ~/.config/nvim/init.lua',
            },
          },
          footer = function()
            local stats = require('lazy').stats()
            local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
            return { '⚡ ' .. stats.loaded .. '/' .. stats.count .. ' plugins loaded in ' .. ms .. 'ms' }
          end,
        },
      })
    end,
    dependencies = { {'nvim-tree/nvim-web-devicons'} }
  },

  -- Code formatting
  {
    'stevearc/conform.nvim',
    opts = {},
    config = function()
      require('conform').setup({
        formatters_by_ft = {
          lua = { 'stylua' },
          python = { 'black' },
          javascript = { 'prettierd', 'prettier' },
          typescript = { 'prettierd', 'prettier' },
          json = { 'prettierd', 'prettier' },
          yaml = { 'prettierd', 'prettier' },
          markdown = { 'prettierd', 'prettier' },
          go = { 'gofmt', 'goimports' },
          rust = { 'rustfmt' },
          sh = { 'shfmt' },
        },
        format_on_save = {
          timeout_ms = 500,
          lsp_fallback = true,
        },
      })
      
      vim.keymap.set('n', '<leader>f', function()
        require('conform').format({ lsp_fallback = true })
      end, { desc = 'Format file' })
    end,
  },

  -- Task runner
  {
    'stevearc/overseer.nvim',
    config = function()
      require('overseer').setup()
      vim.keymap.set('n', '<leader>tr', '<cmd>OverseerRun<CR>', { desc = 'Run task' })
      vim.keymap.set('n', '<leader>tt', '<cmd>OverseerToggle<CR>', { desc = 'Toggle task list' })
      vim.keymap.set('n', '<leader>tb', '<cmd>OverseerBuild<CR>', { desc = 'Build task' })
    end,
  },

  -- Markdown preview
  {
    'iamcco/markdown-preview.nvim',
    build = 'cd app && npm install',
    ft = 'markdown',
    config = function()
      vim.keymap.set('n', '<leader>mp', '<cmd>MarkdownPreview<CR>', { desc = 'Markdown preview' })
    end,
  },

  -- Color picker
  {
    'ziontee113/color-picker.nvim',
    config = function()
      require('color-picker').setup()
      vim.keymap.set('n', '<leader>cp', '<cmd>PickColor<CR>', { desc = 'Pick color' })
      vim.keymap.set('n', '<leader>cc', '<cmd>PickColorInsert<CR>', { desc = 'Pick color (insert)' })
    end,
  },
})

-- ======================
-- Theme Management
-- ======================
local themes = {
  "tokyonight-night",
  "catppuccin", 
  "gruvbox",
  "onedark",
  "nord"
}

local current_theme_index = 1

vim.api.nvim_create_user_command("ToggleTheme", function()
  current_theme_index = current_theme_index % #themes + 1
  vim.cmd.colorscheme(themes[current_theme_index])
  vim.notify("Switched to: " .. themes[current_theme_index])
end, { desc = "Cycle through themes" })

vim.api.nvim_create_user_command("NextTheme", function()
  current_theme_index = current_theme_index % #themes + 1
  vim.cmd.colorscheme(themes[current_theme_index])
  vim.notify("Theme: " .. themes[current_theme_index])
end, { desc = "Next theme" })

vim.api.nvim_create_user_command("PrevTheme", function()
  current_theme_index = (current_theme_index - 2) % #themes + 1
  vim.cmd.colorscheme(themes[current_theme_index])
  vim.notify("Theme: " .. themes[current_theme_index])
end, { desc = "Previous theme" })

-- Set default theme
vim.cmd.colorscheme("tokyonight-night")

-- ======================
-- Key mappings
-- ======================
local keymap = vim.keymap.set

-- Basic navigation
keymap("i", "jk", "<ESC>", { desc = "Exit insert mode" })
keymap("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })

-- Window navigation
keymap("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
keymap("n", "<C-j>", "<C-w>j", { desc = "Move to lower window" })
keymap("n", "<C-k>", "<C-w>k", { desc = "Move to upper window" })
keymap("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Enhanced window management
keymap("n", "<leader>ww", "<C-W>p", { desc = "Other window" })
keymap("n", "<leader>wd", "<C-W>c", { desc = "Delete window" })
keymap("n", "<leader>w-", "<C-W>s", { desc = "Split window below" })
keymap("n", "<leader>w|", "<C-W>v", { desc = "Split window right" })
keymap("n", "<leader>wv", "<C-w>v", { desc = "Vertical split" })
keymap("n", "<leader>wh", "<C-w>s", { desc = "Horizontal split" })

-- Buffer management
keymap("n", "<leader>bp", "<cmd>BufferLinePick<CR>", { desc = "Pick buffer" })
keymap("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete buffer" })

-- Telescope
keymap("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Find files" })
keymap("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "Live grep" })
keymap("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Find buffers" })
keymap("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "Help tags" })

-- Terminal
keymap("n", "<leader>to", "<cmd>ToggleTerm<CR>", { desc = "Toggle terminal" })

-- Quality of life
keymap("n", "<leader>nh", "<cmd>nohl<CR>", { desc = "Clear search highlights" })
keymap("n", "<C-s>", "<cmd>w<CR>", { desc = "Save file" })
keymap("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Search and replace word" })

-- Diagnostic keymaps
keymap('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic' })
keymap('n', '[d', vim.diagnostic.goto_prev, { desc = 'Previous diagnostic' })
keymap('n', ']d', vim.diagnostic.goto_next, { desc = 'Next diagnostic' })
keymap('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Diagnostic loclist' })

-- ======================
-- Auto-Commands
-- ======================
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking text",
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  desc = "Auto create directories when saving a file",
  group = vim.api.nvim_create_augroup("auto-create-dir", { clear = true }),
  callback = function(event)
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- ======================
-- Custom Functions
-- ======================
vim.api.nvim_create_user_command("ReloadConfig", function()
  for name,_ in pairs(package.loaded) do
    if name:match('^cnull') then
      package.loaded[name] = nil
    end
  end
  dofile(vim.env.MYVIMRC)
  vim.notify("Nvim configuration reloaded!", vim.log.levels.INFO)
end, { desc = "Reload Neovim configuration" })

local function welcome_message()
  local version = vim.version()
  local plugins = require('lazy').stats()
  local ms = (math.floor(plugins.startuptime * 100 + 0.5) / 100)
  
  local messages = {
    "🚀 Welcome to Neovim " .. version.major .. "." .. version.minor .. "." .. version.patch,
    "📦 " .. plugins.loaded .. " plugins loaded in " .. ms .. "ms",
    "🎨 Use :ToggleTheme to cycle through themes",
    "📋 Use :ReloadConfig to reload without restart",
    "💡 Press <leader>ff to find files",
  }
  
  for _, msg in ipairs(messages) do
    vim.notify(msg, vim.log.levels.INFO, { title = "Neovim" })
  end
end

-- Show welcome message after startup
vim.defer_fn(welcome_message, 100)
