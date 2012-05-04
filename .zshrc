#------------------------------
# Variables
#------------------------------
export EDITOR="vim"
export VISUAL="vim"
export PATH="${PATH}:${HOME}/.config/owncfg/bin"
export PAGER="less"
# Color man pages
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# Add custom completition scripts
fpath=(~/.zsh/autocompletitions $fpath)

#-----------------------------
# Dircolors
#-----------------------------
LS_COLORS='rs=0:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:tw=30;42:ow=34;42:st=37;44:ex=01;32:';
export LS_COLORS

#------------------------------
# Keybindings
#------------------------------
stty -ixon #disables ctrl+q and ctrl+s for pause&unpause
bindkey -e
bindkey ' ' magic-space # also do history expansion on space     
bindkey "^[[3~" delete-char
bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward

#------------------------------
# Misc options
#------------------------------
MAILCHECK=0                 # Disable mail checking
HISTFILE=~/.histfile        # The file to store the history
HISTSIZE=1000               # The internal history's size
SAVEHIST=1000               # The file history's size
#setopt COMPLETE_IN_WORD     # If unset, the cursor is set to the end of the word
                            # if completion is started. Otherwise it stays there
                            # and completion is done from both ends.
setopt CORRECT              # Try  to  correct the spelling of commands
setopt hist_ignore_dups     # Don't save same line in the history
setopt hist_verify          # Verify when using history
setopt hist_no_store        # Don't store the `history` command
setopt hist_ignore_space    # Don't store commands starting with a space
setopt NO_BEEP              # Don't beep
setopt extendedglob         # Treat  the  `#',  `~' and `^' characters as part
                            # of patterns for filename generation, etc
setopt nomatch              # Print error when pattern for filename generates
                            # no matches
#setopt nonomatch            # Don't print error on non matched patterns
setopt notify               # Report status of background jobs immediately
setopt noclobber            # Requires >! to overwrite existing files

# Don't store commands with sudo in the history
function zshaddhistory() { [[ $1 != *sudo* ]] }

#------------------------------
# Completition 
#------------------------------
source $HOME/.zsh/completition

#------------------------------
# Alias stuff
#------------------------------
case $OSTYPE in
    linux*)
        source $HOME/.zsh/alias
        source $HOME/.zsh/functions
        ;;
    freebsd*)
        source $HOME/.zsh/fbsd
        ;;
esac

#------------------------------
# Window title
#------------------------------
if [[ $TERM = rxvt* ]]; then
    precmd () { print -Pn "\e]0;%n@%M [%~]\a" } 
    preexec () { print -Pn "\e]0;%n@%M [%~] ($1)\a" }
fi

#------------------------------
# Prompt
#------------------------------
# set up colors
autoload -U colors && colors
setopt prompt_subst

for COLOR in RED GREEN YELLOW WHITE BLACK CYAN BLUE PURPLE; do
    eval PR_$COLOR='%{$fg[${(L)COLOR}]%}'
    eval PR_BRIGHT_$COLOR='%{$fg_bold[${(L)COLOR}]%}'
done 
PR_RESET="%{${reset_color}%}"; 

precmd(){

    # lets change the color of the path if it's not writable
    if [[ -w $PWD ]]; then
        PR_PWDCOLOR="%F{yellow}"
    else
        PR_PWDCOLOR="${PR_BRIGHT_RED}"
    fi
}

PROMPT='%F{green}%n%F{blue} in [${PR_PWDCOLOR}%~$PR_RESET%F{blue}] %F{red}→$PR_RESET '
RPROMPT='%F{black}[%T]$PR_RESET'
