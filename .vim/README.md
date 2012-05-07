Here are my vim config files.

Plugins
-------

List of plugins I use:
- [snipmate] []
- [NERDtree] []
- [gist-vim] []
- [tabular] []

    [snipmate]: https://github.com/garbas/vim-snipmate
    [NERDtree]: https://github.com/vim-scripts/The-NERD-tree
    [gist-vim]: https://github.com/mattn/gist-vim
    [tabular]: https://github.com/godlygeek/tabular.git

Install
-------

````
mkdir -p ~/.vim/{autoload,bundle} && \
cd ~/.vim/autoload && \
wget https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim

cd ~/.vim/bundle && \
git clone git://github.com/msanders/snipmate.vim.git && \
git clone git://github.com/scrooloose/nerdtree.git && \
git clone git://github.com/mattn/gist-vim && \
git clone git://github.com/mattn/webapi-vim && \
git clone git://github.com/godlygeek/tabular.git
````
