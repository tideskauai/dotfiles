if [[ -z $DISPLAY && $(tty) = /dev/tty1 ]]; then

   # if [[ $HOST = "Greno" ]]; then
   #     keychain id_ecdsa.Edinburgh
   #     source ~/.keychain/$HOST-sh
   # fi

    exec startx
    # exec startx &>> ~/Archives/txt/xlog
fi
