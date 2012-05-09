Here are my vim config files.

Plugins
-------

List of plugins I use:
- [ultisnips](https://github.com/SirVer/ultisnips)
- [NERDtree](https://github.com/vim-scripts/The-NERD-tree)
- [gist-vim](https://github.com/mattn/gist-vim)
- [tabular](https://github.com/godlygeek/tabular.git)
- [commentary](https://github.com/tpope/vim-commentary)

Install
-------

````
mkdir -p ~/.vim/{autoload,bundle} && \
cd ~/.vim/autoload && \
wget https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim

cd ~/.vim/bundle && \
git clone git://github.com/SirVer/ultisnips.git && \
git clone git://github.com/scrooloose/nerdtree.git && \
git clone git://github.com/mattn/gist-vim && \
git clone git://github.com/mattn/webapi-vim && \
git clone git://github.com/godlygeek/tabular.git && \
git clone git://github.com/tpope/vim-commentary.git
````
