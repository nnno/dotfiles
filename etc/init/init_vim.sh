#!/bin/bash

# Step 1: Install NeoBundle.
curl https://raw.githubusercontent.com/Shougo/neobundle.vim/master/bin/install.sh | sh

# Step 2: Install configured bundles.
vim +NeoBundleInstall +qall

