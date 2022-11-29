  -- Set up nvim-cmp.
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
      end,
    },
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif vim.fn["vsnip#available"](1) == 1 then
        feedkey("<Plug>(vsnip-expand-or-jump)", "")
      elseif has_words_before() then
        cmp.complete()
      else
        fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
      end
    end, { "i", "s" }),
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' }, 
    }, {
      { name = 'buffer' },
    })
  })

    -- Set up lspconfig.
  local capabilities = require('cmp_nvim_lsp').default_capabilities()

require("nvim-lsp-installer").setup {
    automatic_installation = true -- detect servers to install based on
}




-- Setup lspconfig.
  lspconfig = require "lspconfig"


  -- Language servers

  lspconfig.rust_analyzer.setup{
    capabilities = capabilities,
    on_attach = on_attach
  }

  util = require "lspconfig/util"

  lspconfig.gopls.setup {
    capabilities = capabilities,
    cmd = {"gopls", "serve"},
    filetypes = {"go", "gomod"},
    root_dir = util.root_pattern("go.work", "go.mod", ".git"),
    settings = {
      gopls = {
        analyses = {
          unusedparams = true,
        },
        staticcheck = true,
      },
    },
  }

  lspconfig.terraformls.setup{
    on_attach = on_attach,
    capabilities = capabilities,
  }

  lspconfig.jsonnet_ls.setup{
    on_attach = on_attach,
    capabilities = capabilities,
  }

  lspconfig.pyright.setup{
    on_attach = on_attach,
    capabilities = capabilities,
  }





require('nvim-treesitter.configs').setup{
highlight = {
        enable = true,
    }
}
