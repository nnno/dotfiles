# path
export PATH="/usr/local/sbin:/usr/local/bin:$HOME/.local/bin:$PATH"

# homebrew
export PATH=$HOME/.homebrew/sbin:$HOME/.homebrew/bin:$PATH
export HOMEBREW_CACHE=$HOME/.homebrew/caches

# sheldon
eval "$(sheldon source)"

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
export HISTSIZE=1000000
export SAVEHIST=1000000

setopt extended_history                         # ヒストリに実行時間も保存する
setopt hist_ignore_all_dups                     # 重複するコマンドは古い方を削除する
setopt hist_expire_dups_first                   # 履歴が上限に達したら重複から先に削除する
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

eval "$(mise activate zsh)"

# tmux セッション自動命名（ghq リポジトリ移動時）
if [[ -n "$TMUX" ]] && type ghq &>/dev/null; then
  function _tmux_rename_session_by_ghq() {
    local ghq_root
    ghq_root=$(ghq root 2>/dev/null) || return
    if [[ "$PWD" == "$ghq_root"/* ]]; then
      local repo_name="${PWD##*/}"
      local session_name="${repo_name//./-}"
      tmux rename-session "$session_name" 2>/dev/null
    fi
  }
  autoload -Uz add-zsh-hook
  add-zsh-hook chpwd _tmux_rename_session_by_ghq
fi

# Load machine-specific settings
if [ -f "$HOME/.zshrc.local" ]; then
  source "$HOME/.zshrc.local"
fi
