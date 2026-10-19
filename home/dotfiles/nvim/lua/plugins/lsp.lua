return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        clangd = { mason = false },
        lua_ls = { mason = false },
        nixd = { mason = false },
        ruff = { mason = false },
        rust_analyzer = { mason = false },
        asm_lsp = { mason = false },
      },
    },
  },
}
