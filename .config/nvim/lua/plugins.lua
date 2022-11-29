-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  use 'folke/tokyonight.nvim'

 use {'darrikonn/vim-gofmt', run = ":GoUpdateBinaries"}

 use 'jiangmiao/auto-pairs'
 use 'nvim-telescope/telescope.nvim'
 use 'nvim-lua/plenary.nvim' -- Dependency for telescope, this also requires ripgrep (rg) to be installed too
 use 'ThePrimeagen/harpoon'
 use 'gruvbox-community/gruvbox'


use 'Vimjas/vim-python-pep8-indent'

-- Syntax/highlighting
use 'hashivim/vim-terraform'
use 'google/vim-jsonnet'

-- Language Server configuration
use 'neovim/nvim-lspconfig'
use 'williamboman/nvim-lsp-installer'

-- Git and undo helpers
use 'mbbill/undotree'
use 'tpope/vim-fugitive' 
use 'vim-airline/vim-airline'
use 'airblade/vim-gitgutter'

-- Snippets
use 'hrsh7th/cmp-nvim-lsp'
use 'hrsh7th/cmp-buffer'
use 'hrsh7th/cmp-path'
use 'hrsh7th/cmp-cmdline'
use 'hrsh7th/nvim-cmp'
use 'hrsh7th/cmp-vsnip'
use 'hrsh7th/vim-vsnip'

-- g++ dependency is also required
use {'nvim-treesitter/nvim-treesitter', run = ":TSUpdate"}

use 'tpope/vim-surround'
 end
)
