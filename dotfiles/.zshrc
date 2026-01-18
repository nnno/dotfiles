# path
export PATH="/usr/local/sbin:/usr/local/bin:$HOME/.local/bin:$PATH"

# homebrew
export PATH=$HOME/.homebrew/sbin:$HOME/.homebrew/bin:$PATH
export HOMEBREW_CACHE=$HOME/.homebrew/caches

# sheldon
eval "$(sheldon source)"

# flutter
if [ -d "$HOME/work/flutter/bin" ] ; then
  export PATH="$PATH:$HOME/work/flutter/bin"
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

# golang
if type go &>/dev/null; then
  export GOPATH=$(go env GOPATH)
  export PATH=$PATH:$GOPATH/bin
fi

# docker
if type docker &>/dev/null; then
  if [[ -z `docker context ls --format json | jq -r '. | select(.Current == true) | .DockerEndpoint'` ]]; then
    unset $DOCKER_HOST
  else
    # colima使っている場合、明示しないと動作しないケースがある
    export DOCKER_HOST=`docker context ls --format json | jq -r '. | select(.Current == true) | .DockerEndpoint'`
  fi
fi

# Jetbrains IDE
export PATH="/Applications/IntelliJ IDEA.app/Contents/MacOS:$PATH"
export PATH="/Applications/GoLand.app/Contents/MacOS:$PATH"
# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/nnno/.docker/completions $fpath)
autoload -Uz compinit
compinit
# End of Docker CLI completions


# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/nnno/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/nnno/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/nnno/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/nnno/google-cloud-sdk/completion.zsh.inc'; fi

eval "$(mise activate zsh)"
