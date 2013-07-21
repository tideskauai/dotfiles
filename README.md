# License
Feel free to use and modify anything on this repo as you wish.

# How to clon the repo
`git clone https://github.com/ballmerpeak/dotfiles.git ~/.dotfiles`

# Dependencies
- dev/clipsync requires xclip and dmenu
- dev/bin/VM requires qemu
- dev/bin/alarm requires mplayer
- dev/bin/backup requires rsync
- dev/bin/bridgemeup requires iproute2 and bridge-utils
- dev/bin/firewall requires iptables and arptables
- dev/bin/movies-time requires xorg-xset
- dev/bin/v requires dtach and vim

# Vim specifics

Plugins
--------
List of plugins I use:
- [ultisnips](https://github.com/SirVer/ultisnips)
- [NERDtree](https://github.com/vim-scripts/The-NERD-tree)
- [gist-vim](https://github.com/mattn/gist-vim)
- [tabular](https://github.com/godlygeek/tabular.git)
- [commentary](https://github.com/tpope/vim-commentary)

Install as git submodule
------------------------
```
mkdir -p .vim/{autoload,bundle,backup,swap}
git submodule add git://github.com/SirVer/ultisnips.git .vim/bundle/ultisnips
git submodule add git://github.com/scrooloose/nerdtree.git .vim/bundle/nerdtree
git submodule add git://github.com/mattn/gist-vim .vim/bundle/gist-vim
git submodule add git://github.com/mattn/webapi-vim .vim/bundle/webapi-vim
git submodule add git://github.com/godlygeek/tabular.git .vim/bundle/tabular
git submodule add git://github.com/tpope/vim-commentary.git .vim/bundle/vim-commentary
```

Update all/single vim plugins
----------------------
- git submodule foreach git pull origin master
- cd .vim/bundle/example && git pull origin master
