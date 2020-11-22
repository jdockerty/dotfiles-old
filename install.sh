#!/bin/bash

function goHome {
	cd $HOME
}


goHome 
git clone https://github.com/powerline/fonts
cd fonts
./install.sh

goHome

git clone https://github.com/ycm-core/YouCompleteMe
cd YouCompleteMe
python $HOME/.vim/bundle/YouCompleteMe/install.py
