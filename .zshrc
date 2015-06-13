# ~/.zshrc 

source $HOME/.zshrc.antigen
source $HOME/.zshrc.base
source $HOME/.zshrc.prompt

########################################
## Load other configuration files.
########################################
load_local_config () {
    local filename
    filename=".zshrc.`hostname -s`"
    [ -f $HOME/$filename ] && source $HOME/$filename
    [ -f $HOME/.zshrc.test ] && source $HOME/.zshrc.test
}
load_local_config

