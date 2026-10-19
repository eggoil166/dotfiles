return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavor = "mocha",
        transparent_background = true,
      })
      vim.cmd.colorscheme("catppuccin")
      local groups = { "Normal", "NormalNC", "NormalFloat", "SignColumn", "MsgArea" }
      for _, g in ipairs(groups) do
        vim.api.nvim_set_hl(0, g, { bg = "none" })
      end
    end,
  },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}
