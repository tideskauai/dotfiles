#!/bin/bash
# script based off vodik's

dotfiles=$PWD

die() {
    echo >&2 "$1" && exit 1
}

link() {
    echo "ln -fs "$dotfiles/$1" "$HOME/$1""
    if [ -f "$HOME/$1" ]; then
        echo "File "$1" already exists in filesystem, do you wish to delete it?"
        # action

    elif [ -d "$HOME/$1" ]; then
        echo "Dir "$1" already exists in filesystem, do you wish to delete it?"
        # action
    fi
#    ln -fs "$dotfiles/$1" "$HOME/$1"
}

# Deploy scriptlets {{{
dotfiles_mpd() {
    link .mpd
    link .ncmpcpp
}

dotfiles_mplayer() {
    link .mplayer
}

dotfiles_mutt() {
    link .mutt
}

dotfiles_newsbeuter() {
    link .newsbeuter
}

dotfiles_xmonad() {
    link .xmonad
    link .xmobarrc
}

dotfiles_zsh() {
    link .zshrc
    link .zsh
}

dotfiles_tmux() {
    link .tmux.conf
}

dotfiles_vim() {
    link .vimrc
    link .vim
}

dotfiles_git() {
    link .gitconfig
}

dotfiles_X() {
    link .gtkrc.mine
    link .xinitrc
    link .xmodmap
    link .Xresources
    link .zlogin
}

dotfiles_rtorrent() {
    link .rtorrent.rc
}

dotfiles_config() {
    link .config
}
# }}}

deploy() {
    while (( $# )); do
        cd $HOME && dotfiles_$1
        shift
    done
}

usage() {
    cat << HERE
Automated deploy function for dotfiles syncronization.

Supported:
HERE

    for iter in $(compgen -A function dotfiles_); do
        echo " ${iter#*_}"
    done
    exit "${1:-0}"
}

if [[ $# == 1 ]]; then
        deploy $*
else
    usage 0
fi
