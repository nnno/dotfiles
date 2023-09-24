#!/usr/bin/env bash

ghq_download_url='https://github.com/x-motemen/ghq/releases/download/v1.4.2/ghq_linux_arm64.zip'

export PATH="$PATH:$HOME/.local/bin"

set -ux

# Change shell to zsh
chsh -s /bin/zsh

# git, ghqをインストール
sudo apt install git

if [ ! -d "$HOME"/.local/bin ]; then
  mkdir "$HOME"/.local/bin
fi
tmp_dir=$(mktemp -d)
trap 'rm -rf $tmp_dir' EXIT
cd $tmp_dir
wget $ghq_download_url
unzip ghq_linux_arm64.zip ghq_linux_arm64/ghq

cp ghq_linux_arm64/ghq $HOME/.local/bin/

# ghqの初期設定
if [ ! -d "$HOME"/src ]; then
  mkdir "$HOME"/src
fi

git config --global ghq.root "$HOME"/src

ghq get nnno/dotfiles

echo "end of script."
echo "please run ~/src/github.com/nnno/dotfiles/bin/setup_rpi4.sh"
