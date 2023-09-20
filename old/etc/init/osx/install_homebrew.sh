#!/bin/bash

if [ "$(uname)" != "Darwin" ]; then
  echo 'This script is only for OSX'
  exit
fi

# set zsh
chsh -s /bin/zsh

#install xcode
xcode-select --install > /dev/null

#install homebrew
mkdir "$HOME"/.homebrew
curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C $HOME/.homebrew

echo 'Add the following to your .zshrc'
echo 'export PATH=$HOME/.homebrew/bin:$PATH'
echo 'export HOMEBREW_CACHE=$HOME/.homebrew/caches'
