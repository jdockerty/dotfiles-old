set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent


set relativenumber " show line numbers relative to current line
set number " show current line number
set hidden
set noerrorbells

set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile
set incsearch " incremental search

set scrolloff=8 " Start scrolling 8 lines away from top/bottom

set signcolumn=yes " extra column for linting, git, lsp etc.

set completeopt=menu,menuone,noselect

call plug#begin('~/.vim/plugged')

Plug 'darrikonn/vim-gofmt', { 'do': ':GoUpdateBinaries' }

Plug 'jiangmiao/auto-pairs'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-lua/plenary.nvim' " Dependency for telescope, this also requires ripgrep (rg) to be installed too
Plug 'ThePrimeagen/harpoon'
Plug 'gruvbox-community/gruvbox'

" Syntax/highlighting
Plug 'hashivim/vim-terraform'

" Language Server configuration
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/nvim-lsp-installer'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/vim-vsnip'

Plug 'mbbill/undotree'
Plug 'tpope/vim-fugitive' " Git

Plug 'vim-airline/vim-airline'
Plug 'airblade/vim-gitgutter'
call plug#end()

lua <<EOT


require("nvim-lsp-installer").setup {
    automatic_installation = true -- detect servers to install based on
}


  -- Setup nvim-cmp.
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
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
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
      ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()

      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, { 'i', 's' }),
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' }, -- For vsnip users.
    }, {
      { name = 'buffer' },
    })
  })

  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

  -- Setup lspconfig.
  local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
  local lspconfig = require('lspconfig')

  -- Language servers
  lspconfig.gopls.setup{}
  lspconfig.terraformls.setup{}
  lspconfig.jsonnet_ls.setup{}
  lspconfig.pylsp.setup{}
EOT

colorscheme gruvbox

let g:terraform_fmt_on_save = 1

" Set our leader key to spacebar
let mapleader = " "

nnoremap <leader>ps :lua require('telescope.builtin').grep_string({ search = vim.fn.input("Search for: ")})<CR>
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" Language Info, press 'i' to install in the shown list.
nnoremap <leader>li :LspInstallInfo<CR>

" Save/Source current file, used when editing init.vim
nnoremap <leader>so :w <CR> :source %<CR>

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

fun! TrimWhiteSpace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun

augroup MY_AUTO_GROUP
    autocmd!
    autocmd BufWritePre * :call TrimWhiteSpace()
    autocmd BufWritePre *.go  :GoFmt
    autocmd BufWritePre *.go  :GoImports
augroup END


