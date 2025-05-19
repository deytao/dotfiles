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

  -- Copilot
  use 'github/copilot.vim'

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
  use 'neovim/nvim-lspconfig'

  -- Autocompletion
  use 'hrsh7th/nvim-cmp'  -- Autocompletion plugin
  use 'hrsh7th/cmp-nvim-lsp'  -- LSP source for nvim-cmp
  use 'L3MON4D3/LuaSnip'  -- Snippet engine
  use 'saadparwaiz1/cmp_luasnip'  -- Snippet completions

  -- Treesitter for syntax highlighting
  use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}

  -- Treesitter textobjects
  use({
    "nvim-treesitter/nvim-treesitter-textobjects",
    after = "nvim-treesitter",
    requires = "nvim-treesitter/nvim-treesitter",
  })

  use 'nvim-telescope/telescope.nvim'  -- Telescope for fuzzy finding
  use 'kyazdani42/nvim-tree.lua'  -- File explorer
  use 'nvim-pack/nvim-spectre'  -- Search and replace

  -- Lualine for status line
  use 'nvim-lualine/lualine.nvim'

  -- Git integration
  use 'lewis6991/gitsigns.nvim'

  -- Misc plugins
  use 'alvan/vim-closetag'  -- Auto-close HTML tags
  use 'ayu-theme/ayu-vim'  -- Ayu color scheme
  use 'lukas-reineke/indent-blankline.nvim'  -- Show indent guides
  use 'kylechui/nvim-surround'  -- Surround plugin rewritten for Neovim
  use 'numToStr/Comment.nvim'  -- Equivalent of NERD Commenter


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

-- Surround setup
require("nvim-surround").setup()

-- Commenter
require("Comment").setup()

-- Mason setup
require("mason").setup()
require("mason-lspconfig").setup {
  ensure_installed = { "lua_ls", "pyright", "ruff" },  -- Ensure the LS servers are installed
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

-- PyRights
require('lspconfig').pyright.setup({
  root_dir = function(fname)
    -- Use the nearest git project or the current dir to determine the root
    return require('lspconfig.util').find_git_ancestor(fname) or vim.fn.getcwd()
  end,
  on_attach = function(client, bufnr)
    -- LSP key mappings
    local bufopts = { noremap=true, silent=true, buffer=bufnr }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, bufopts)
    vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
    vim.keymap.set('n', '<leader>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts)
    vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
    vim.keymap.set('n', '<leader>f', function()
      vim.lsp.buf.format { async = true }
    end, bufopts)
  end,

  -- Disable Pyright's built-in linting if you only want to use Ruff
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "off",  -- Disable type checking if not needed
        diagnosticMode = "workspace",  -- Change to "openFilesOnly" if preferred
        disableUnusedVariableDiagnostics = true,
      }
    }
  }
})

-- Ruff linter setup
require('lspconfig').ruff.setup{}

-- Rust
require('lspconfig').rust_analyzer.setup({
  on_attach = function(client, bufnr)
    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
  end,

  settings = {
    ["rust-analyzer"] = {
      imports = {
        granularity = {
            group = "module",
        },
        prefix = "self",
      },
      cargo = {
        buildScripts = {
            enable = true,
        },
      },
      procMacro = {
        enable = true
      },
    }
  }
})


-- Treesitter configuration
require('nvim-treesitter.configs').setup({
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
})

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
    width = 20,
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

-- Telescope configuragion
vim.api.nvim_set_keymap('n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>q', '<cmd>Telescope diagnostics<CR>', { noremap = true, silent = true })

-- Spectre configuration
require('spectre').setup({
    default = {
        find = {
            is_case_sensitive = true,
        },
    },
    mapping = {
        ['toggle_line'] = {
            map = "x",
            cmd = "<cmd>lua require('spectre').toggle_line()<CR>",
            desc = "toggle current item"
        },
        ['replace_cmd'] = {
            map = "<leader>r",
            cmd = "<cmd>lua require('spectre.actions').replace_cmd()<CR>",
            desc = "replace all"
        }
    },
})
vim.keymap.set('n', '<leader>S', '<cmd>lua require("spectre").toggle()<CR>', {
    desc = "Toggle Spectre"
})
vim.keymap.set('n', '<leader>sw', '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', {
    desc = "Search current word"
})
vim.keymap.set('v', '<leader>sw', '<esc><cmd>lua require("spectre").open_visual()<CR>', {
    desc = "Search current word"
})
vim.keymap.set('n', '<leader>sp', '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', {
    desc = "Search on current file"
})
