vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0

-- ==========================================
-- =====     Configuracion global       =====
-- ==========================================
vim.opt.number = true               -- Números fijos tradicionales
vim.opt.showcmd = true              -- Ver comandos a medias
vim.opt.showmatch = true            -- Parpadeo de paréntesis
vim.opt.termguicolors = true        -- Colores reales
vim.opt.relativenumber = false      -- Desactivar relativos
vim.opt.encoding = "utf-8"          -- Codificación UTF-8
vim.opt.mouse = "a"                 -- Activar el ratón
vim.o.clipboard = "unnamedplus"
vim.opt.clipboard = "unnamedplus"

vim.api.nvim_set_keymap('v', 'y', '"+y', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'yy', '"+yy', { noremap = true, silent = true })

-- Mover líneas con Shift + Flechas
vim.keymap.set('n', '<S-Down>', ':m .+1<CR>==', { silent = true })
vim.keymap.set('n', '<S-Up>', ':m .-2<CR>==', { silent = true })
vim.keymap.set('v', '<S-Down>', ":m '>+1<CR>gv=gv", { silent = true })
vim.keymap.set('v', '<S-Up>', ":m '<-2<CR>gv=gv", { silent = true })

-- ==========================================
--     INSTALADOR DE PLUGINS (LAZY.NVIM)
-- ==========================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- ==========================================
--        LISTA DE PLUGINS A INSTALAR
-- ==========================================
require("lazy").setup({
  { "nvim-tree/nvim-web-devicons" },

  -- [NUEVO] Agregado el autocierre de paréntesis, llaves y comillas
  { "echasnovski/mini.pairs", version = false, config = true },

  -- La barra Lualine
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      require("lualine").setup({
        options = {
          theme = "auto",
          component_separators = { left = '', right = '' },
          section_separators = { left = '', right = '' },
        },
      })
    end
  },

  -- TREESITTER: motor de colores avanzado
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup({
        ensure_installed = { "hyprlang", "python", "lua", "bash", "markdown", "vim", "vimdoc", "css" },
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
      })
    end
  },

  -- MASON y LSPCONFIG: Corregir y sugerir codigo
  { "neovim/nvim-lspconfig" },
  { "williamboman/mason.nvim", config = true },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "hyprls", "pyright", "cssls" }
      })

      -- Configuración moderna nativa (Evita los avisos de "deprecated")
      vim.lsp.config('lua_ls', {
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = { globals = { 'vim', 'hyprland' } },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            telemetry = { enabled = false },
          },
        },
      })

      vim.lsp.config('hyprls', {
        capabilities = capabilities,
      })

      vim.lsp.config('pyright', {
        capabilities = capabilities,
      })
      vim.lsp.config('cssls', {
        capabilities = capabilities,
      })
    end
  },

  -- El motor de autocompletado (El cuadradito flotante)
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-path" },
      { "L3MON4D3/LuaSnip" },
      { "saadparwaiz1/cmp_luasnip" },
    },
    config = function()
      local cmp = require('cmp')
      local luasnip = require('luasnip')

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<C-e>'] = cmp.mapping.abort(),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'path' },
          { name = 'buffer' },
        })
      })
    end
  },

  -- CATPPUCCIN 
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        transparent_background = false,
        dim_inactive = {
          enabled = true,
          shade = "dark",
          percentage = 0.5,
        },
      })
      vim.cmd.colorscheme("catppuccin-mocha")
    end
  }
})
