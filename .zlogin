if [[ -z $DISPLAY && $(tty) = /dev/tty1 ]]; then

#    if [[ $HOST = "0xbeef" ]]; then
#        keychain id_rsa.eee
#        source ~/.keychain/$HOST-sh
#    fi

    exec startx
fi
