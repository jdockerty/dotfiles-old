#!/bin/env bash

function goHome {
	cd $HOME
}


THIS_DIR=$(pwd)

# Install powerline fonts
goHome
git clone https://github.com/powerline/fonts
cd fonts
./install.sh # Install powerline fonts script

# Install ZSH plugins
goHome
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Neovim installation
echo "Checking for 'neovim'"
if [! command -v nvim &> /dev/null && $EUID != 0];
then
	echo "neovim does not exist, installing"
	sudo dnf install neovim # I'm using Fedora currently, we can optimise this later for different OS' or grabbing the binary from GitHub
else
	echo "neovim already installed!"
fi

if [ ! -f "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim ]
then
	echo "Installing vim-plug"
	sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
else
	echo "vim-plug already installed"
fi

echo "Installing plugins"
vim +PlugInstall +qall # +qall exits out of the windows after installation


if [ ! -d "${HOME}/.config/nvim" ]
then
	echo "Creating '.config/nvim' directory"
	mkdir -p "${HOME}/.config/nvim"
else
	echo "'${HOME}/.config/nvim' directory exists"
fi

echo "Installing tmux plugin manager (tpm)"
git clone https://github.com/tmux-plugins/tpm ${HOME}/.tmux/plugins/tpm

echo "Creating symlinks"

# Using a symlink means we can update here and have it also change in the proper directory, whilst being version controlled to push later.
ln -s -f "$THIS_DIR/.config/nvim/init.lua" "${HOME}/.config/nvim/init.lua"
ln -s -f "$THIS_DIR/.zshrc" "${HOME}/.zshrc"
