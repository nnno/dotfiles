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

export EDITOR='vim'

setopt auto_pushd                               # cd時にディレクトリスタックに積む

setopt auto_cd                                  # cdコマンドの省略
setopt auto_list                                # 補完候補を一覧で表示する
setopt auto_menu                                # 補完キー連打で補完候補を順に表示する
setopt list_packed                              # 補完候補をできるだけ詰めて表示する
setopt list_types                               # 補完候補にファイルの種類も表示する

# History
export HIST_STAMPS='yyyy/mm/dd'
export HISTFILE=${HOME}/.zsh_history
export HISTSIZE=10000
export SAVEHIST=10000

setopt extended_history                         # ヒストリに実行時間も保存する
setopt hist_ignore_dups                         # 直前と同じコマンドはヒストリに追加しない
setopt share_history                            # 他のシェルのヒストリをリアルタイムで共有する
setopt hist_reduce_blanks                       # 余分なスペースを削除してヒストリに保存する

# マッチしたコマンドのヒストリを表示できるようにする
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end
