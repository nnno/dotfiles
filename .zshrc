# ~/.zshrc


########################################
# Load zsh plugins (zplug)
########################################
export ZPLUG_HOME=/usr/local/opt/zplug
if [[ ! -d $ZPLUG_HOME ]];then
  export ZPLUG_HOME=~/.zplug
fi
# zplugが無ければgitからclone
if [[ ! -d $ZPLUG_HOME ]];then
  git clone https://github.com/zplug/zplug ~/.zplug
fi

source $ZPLUG_HOME/init.zsh

# 自分自身をプラグインとして管理
zplug "zplug/zplug", hook-build:'zplug --self-manage'

zplug "chrissicool/zsh-256color"
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-history-substring-search"

zplug "plugins/git",     from:oh-my-zsh, if:"which git"
zplug "plugins/brew",    from:oh-my-zsh, if:"which brew"
zplug "plugins/tmux",    from:oh-my-zsh, if:"which tmux"

zplug "mollifier/anyframe"
zplug "mollifier/cd-gitroot"

zplug "lib/clipboard", from:oh-my-zsh, if:"[[ $OSTYPE == *darwin* ]]"
zplug "zsh-users/zsh-syntax-highlighting"

# Install zsh plugin via zplug.
if ! zplug check --verbose; then
  print "Install? [y/N]: "
  if read -q; then
    echo; zplug install
  fi
fi

zplug load

########################################
# Load configuration files.
########################################
source ~/.zshrc.base
source ~/.zshrc.prompt

########################################
## Load local configuration files.
########################################
load_local_config () {
    local filename
    filename=".zshrc.`hostname -s`"
    [ -f $HOME/$filename ] && source $HOME/$filename
    [ -f $HOME/.zshrc.test ] && source $HOME/.zshrc.test
}
load_local_config

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/nnno/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)
