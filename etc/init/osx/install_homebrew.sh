#!/bin/bash

if [[ $OSTYPE != darwin* ]]; then
    exit
fi
if type brew > /dev/null 2>&1; then
    exit
fi

ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

