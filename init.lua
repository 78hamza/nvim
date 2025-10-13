-- ======================
-- Basic settings
-- ======================
vim.g.mapleader = " "
vim.g.maplocalleader = " "

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

  -- ======================
  -- Colors / Themes
  -- ======================
  {
    "folke/tokyonight.nvim",
    "catppuccin/nvim",
    "ellisonleao/gruvbox.nvim",
    "Mofiqul/dracula.nvim",
    "EdenEast/nightfox.nvim",
    "navarasu/onedark.nvim",
    "shaunsingh/nord.nvim",
    "marko-cerovac/material.nvim",
    "projekt0n/github-nvim-theme",
    "neanias/everforest-nvim",

    lazy = false,
    priority = 1000,

    config = function()
      -- ======================
      -- 🎨 Choose your theme here
      -- ======================

        vim.cmd.colorscheme("tokyonight-night")   -- 🔵 Futuristic dark (modern)
       --vim.cmd.colorscheme("catppuccin")         -- 🩵 Pastel soft look (good for web)
       --vim.cmd.colorscheme("catppuccin-mocha")         -- 🩵 Pastel soft look (good for web)
       --vim.cmd.colorscheme("catppuccin-latte")         -- 🩵 Pastel soft look (good for web)
       --vim.cmd.colorscheme("catppuccin-macchiato")         -- 🩵 Pastel soft look (good for web)
      -- vim.cmd.colorscheme("gruvbox")            -- 🟤 Retro brown/yellow
      -- vim.cmd.colorscheme("kanagawa")           -- 🟠 Elegant Japanese-inspired
      -- vim.cmd.colorscheme("dracula")            -- 🟣 Classic dark purple
      -- vim.cmd.colorscheme("nightfox")           -- 🌌 Multiple variants
      -- vim.cmd.colorscheme("onedark")               -- ⚙️ Best for low-level coding
      -- vim.cmd.colorscheme("nord")               -- 🧊 Arctic blue, clean, calm
      -- vim.cmd.colorscheme("everforest")         -- 🌿 Nature green tones
      -- vim.cmd.colorscheme("material")           -- 🎨 Modern soft contrast
      -- vim.cmd.colorscheme("github_dark")        -- 💻 Familiar dev look
    end,
  },

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
          theme = 'auto', -- adapts automatically to colorscheme
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
        
        -- Enhanced LSP keymaps
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
        ensure_installed = {'lua_ls', 'pyright', 'clangd', 'bashls'},
        handlers = { lsp_zero.default_setup },
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

  -- Git signs
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup()
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
    end,
  },

  -- Additional useful plugins
  {
    -- Undo tree visualization
    "mbbill/undotree",
    config = function()
      vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "Toggle undo tree" })
    end,
  },

  {
    -- Better quickfix list
    "kevinhwang91/nvim-bqf",
    ft = "qf",
  },

  {
    -- Smooth scrolling
    "karb94/neoscroll.nvim",
    config = function()
      require("neoscroll").setup()
    end,
  },

  {
    -- Indent guides
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {}
  },

  {
    -- Better notifications
    "rcarriga/nvim-notify",
    config = function()
      vim.notify = require("notify")
    end,
  },
})

-- ======================
-- Enhanced Theme Management
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

-- ======================
-- Enhanced Key mappings
-- ======================
local keymap = vim.keymap.set

-- Basic navigation
keymap("i", "jk", "<ESC>", { desc = "Exit insert mode" })
keymap("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })

-- Window navigation (safe version)
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

-- ======================
-- Auto-Commands for Better Experience
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
-- Reload configuration without restarting
vim.api.nvim_create_user_command("ReloadConfig", function()
  for name,_ in pairs(package.loaded) do
    if name:match('^cnull') then
      package.loaded[name] = nil
    end
  end
  dofile(vim.env.MYVIMRC)
  vim.notify("Nvim configuration reloaded!", vim.log.levels.INFO)
end, { desc = "Reload Neovim configuration" })

print("🚀 Enhanced Neovim configuration loaded successfully!")
print("🎨 Use :ToggleTheme, :NextTheme, :PrevTheme to switch themes")
print("📋 Use :ReloadConfig to reload without restart")
