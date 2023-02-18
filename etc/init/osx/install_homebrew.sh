#!/bin/bash

if [[ $OSTYPE != darwin* ]]; then
    exit
fi
if type brew > /dev/null 2>&1; then
    exit
fi

mkdir $HOME/.homebrew
curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C $HOME/.homebrew

echo 'Add the following to your .zshrc'
echo 'export PATH=$HOME/.homebrew/bin:$PATH'
echo 'export HOMEBREW_CACHE=$HOME/.homebrew/caches'

