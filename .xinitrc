#!/bin/sh
xmodmap ~/.xmodmap
xrdb -merge ~/.Xresources
(sleep 2 && urxvtd) &
trayer --edge top --align center --SetDockType true --SetPartialStrut true --width 3 --height 2 --transparent true --alpha 0 --tint '0x161616' &
xsetroot -cursor_name left_ptr
exec ck-launch-session xmonad
