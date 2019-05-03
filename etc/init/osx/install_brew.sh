#!/bin/bash

if [[ $OSTYPE != darwin* ]]; then
    exit
fi

brew tap Homebrew/bundle
brew bundle cleanup
brew bundle
