" Set shell to bash
set shell=/bin/bash

" Set leader key
let mapleader = "\\"

" Ensure that packer.nvim is installed
lua << EOF
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
EOF

" Packer startup configuration
lua << EOF
require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'  -- Packer manages itself

  -- Essential plugins
  use 'nvim-lua/plenary.nvim'  -- Common utilities
  use 'nvim-lua/popup.nvim'    -- Popup API
  use 'kyazdani42/nvim-web-devicons'  -- File icons

  -- Mason and LSP
  use {
    'williamboman/mason.nvim',
    run = ":MasonUpdate"  -- Ensure Mason is up to date
  }
  use 'williamboman/mason-lspconfig.nvim'

  -- Lua language server setup
  use {
    'neovim/nvim-lspconfig',
    config = function()
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
    end
  }

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

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)
EOF

" Set colorscheme to ayu
let ayucolor="dark"  " Choose from 'dark', 'mirage', 'light'
colorscheme ayu

" Mason setup
lua << EOF
require("mason").setup()
require("mason-lspconfig").setup {
  ensure_installed = { "lua_ls" },  -- Ensures Lua language server is installed
}

-- Configure the Lua language server
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
EOF

" Treesitter configuration
lua << EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = "all",  -- Install all maintained parsers
  highlight = {
    enable = true,  -- false will disable the whole extension
  },
  indent = {
    enable = true,  -- Enable Treesitter-based indentation
  },
}
EOF

" Lualine configuration
lua << EOF
require('lualine').setup {
  options = {
    theme = 'ayu',  -- Use the ayu theme for lualine
    section_separators = {'', ''},
    component_separators = {'', ''},
  },
}
EOF

" Nvim-tree configuration
lua << EOF
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
EOF

" Gitsigns configuration
lua << EOF
-- Set up gitsigns.nvim with updated highlights
require('gitsigns').setup {
  signs = {
    add          = {text = '+'},
    change       = {text = '~'},
    delete       = {text = '_'},
    topdelete    = {text = '‾'},
    changedelete = {text = '~'},
  },
  -- other gitsigns configurations...
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
EOF
