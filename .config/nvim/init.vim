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

Plug 'Pocco81/AutoSave.nvim'

Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'akinsho/git-conflict.nvim'

" Dependency on g++ too.
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}


call plug#end()

lua <<EOT

require('git-conflict').setup{}


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




-- Setup lspconfig.
  local lspconfig = require('lspconfig')


  -- Language servers
  local servers = {'gopls', 'terraformls', 'jsonnet_ls', 'pyright', 'golangci_lint_ls'}


  lspconfig.gopls.setup{
    on_attach = on_attach,
    cmd = {"gopls", "serve"}
  }

  lspconfig.terraformls.setup{
    on_attach = on_attach
  }

  lspconfig.jsonnet_ls.setup{
    on_attach = on_attach
  }

  lspconfig.pyright.setup{
    on_attach = on_attach
  }

  lspconfig.golangci_lint_ls.setup{
    on_attach = on_attach
  }


require('nvim-treesitter.configs').setup{
highlight = {
        enable = true,
    }
}

EOT

colorscheme gruvbox

let g:terraform_fmt_on_save = 1

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


" coc.nvim config


"Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call ShowDocumentation()<CR>


function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

" Use tab for trigger completion with characters ahead and navigate.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ CheckBackspace() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction


" coc.nvim config end
"
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


