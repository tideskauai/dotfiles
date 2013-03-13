#------------------------------
# Completition
#------------------------------
# Add custom completition and git scripts
fpath=($HOME/.config/zsh/autocompletitions $HOME/.config/zsh/functions $fpath)
autoload -U $HOME/.config/zsh/functions/*(:t)
source $HOME/.config/zsh/completition

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
# Settings
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

#------------------------------
# Misc
#------------------------------
if [[ $HOST == "Greno" ]]; then
    # Source functions and alias files if our hostname is 0xbeef
    source $HOME/.config/zsh/Greno-alias
    source $HOME/.config/zsh/Greno-alias-cd
    source $HOME/.config/zsh/Greno-functions
    # Don't store commands with sudo or cd in the history
    function zshaddhistory() { [[ $1 != *(sudo|cd)* ]] }
fi

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
# Allow for functions in the prompt
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

# Source of git prompt code:
# http://sebastiancelis.com/2009/11/16/zsh-prompt-git-users/
# Enable auto-execution of functions.
typeset -ga preexec_functions
typeset -ga precmd_functions
typeset -ga chpwd_functions
# Append git functions needed for prompt.
preexec_functions+='preexec_update_git_vars'
precmd_functions+='precmd_update_git_vars'
chpwd_functions+='chpwd_update_git_vars'

PROMPT='%F{green}%n%F{blue} in [${PR_PWDCOLOR}%~$PR_RESET%F{blue}] %F{red}→$PR_RESET '
RPROMPT='$(prompt_git_info)$PR_RESET %F{black}[%T]$PR_RESET'
