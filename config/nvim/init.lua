-- Bootstrap Lazy.nvim (plugin manager)
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

-- Plugin specifications
require("lazy").setup({
  -- Catppuccin Mocha Theme
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
        integrations = {
          cmp = true,
          gitsigns = true,
          nvimtree = true,
          treesitter = true,
          mason = true,
          native_lsp = {
            enabled = true,
            virtual_text = {
              errors = { "italic" },
              hints = { "italic" },
              warnings = { "italic" },
              information = { "italic" },
            },
          },
        }
      })
      vim.cmd.colorscheme("catppuccin")
    end
  },

  -- Completion framework
{
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "L3MON4D3/LuaSnip",
  },
  config = function()
    local cmp = require("cmp")
    cmp.setup({
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
        -- Add Tab/S-Tab navigation
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          else
            fallback()
          end
        end, { "i", "s" }),
      }),
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
      }),
    })
  end
},

  -- Modern Treesitter setup
  {
    "nvim-treesitter/nvim-treesitter",
    build = function()
      require("nvim-treesitter.install").update({ with_sync = true })
    end,
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { 
          "python", 
          "javascript", 
          "typescript",
          "c", 
          "gdscript",
          "lua",
          "bash",
          "markdown",
          "markdown_inline",
          "go"
        },
        sync_install = false,
        auto_install = true,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        indent = { enable = true },
      })
    end
  },

  -- LSP Configuration
  {
    "williamboman/mason.nvim",
    config = true,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {  
          "lua_ls",
          "gopls",
          "bashls"
        }
      })
    end
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      -- Set up capabilities with nvim-cmp
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      
      local lspconfig = require("lspconfig")
      local on_attach = function(client, bufnr)
        local opts = { buffer = bufnr }
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
      end

      -- Configure LSP servers
      lspconfig.pyright.setup({ capabilities = capabilities, on_attach = on_attach })
      lspconfig.clangd.setup({ capabilities = capabilities, on_attach = on_attach })
      lspconfig.gdscript.setup({ capabilities = capabilities, on_attach = on_attach })
      lspconfig.gopls.setup({ capabilities = capabilities, on_attach = on_attach })
      lspconfig.bashls.setup({capabilities = capabilities, on_attach=on_attach, filetypes = { "sh", "zsh" }})
      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          Lua = {
            runtime = { version = 'LuaJIT' },
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
          }
        }
      })
    end
  },
  {
  "monkoose/neocodeium",
  event = "VeryLazy",
  config = function()
    local neocodeium = require("neocodeium")
    neocodeium.setup()
    vim.keymap.set("i", "<A-f>", neocodeium.accept)
  end,
}
})

-- Neovide GUI configuration
if vim.g.neovide then
  vim.opt.guifont = { "FiraCode Nerd Font"}
  vim.g.neovide_scale_factor = 1.0
  vim.g.neovide_transparency = 0.95
  vim.g.neovide_cursor_animation_length = 0.15
  vim.g.neovide_refresh_rate = 60
end

-- General settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.termguicolors = true

-- Remaps
vim.keymap.set("i", "<C-s>", "<C-o>:w<CR>", { noremap = true, silent = true })
vim.keymap.set('i', '<C-S-V>', '<C-o>"+p', { noremap = true, silent = true }) -- Insert mode
vim.keymap.set('n', '<C-S-V>', '"+p', { noremap = true, silent = true }) -- Normal 
vim.keymap.set('i', '<C-z>', '<C-o>u', { noremap = true, silent = true })
vim.keymap.set('i', '<C-a>', '<Esc>ggVG', { noremap = true, silent = true })
-- Copy/Paste Mappings
vim.keymap.set('v', '<C-c>', '"+y', { noremap = true, silent = true })           -- Visual: Copy
vim.keymap.set('i', '<C-S-c>', '<Esc>^"+y$gi', { noremap = true, silent = true }) -- Insert: Copy Line
vim.keymap.set('i', '<C-S-w>', '<C-o>viw"+y', { noremap = true, silent = true })  -- Insert: Copy Word

