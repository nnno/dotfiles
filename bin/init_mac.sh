#!/usr/bin/env bash

set -o pipefail

if [[ $OSTYPE != darwin* ]]; then
    exit
fi

#install xcode
xcode-select --install > /dev/null

#install homebrew
if [ ! -d "$HOME"/.homebrew ]; then
  mkdir "$HOME"/.homebrew
  curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C $HOME/.homebrew

  echo 'Add the following to your .zshrc'
  echo 'export PATH=$HOME/.homebrew/bin:$PATH'
  echo 'export HOMEBREW_CACHE=$HOME/.homebrew/caches'

else
  echo "Homebrew already installed."
fi

# Change shell to zsh
chsh -s /bin/zsh

# gitとghqをインストールし、dotfilesを取得する
export PATH=$HOME/.homebrew/bin:$PATH
export HOMEBREW_CACHE=$HOME/.homebrew/caches

brew install git ghq

if [ ! -d "$HOME"/src ]; then
  mkdir "$HOME"/src
fi

git config --global ghq.root "$HOME"/src

ghq get nnno/dotfiles

echo 'end of script. please run ~/src/github.com/nnno/dotfiles/bin/install_mac.sh'
