#!/bin/bash

ghq_download_url=$(curl -s https://api.github.com/repos/x-motemen/ghq/releases/latest | grep -oP '"browser_download_url": "\K[^"]*ghq_linux_amd64\.zip')

export PATH="$PATH:$HOME/.local/bin"

set -ux

# git, ghqをインストール
sudo apt install git unzip zsh

# Change shell to zsh
chsh -s /bin/zsh


if [ ! -d "$HOME"/.local/bin ]; then
  mkdir "$HOME"/.local/bin
fi
tmp_dir=$(mktemp -d)
trap 'rm -rf $tmp_dir' EXIT
cd $tmp_dir
wget $ghq_download_url
unzip ghq_linux_amd64.zip ghq_linux_amd64/ghq

cp ghq_linux_amd64/ghq $HOME/.local/bin/

# ghqの初期設定
if [ ! -d "$HOME"/src ]; then
  mkdir "$HOME"/src
fi

git config --global ghq.root "$HOME"/src

ghq get -p nnno/dotfiles

echo "end of script."
echo "please run ~/src/github.com/nnno/dotfiles/bin/setup_rpi4.sh"
