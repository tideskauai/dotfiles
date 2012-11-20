ZDOTDIR=~/.config/zsh

if [[ -n $DISPLAY ]]; then
    export BROWSER=firefox
else
    export BROWSER=elinks
fi
