-- Teak
vim.cmd("set expandtab")
vim.cmd("set relativenumber")
vim.cmd("set softtabstop=2")
vim.cmd("set softtabstop=2")
vim.wo.relativenumber = true
vim.cmd("set shiftwidth=2")
vim.g.mapleader = " "
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable" , lazypath })
end
vim.opt.rtp:prepend(lazypath)
local plugins = {

{ "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  {
    'nvim-telescope/telescope.nvim', tag = '0.1.8',
      dependencies = { 'nvim-lua/plenary.nvim' },
    {"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"}
  },
{
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
      -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
    }
}
}
local opts = {}
require("lazy").setup(plugins,opts)
local builtin = require("telescope.builtin")
vim.keymap.set('n' , '<C-p>', builtin.find_files, {})
vim.keymap.set('n' , '<leader>fg', builtin.live_grep, {})

local configs = require("nvim-treesitter.configs")

configs.setup({
          ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "elixir", "heex", "javascript", "html" },
          highlight = { enable = true },
          indent = { enable = true },  
        })

require("catppuccin").setup()
vim.cmd.colorscheme "catppuccin"
