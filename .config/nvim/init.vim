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

" Syntax/highlighting
Plug 'hashivim/vim-terraform'
Plug 'google/vim-jsonnet'

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

Plug 'Pocco81/AutoSave.nvim'


call plug#end()

lua <<EOT

local autosave = require("autosave")

autosave.setup(
    {
        enabled = true,
        execution_message = "AutoSave: saved at " .. vim.fn.strftime("%H:%M:%S"),
        events = {"InsertLeave", "TextChanged"},
        conditions = {
            exists = true,
            filename_is_not = {},
            filetype_is_not = {},
            modifiable = true
        },
        write_all_buffers = false,
        on_off_commands = true,
        clean_command_line_interval = 0,
        debounce_delay = 135
    }
)

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

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<leader>cn', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)


end

-- Setup lspconfig.
  local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
  local lspconfig = require('lspconfig')


  -- Language servers
  local servers = {'gopls', 'terraformls', 'jsonnet_ls', 'pylsp'}

  for _, lsp in pairs(servers) do
      lspconfig[lsp].setup{
        on_attach = on_attach
      }

  end
EOT

colorscheme gruvbox

let g:terraform_fmt_on_save = 1

" Set our leader key to spacebar
let mapleader = " "

nnoremap <leader>ps :lua require('telescope.builtin').grep_string({ search = vim.fn.input("Search for: ")})<CR>

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


