#!/bin/sh

# Start custom bind of keys
if [ -f $HOME/.config/xmodmap ]; then
    xmodmap $HOME/.config/xmodmap
fi

# Start gnome-keyring
eval `gnome-keyring-daemon`
export GNOME_KEYRING_PID
export GNOME_KEYRING_SOCKET
export SSH_AUTH_SOCK
export GPG_AGENT_INFO

# Let's set a pointer
xsetroot -cursor_name left_ptr

# Fonts
xset +dpms +fp /usr/share/fonts/local,/usr/share/fonts/artwiz-fonts
# Turn the bell off
xset -b

# Start custom settings for urxvt
xrdb -merge ~/.config/Xresources

# Let's start udiskie (udisks wrapper)
udiskie -s &

# Use $XDG_RUNTIME_DIR for some folders
mkdir -p $XDG_RUNTIME_DIR/{adobe,macromedia}
ln -sfn $XDG_RUNTIME_DIR/adobe ~/.adobe
ln -sfn $XDG_RUNTIME_DIR/macromedia ~/.macromedia

# Launch xmonad OR i3
exec xmonad
# exec i3
