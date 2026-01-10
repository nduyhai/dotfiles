set nocompatible
set encoding=utf-8
set hidden

" UI
set number
set relativenumber
set ruler
set showcmd
set cursorline
set nowrap
set termguicolors

" Indent
set tabstop=2
set shiftwidth=2
set expandtab
set smartindent

" Search
set ignorecase
set smartcase
set incsearch
set hlsearch

" Quality of life
set backspace=indent,eol,start
set clipboard=unnamed
set wildmenu
set wildmode=longest:full,full
set updatetime=300

" Files
set undofile
set undodir=~/.vim/undo//
set backupdir=~/.vim/backup//
set directory=~/.vim/swap//

silent !mkdir -p ~/.vim/undo ~/.vim/backup ~/.vim/swap >/dev/null 2>&1

" Keymaps
nnoremap <Space> <Nop>
let mapleader=" "

nnoremap <Leader>w :w<CR>
nnoremap <Leader>q :q<CR>
nnoremap <Leader>h :nohlsearch<CR>

" Better defaults for Go/Git commits
autocmd FileType gitcommit setlocal spell textwidth=72
autocmd FileType markdown setlocal wrap linebreak
