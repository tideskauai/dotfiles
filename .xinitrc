#!/bin/sh

# Start custom bind of keys
if [ -f $HOME/.xmodmap ]; then
    xmodmap ~/.xmodmap
fi

# Start custom settings for urxvt
xrdb -merge ~/.Xresources

# Start the trayer
trayer --edge top --align center --SetDockType true --SetPartialStrut true \
    --width 3 --height 2 --transparent true --alpha 0 --tint '0x161616' &

# Start urxvt in daemon mode
# This waits till the control socket is available, opens the current
# display and forks into the background.
# When you log-out, the server is reset and urxvtd is killed.
(sleep 2 && urxvtd -q -f -o) &

# Start osmo (personal organizer tool)
(sleep 60 && osmo) &
# Start hamster-time-tracker
(sleep 60 && hamster-time-tracker) &

# Let's set a pointer
xsetroot -cursor_name left_ptr

# Launch xmonad
exec ck-launch-session xmonad
