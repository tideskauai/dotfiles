# Set secure umask
umask 077

# Constant environment variables {{{
export EDITOR="vim"
export VISUAL="vim"
export PATH="${PATH}:${HOME}/dev/bin"
export PAGER="less"

# Color man pages
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# Colors
export GREP_OPTIONS='--color=auto'

# Highest compression
export GZIP=-9 \
  BZIP=-9 \
  XZ_OPT=-9

# Set location of gtk2 gtkrc (also needed for Qt's gtk style)
export GTK2_RC_FILES=~/.config/gtk-2.0/gtkrc

# For the interactive python interpreter
export PYTHONSTARTUP="${HOME}/.config/pystartup"
# }}}
