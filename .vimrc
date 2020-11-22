set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" Auto completion for various programming langages. Requires compiling via
" python $HOME/.vim/bundle/YouCompleteMe/install.py
Plugin 'ycm-core/YouCompleteMe'
" Syntax checker 
Plugin 'scrooloose/syntastic'

" Auto pairing of brackets
Plugin 'jiangmiao/auto-pairs'

" Molokai theme
Plugin 'tomasr/molokai'

" Git plugin for simple access, can use :Git <command>
Plugin 'tpope/vim-fugitive'

" See the current branch and other useful information within a file.
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

" CLI fuzzy finder, can be used with :FZF 
Plugin 'junegunn/fzf'

" Directory explorer and Git plugin for explorer
Plugin 'preservim/nerdtree'
Plugin 'Xuyuanp/nerdtree-git-plugin'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" Brief help
" " :PluginList       - lists configured plugins
" " :PluginInstall    - installs plugins; append `!` to update or just
" " :PluginUpdate
" " :PluginSearch foo - searches for foo; append `!` to refresh local cache
" " :PluginClean      - confirms removal of unused plugins; append `!` to
" auto-approve removal
" "
" " see :h vundle for more details or wiki for FAQ
" " Put your non-Plugin stuff after this line

" syntastic configuration
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" Turns on syntax colours in Vim.
syntax on

" Set the molokai colour scheme.
colorscheme molokai



" Line numbers
set number

" Automatically convert tabs to spaces.
set expandtab

" Line wrapping
set wrap

" Vim command auto complete show as a menu.
set wildmenu

" Confirmation on save
set confirm     

" Increase history size
set history=200

" Search highlighting
set hlsearch

" Ignore case when searching.
set ignorecase
" Set vim airline theme
let g:airline_theme='badwolf'



