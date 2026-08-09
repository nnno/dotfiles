#!/usr/bin/env bash

set -o pipefail

if [[ $OSTYPE != darwin* ]]; then
    exit
fi

#install xcode
xcode-select --install > /dev/null

#install homebrew
if ! [ -x /opt/homebrew/bin/brew ]; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "Homebrew already installed."
fi

# Change shell to zsh
chsh -s /bin/zsh

# gitはmacosデフォルトのものを使う (以前はhomebrew版を使っていたが、homebrewの非標準のパスをサポートしなくなったため)
# ghq, fzfをインストール、dotfilesを取得する
# PATHは /etc/paths.d/homebrew で通るが、次のログインからのため同一シェル内では shellenv を使う
eval "$(/opt/homebrew/bin/brew shellenv)"

brew install ghq fzf

if [ ! -d "$HOME"/src ]; then
  mkdir "$HOME"/src
fi

git config --global ghq.root "$HOME"/src

ghq get nnno/dotfiles

echo "end of script."
echo "please run ~/src/github.com/nnno/dotfiles/bin/setup_mac.sh"
