-- init.lua
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
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

-- Plugin setup
require("lazy").setup({
	{ "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  { "projekt0n/github-nvim-theme", name = "github-theme"},
	"nvim-lua/plenary.nvim",
	"nvim-telescope/telescope.nvim",
	"neovim/nvim-lspconfig",
	"williamboman/mason.nvim",
	"williamboman/mason-lspconfig.nvim",
	"mfussenegger/nvim-lint",
	"nvim-treesitter/nvim-treesitter",
  "hrsh7th/nvim-cmp",
	"hrsh7th/cmp-nvim-lsp",
	"L3MON4D3/LuaSnip",
	"windwp/nvim-autopairs",
  "numToStr/Comment.nvim",
  "nvim-tree/nvim-tree.lua",
})

-- Theme setup
vim.cmd.colorscheme "github_dark"

-- LSP and Mason setup
require("mason").setup()
require("mason-lspconfig").setup({ ensure_installed = { "ts_ls" } })

local lspconfig = require("lspconfig")

lspconfig.ts_ls.setup({
  on_attach = function(client, bufnr)
    -- Linting with eslint using nvim-lint
    local lint = require("lint")
    lint.linters_by_ft = {
      javascript = { "eslint" },
      typescript = { "eslint" },
    }
    vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
      callback = function()
        lint.try_lint()
      end,
    })
  end,
})

lspconfig.ts_ls.setup({
  on_attach = function(client, bufnr)
    -- Linting with eslint using nvim-lint
    local lint = require("lint")
    lint.linters_by_ft = {
      javascript = { "eslint" },
      typescript = { "eslint" },
    }
    vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
      callback = function()
        lint.try_lint()
      end,
    })
  end,
})

-- Treesitter setup
require("nvim-treesitter.configs").setup({
  ensure_installed = { "javascript", "typescript", "html", "css", "lua" },
  highlight = { enable = true },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",   -- Start selection
      node_incremental = "grn", -- Increment to next node
      scope_incremental = "grc", -- Increment to next scope
      node_decremental = "grm", -- Decrement to previous node
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ["af"] = "@function.outer", -- Select around function
        ["if"] = "@function.inner", -- Select inside function
        ["ac"] = "@class.outer",    -- Select around class
        ["ic"] = "@class.inner",    -- Select inside class
      },
    },
    move = {
      enable = true,
      set_jumps = true,
      goto_next_start = {
        ["]m"] = "@function.outer",
        ["]c"] = "@class.outer",
      },
      goto_previous_start = {
        ["[m"] = "@function.outer",
        ["[c"] = "@class.outer",
      },
    },
  },
})

-- Autocompletion setup
local cmp = require("cmp")
cmp.setup({
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-Space>"] = cmp.mapping.complete(),
		["<CR>"] = cmp.mapping.confirm({ select = true }),
	}),
	sources = cmp.config.sources({ { name = "nvim_lsp" } }),
})

-- Auto-pairs
require("nvim-autopairs").setup({})

-- Comment.nvim setup
require("Comment").setup({
  toggler = {
    line = "gcc", -- Toggle line comment
    block = "gbc", -- Toggle block comment
  },
  opleader = {
    line = "gc", -- Operator-pending mapping for line comment
    block = "gb", -- Operator-pending mapping for block comment
  },
})

-- nvim-tree setup
require("nvim-tree").setup({
  view = {
    width = 30,
    side = "left",
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = false,
  },
})

-- Telescope setup
local telescope = require("telescope.builtin")

-- Keybindings
vim.api.nvim_set_keymap("v", "<Tab>", ">gv", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<S-Tab>", "<gv", { noremap = true, silent = true })

--treesitter
vim.api.nvim_set_keymap("n", "<C-n>", ":NvimTreeToggle<CR>", { noremap = true, silent = true })

--telescope
vim.api.nvim_set_keymap("n", "<leader>gd", ":lua require('telescope.builtin').lsp_definitions()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>gr", ":lua require('telescope.builtin').lsp_references()<CR>", { noremap = true, silent = true })

-- Disable automatic comment continuation
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*",
  callback = function()
    vim.opt.formatoptions:remove({ "c", "r", "o" })
  end,
})

-- Basic settings
vim.g.mapleader = " "
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
