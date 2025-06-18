-- Ensure lazy.nvim is installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Plugin setup using lazy.nvim
require("lazy").setup({
  -- Lazy.nvim manages itself
  { "folke/lazy.nvim" },

  -- Copilot
  {
    "github/copilot.vim",
  },

  -- Essential utilities
  { "nvim-lua/plenary.nvim" },
  { "nvim-lua/popup.nvim" },

  -- Icons
  { "kyazdani42/nvim-web-devicons" },

  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      { "L3MON4D3/LuaSnip", event = "InsertEnter" },
      { "saadparwaiz1/cmp_luasnip" },
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }),
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
      })
    end,
  },

  -- LSP ecosystem
  {
    "mason-org/mason.nvim",
    event = "BufRead",
    build = ":MasonUpdate",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = { "mason-org/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "ruff" },
        handlers = {
          function(server_name)
            if server_name ~= "pyright" then
              require("lspconfig")[server_name].setup({})
            end
          end,
          lua_ls = function()
            require("lspconfig").lua_ls.setup({
              settings = {
                Lua = {
                  runtime = { version = "LuaJIT" },
                  diagnostics = { globals = { "vim" } },
                  workspace = { library = vim.api.nvim_get_runtime_file("", true) },
                  telemetry = { enable = false },
                },
              },
            })
          end,
          pyright = function()
            local util = require("lspconfig.util")
            local pyright_config_files = {
              ".pyrightconfig.json",
              "pyrightconfig.json",
            }
            local function has_pyright_config(root_dir)
              for _, fname in ipairs(pyright_config_files) do
                if util.path.exists(util.path.join(root_dir, fname)) then
                  return true
                end
              end
              return false
            end
            require("lspconfig").pyright.setup({
              on_new_config = function(new_config, root_dir)
                if not has_pyright_config(root_dir) then
                  new_config.enabled = false
                end
              end,
              capabilities = vim.lsp.protocol.make_client_capabilities(),
              settings = {
                python = {
                  analysis = {
                    typeCheckingMode = "off",
                    diagnosticMode = "workspace",
                    disableUnusedVariableDiagnostics = true,
                  },
                },
              },
            })
          end,
          ruff = function()
            require("lspconfig").ruff.setup({
              root_dir = require("lspconfig.util").root_pattern("pyproject.toml", ".git"),
              capabilities = vim.lsp.protocol.make_client_capabilities(),
            })
          end,
        },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    event = "BufRead",
  },
  {
    "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    dependencies = { "neovim/nvim-lspconfig" },
    config = function()
      require("lsp_lines").setup()
      vim.diagnostic.config({
        virtual_text = false,
        virtual_lines = true,
      })
    end,
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = "BufRead",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "lua", "python", "bash", "json", "yaml", "markdown", "html", "css", "javascript", "typescript" },
        highlight = { enable = true },
        indent = { enable = true },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "gnn",
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm",
          },
        },
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    keys = { "af", "if", "ac", "ic" },
  },

  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = { "nvim-lua/plenary.nvim" },
  },

  -- File tree
  {
    "kyazdani42/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFindFile" },
    config = function()
      require("nvim-tree").setup({
        hijack_netrw = true,
        diagnostics = {
          enable = true,
          icons = {
            hint = "",
            info = "",
            warning = "",
            error = "",
          },
        },
        view = { width = 20, preserve_window_proportions = true },
      })
    end,
  },

  -- Search/replace
  {
    "nvim-pack/nvim-spectre",
    keys = { "<leader>S", "<leader>sw", "<leader>sp" },
    config = function()
      require("spectre").setup()
    end,
  },

  -- Status line
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require("lualine").setup({
        options = { theme = "ayu", section_separators = { "", "" }, component_separators = { "", "" } },
      })
    end,
  },

  -- Git integration
  {
    "lewis6991/gitsigns.nvim",
    event = "BufRead",
    config = function()
      require("gitsigns").setup({
        signs = {
          add = { text = "+" },
          change = { text = "~" },
          delete = { text = "_" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
        },
      })
    end,
  },

  -- HTML tag closing
  {
    "alvan/vim-closetag",
    ft = { "html", "xml", "jsx", "javascriptreact", "typescriptreact" },
  },

  -- Colorscheme
  {
    "folke/tokyonight.nvim",
    config = function()
      require("tokyonight").setup({
        style = "moon",  -- Options: storm, night, or day
        transparent = false,
        terminal_colors = true,
        styles = {
          comments = { italic = true },
          keywords = { italic = false },
          functions = { bold = true },
        },
      })
      vim.cmd([[colorscheme tokyonight]])
    end,
  },

  -- Indent guides
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "BufRead",
    config = function()
      require("ibl").setup({})
    end,
  },

  -- Surround actions
  {
    "kylechui/nvim-surround",
    keys = { "ys", "ds", "cs", "S" },
    config = function()
      require("nvim-surround").setup()
    end,
  },

  -- Commenting
  {
    "numToStr/Comment.nvim",
    keys = { "gc", "gb", "gcc", "gbc" },
    config = function()
      require("Comment").setup()
    end,
  },
})

-- Basic Vim settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wrap = false
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.smartindent = true
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true
vim.opt.termguicolors = true

-- Explicit clipboard configuration
vim.g.clipboard = {
  name = "xclip",
  copy = {
    ["+"] = "xclip -selection clipboard",
    ["*"] = "xclip -selection clipboard",
  },
  paste = {
    ["+"] = "xclip -selection clipboard -o",
    ["*"] = "xclip -selection clipboard -o",
  },
}

-- Key mappings
vim.api.nvim_set_keymap("n", "<leader>e", "<cmd>lua vim.diagnostic.open_float()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>q", "<cmd>Telescope diagnostics<CR>", { noremap = true, silent = true })

-- LSP key mappings
local on_attach = function(client, bufnr)
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
  vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set("n", "<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, bufopts)
  vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
  vim.keymap.set("n", "<leader>f", function()
    vim.lsp.buf.format({ async = true })
  end, bufopts)
end

-- Attach LSP key mappings when LSP connects
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    on_attach(client, args.buf)
  end,
})
