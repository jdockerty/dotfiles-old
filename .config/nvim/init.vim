set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent

set relativenumber " show line numbers relative to current line
set number " show current line number
set hidden
set noerrorbells

" Give more space for displaying messages.
set cmdheight=2

set encoding=utf-8
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

set noswapfile
set nobackup
set nowritebackup
set nowrap
set undodir=~/.vim/undodir
set undofile
set incsearch " incremental search
set nohlsearch " don't highlight search results
set clipboard+=unnamedplus

set scrolloff=8 " Start scrolling 8 lines away from top/bottom

set colorcolumn=80 " 80 characters in, there is a line which is a guide for too much indenting.
set signcolumn=yes:1 " extra column for linting, git, lsp etc.

set completeopt=menu,menuone,noselect

call plug#begin('~/.vim/plugged')

Plug 'darrikonn/vim-gofmt', { 'do': ':GoUpdateBinaries' }

Plug 'jiangmiao/auto-pairs'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-lua/plenary.nvim' " Dependency for telescope, this also requires ripgrep (rg) to be installed too
Plug 'ThePrimeagen/harpoon'
Plug 'gruvbox-community/gruvbox'


Plug 'Vimjas/vim-python-pep8-indent'

" Syntax/highlighting
Plug 'hashivim/vim-terraform'
Plug 'google/vim-jsonnet'

" Language Server configuration
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/nvim-lsp-installer'

Plug 'mbbill/undotree'
Plug 'tpope/vim-fugitive' " Git

Plug 'vim-airline/vim-airline'
Plug 'airblade/vim-gitgutter'

" Snippets
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'

" Dependency on g++ too.
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}


call plug#end()

lua <<EOF

  function go_org_imports(wait_ms)
    local params = vim.lsp.util.make_range_params()
    params.context = {only = {"source.organizeImports"}}
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, wait_ms)
    for cid, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
          vim.lsp.util.apply_workspace_edit(r.edit, enc)
        end
      end
    end
  end

  -- Set up nvim-cmp.
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
      end,
    },
    window = {
      --completion = cmp.config.window.bordered(),
      --documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
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

EOF

colorscheme gruvbox

let g:terraform_fmt_on_save = 1
autocmd BufWritePre *.go lua go_org_imports()

" Set our leader key to spacebar
let mapleader = " "

nnoremap <leader>ps :lua require('telescope.builtin').grep_string({ search = vim.fn.input("Search for: ")})<CR>
nnoremap <leader>pv <cmd>Explore<cr>
" Telescope mappings
nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>

nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>


" Reload file easily, useful when using git and files are changing
nnoremap <silent><leader>r <cmd>checktime<cr>

" Language Info, press 'i' to install in the shown list.
nnoremap <leader>li :LspInstallInfo<CR>

" Save/Source current file, used when editing init.vim
nnoremap <silent><leader>so :w <CR> :source %<CR>

" Clear buffers, except the current one. The pipe must be escaped using '\'.
nnoremap <silent><leader>bd :%bd\|e#<CR>

nnoremap <leader>y "+y
vnoremap <leader>y "+y
nmap <leader>Y "+Y

nnoremap <leader>d "_d
vnoremap <leader>d "_d

nnoremap <silent><leader>a :lua require("harpoon.mark").add_file()<CR>
nnoremap <silent><leader>t :lua require("harpoon.ui").toggle_quick_menu()<CR>

nnoremap <silent><leader>ay :lua require("harpoon.ui").nav_file(1)<CR>
nnoremap <silent><leader>au :lua require("harpoon.ui").nav_file(2)<CR>
nnoremap <silent><leader>ai :lua require("harpoon.ui").nav_file(3)<CR>
nnoremap <silent><leader>ao :lua require("harpoon.ui").nav_file(4)<CR>

" Toggle the undo tree on/off
nnoremap <silent><leader>u :UndotreeToggle<CR> :UndotreeFocus <CR>

" Save
nnoremap <leader>ss :write <CR>

nnoremap <leader>q :wq <CR>




