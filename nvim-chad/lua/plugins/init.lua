require('telescope').setup {
  defaults = {
    file_ignore_patterns = { "node_modules", ".git", "dist" },
  }
}



return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  {
    "NvChad/nvterm",
    config = function()
      require("nvterm").setup()
    end,
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim", "lua", "vimdoc",
        "html", "css", "typescript"
      },
      file_ignore_patterns = {
        "node_modules"
      },
    },
  },
}
