# path
export PATH="/usr/local/sbin:/usr/local/bin:$PATH"

# homebrew
export PATH=$HOME/.homebrew/bin:$PATH
export HOMEBREW_CACHE=$HOME/.homebrew/caches

# sheldon
eval "$(sheldon source)"

# flutter
if [ -d "$HOME/work/flutter/bin" ] ; then
  export PATH="$PATH:$HOME/work/flutter/bin"
fi

# asdf
if [ -d "$HOME/.homebrew/opt/asdf" ] ; then
  . "$HOME"/.homebrew/opt/asdf/libexec/asdf.sh
fi

# Rancher Desktop
if [ -d "$HOME/.rd/bin" ] ; then
  export PATH="$HOME/.rd/bin:$PATH"
fi

