#!/bin/bash

dotfiles=$PWD

die() {
    echo >&2 "$1" && exit 1
}

link() {
    echo "ln -fs "$dotfiles/$1" "$HOME/$1""
#    ln -fs "$dotfiles/$1" "$HOME/$1"
}

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
    link .gitignore
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

deploy() {
    while (( $# )); do
        cd $HOME && dotfiles_$1
        shift
    done
}

if [[ $# == 1 ]]; then
    if [[ $1 = "all" ]]; then
        deploy mpd \
            mplayer \
            mutt \
            newsbeuter \
            xmonad \
            zsh \
            tmux \
            vim \
            git \
            X \
            rtorrent \
            config
    else
        deploy $*
    fi
else
    echo "I don't know what to do"
fi
