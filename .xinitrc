#!/bin/sh

# Start custom bind of keys
if [ -f $HOME/.config/xmodmap ]; then
    xmodmap $HOME/.config/xmodmap
fi

# start gnome-keyring
eval `gnome-keyring-daemon`
export GNOME_KEYRING_PID
export GNOME_KEYRING_SOCKET
export SSH_AUTH_SOCK
export GPG_AGENT_INFO

# fonts
xset +dpms +fp /usr/share/fonts/local,/usr/share/fonts/artwiz-fonts

# Start custom settings for urxvt
xrdb -merge ~/.Xresources

# # Start the trayer
#  trayer --edge top \
#      --align center \
#      --SetDockType true \
#      --SetPartialStrut true \
#      --width 3 \
#      --height 2 \
#      --transparent true \
#      --alpha 0 \
#      --tint '0x161616' &

# Let's set a pointer
xsetroot -cursor_name left_ptr

# Launch xmonad
exec xmonad
# Launch i3
# exec i3
