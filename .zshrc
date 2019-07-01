# ~/.zshrc

########################################
# Load zsh plugins (zplug)
########################################
source ~/.zplug/zplug

zplug "chrissicool/zsh-256color", of:"zsh-256color.plugin.zsh"
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-history-substring-search"

zplug "plugins/git",     from:oh-my-zsh, if:"which git"
zplug "plugins/brew",    from:oh-my-zsh, if:"which brew"
zplug "plugins/tmux",    from:oh-my-zsh, if:"which tmux"

zplug "mollifier/anyframe"
zplug "mollifier/cd-gitroot"

zplug "lib/clipboard", from:oh-my-zsh, if:"[[ $OSTYPE == *darwin* ]]"
zplug "zsh-users/zsh-syntax-highlighting", nice:10

# Install zsh plugin via zplug.
if ! zplug check --verbose; then
  print "Install? [y/N]: "
  if read -q; then
    echo; zplug install
  fi
fi

zplug load --verbose

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

