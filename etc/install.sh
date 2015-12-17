#!/usr/bin/env bash

DOTPATH=~/dotfiles
DOTFILES_GITHUB="https://github.com/nnno/dotfiles.git"

if has "git"; then
    git clone --recursive "$DOTFILES_GITHUB" "$DOTPATH"
elif has "curl" || has "wget"; then
    tarball="https://github.com/b4b4r07/dotfiles/archive/master.tar.gz"
    if has "curl"; then
        curl -L "$tarball"
    elif has "wget"; then
        wget -O - "$tarball"
    fi | tar xv -
    mv -f dotfile-master "$DOTPATH"
else
    die "curl or wget required."
fi

cd "$DOTPATH"
if [ $? -ne 0 ]; then
    die "not found: $DOTPATH"
fi

make install


