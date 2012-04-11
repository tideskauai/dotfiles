#!/bin/sh
xmodmap ~/.xmodmap
xrdb -merge ~/.Xresources
(sleep 2 && urxvtd) &
xsetroot -cursor_name left_ptr
exec ck-launch-session xmonad
