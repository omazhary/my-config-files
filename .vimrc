set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" Omnicomplete revisited for vim
Plugin 'Shougo/neocomplete.vim'
let g:neocomplete#enable_at_startup = 1
" Plugin for bracket autocomplete
Plugin 'Raimondi/delimitMate'
" Plugin on GitHub repo
Plugin 'airblade/vim-gitgutter'
" Plugin for python autocomplete
Plugin 'davidhalter/jedi-vim'
" Plugin for ruby and rails autocomplete
Plugin 'vim-ruby/vim-ruby'
Plugin 'tpope/vim-rails'
autocmd FileType ruby,eruby set omnifunc=rubycomplete#Complete
autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1
autocmd FileType ruby,eruby let g:rubycomplete_rails = 1
autocmd FileType ruby compiler ruby
" Plugin for markdown
Plugin 'godlygeek/tabular'
Plugin 'plasticboy/vim-markdown'
" Plugin for latex
Plugin 'jcf/vim-latex'
" Plugin for golang
Plugin 'fatih/vim-go'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
filetype plugin on
" show existing tab with 4 spaces width
set tabstop=4
" " when indenting with '>', use 4 spaces width
set shiftwidth=4
" " On pressing tab, insert 4 spaces
set expandtab
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

" Activiate Omni-Complete
filetype plugin on
set omnifunc=syntaxcomplete#Complete
" Show line numbers
set number
" Highlight current line
set cursorline
" Show preferred line width
set colorcolumn=80
" Set color palette
set t_Co=256
" Fix backspace issue
set backspace=indent,eol,start
" Enable syntax highlighting
syntax on
" Show unnecessary whitespace
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()
" Fix tabbing for yaml files
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
" Disable foldability
set nofoldenable
