-- Ensure that packer.nvim is installed
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

-- Packer startup configuration
require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'  -- Packer manages itself

  -- Essential plugins
  use 'nvim-lua/plenary.nvim'  -- Common utilities
  use 'nvim-lua/popup.nvim'    -- Popup API
  use 'kyazdani42/nvim-web-devicons'  -- File icons

  -- Mason and LSP setup
  use {
    'williamboman/mason.nvim',
    run = ":MasonUpdate"  -- Ensure Mason is up to date
  }
  use 'williamboman/mason-lspconfig.nvim'
  use 'neovim/nvim-lspconfig'  -- Configurations for Nvim LSP

  -- Autocompletion
  use 'hrsh7th/nvim-cmp'  -- Autocompletion plugin
  use 'hrsh7th/cmp-nvim-lsp'  -- LSP source for nvim-cmp
  use 'L3MON4D3/LuaSnip'  -- Snippet engine
  use 'saadparwaiz1/cmp_luasnip'  -- Snippet completions

  -- Treesitter for syntax highlighting
  use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}

  -- Telescope for fuzzy finding
  use 'nvim-telescope/telescope.nvim'

  -- Lualine for status line
  use 'nvim-lualine/lualine.nvim'

  -- File explorer
  use 'kyazdani42/nvim-tree.lua'

  -- Git integration
  use 'lewis6991/gitsigns.nvim'

  -- Misc plugins
  use 'alvan/vim-closetag'  -- Auto-close HTML tags
  use 'ayu-theme/ayu-vim'  -- Ayu color scheme
  use 'lukas-reineke/indent-blankline.nvim'  -- Show indent guides
  use 'tpope/vim-fugitive'  -- Git commands in nvim
  use 'kylechui/nvim-surround'  -- Surround plugin rewritten for Neovim

  if packer_bootstrap then
    require('packer').sync()
  end
end)

-- Basic Vim settings (original settings from init.vim)
vim.opt.number = true            -- Show line numbers
vim.opt.relativenumber = true    -- Show relative line numbers
vim.opt.wrap = false             -- Disable line wrapping
vim.opt.expandtab = true         -- Use spaces instead of tabs
vim.opt.shiftwidth = 4           -- Number of spaces to use for each step of (auto)indent
vim.opt.tabstop = 4              -- Number of spaces tabs count for
vim.opt.smartindent = true       -- Enable smart indentation
vim.opt.mouse = 'a'              -- Enable mouse support
vim.opt.clipboard = 'unnamedplus'-- Use system clipboard
vim.opt.swapfile = false         -- Disable swap file creation
vim.opt.backup = false           -- Disable backup file creation
vim.opt.undofile = true          -- Enable persistent undo
vim.opt.termguicolors = true     -- Enable true color support

-- Set colorscheme to ayu
vim.g.ayucolor = "dark"  -- Choose from 'dark', 'mirage', 'light'
vim.cmd[[colorscheme ayu]]

-- Mason setup
require("mason").setup()
require("mason-lspconfig").setup {
  ensure_installed = { "lua_ls" },  -- Ensure the Lua language server is installed
}

-- Lua language server setup
require('lspconfig').lua_ls.setup{
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
        path = vim.split(package.path, ';'),
      },
      diagnostics = {
        globals = {'vim'},
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
      },
      telemetry = {
        enable = false,
      },
    },
  },
}

-- Treesitter configuration
require'nvim-treesitter.configs'.setup {
  ensure_installed = "all",  -- Install all maintained parsers
  highlight = {
    enable = true,  -- Enable syntax highlighting
  },
  indent = {
    enable = true,  -- Enable Treesitter-based indentation
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
      },
    },
  },
}

-- Lualine configuration
require('lualine').setup {
  options = {
    theme = 'ayu',  -- Use the ayu theme for lualine
    section_separators = {'', ''},
    component_separators = {'', ''},
  },
}

-- Nvim-tree configuration
require('nvim-tree').setup {
  hijack_netrw = true,
  auto_reload_on_write = true,
  open_on_tab = false,
  hijack_cursor = false,
  update_cwd = true,
  diagnostics = {
    enable = true,
    show_on_dirs = true,
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
    },
  },
  update_focused_file = {
    enable = true,
    update_cwd = true,
    ignore_list = {},
  },
  view = {
    width = 30,
    side = "left",
    preserve_window_proportions = true,
    number = false,
    relativenumber = false,
  },
}

-- Gitsigns configuration
require('gitsigns').setup {
  signs = {
    add          = {text = '+'},
    change       = {text = '~'},
    delete       = {text = '_'},
    topdelete    = {text = '‾'},
    changedelete = {text = '~'},
  },
}

-- Set the highlights for gitsigns
vim.api.nvim_set_hl(0, 'GitSignsAdd', {link = 'GitGutterAdd'})
vim.api.nvim_set_hl(0, 'GitSignsAddLn', {link = 'GitGutterAdd'})
vim.api.nvim_set_hl(0, 'GitSignsAddNr', {link = 'GitGutterAdd'})
vim.api.nvim_set_hl(0, 'GitSignsChange', {link = 'GitGutterChange'})
vim.api.nvim_set_hl(0, 'GitSignsChangeLn', {link = 'GitGutterChange'})
vim.api.nvim_set_hl(0, 'GitSignsChangeNr', {link = 'GitGutterChange'})
vim.api.nvim_set_hl(0, 'GitSignsChangedelete', {link = 'GitGutterChange'})
vim.api.nvim_set_hl(0, 'GitSignsChangedeleteLn', {link = 'GitGutterChange'})
vim.api.nvim_set_hl(0, 'GitSignsChangedeleteNr', {link = 'GitGutterChange'})
vim.api.nvim_set_hl(0, 'GitSignsDelete', {link = 'GitGutterDelete'})
vim.api.nvim_set_hl(0, 'GitSignsDeleteLn', {link = 'GitGutterDelete'})
vim.api.nvim_set_hl(0, 'GitSignsDeleteNr', {link = 'GitGutterDelete'})
vim.api.nvim_set_hl(0, 'GitSignsTopdelete', {link = 'GitGutterDeleteChange'})
vim.api.nvim_set_hl(0, 'GitSignsTopdeleteLn', {link = 'GitGutterDeleteChange'})
vim.api.nvim_set_hl(0, 'GitSignsTopdeleteNr', {link = 'GitGutterDeleteChange'})
