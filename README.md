# vim-esformatter

makes it easier to execute [esformatter](https://github.com/millermedeiros/esformatter/)
inside vim.

it's better than executing a simple
[`:%!esformatter`](http://vimdoc.sourceforge.net/htmldoc/various.html#:!) on
normal mode because it avoids replacing the buffer content if the script
detected any errors, it restores the cursor position and sets the working
directory to match the file (which changes the way esformatter looks for config
files).

it was inspired by [nisaacson esformatter
plugin](https://gist.github.com/nisaacson/6939960).


## Installation

You will need the esformatter binary available in your path to run the command

```
npm install -g esformatter
```

After that you can use [Vundle](https://github.com/gmarik/Vundle.vim),
[pathogen.vim](https://github.com/tpope/vim-pathogen) or manually copy the
`plugin/esformatter.vim` file into your `~/.vim/plugin` folder to install it.


## Usage

To format the whole file simple call `:Esformatter` while on normal mode.

To format just one block of code select it on visual mode and execute
`:'<,'>EsformatterVisual`.

To make it easier you can create a mapping on your `.vimrc` file like:

```vim
" will run esformatter after pressing <leader> followed by the 'e' and 's' keys
nnoremap <silent> <leader>es :Esformatter<CR>
vnoremap <silent> <leader>es :EsformatterVisual<CR>
```


## License

released under the [wtfpl](http://sam.zoy.org/wtfpl/COPYING) license
