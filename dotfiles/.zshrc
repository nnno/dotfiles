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

setopt hist_ignore_dups     # ignore duplication command history list
setopt share_history        # share command history data
setopt extended_history     # 履歴ファイルに時刻を記録
setopt append_history       # 上書きではなく追加する
setopt hist_ignore_all_dups # 重複したヒストリは追加しない
setopt hist_verify          # ヒストリを呼び出してから実行する間に一旦編集できる状態になる
setopt no_list_types        # auto_list の補完候補一覧で、ls -F のようにファイルの種別をマーク表示しない
