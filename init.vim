call plug#begin()
Plug 'davidhalter/jedi-vim'
Plug 'fatih/vim-go'
Plug 'fatih/vim-go'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'zchee/deoplete-jedi'
Plug 'tpope/vim-sensible'
Plug 'morhetz/gruvbox'
Plug 'ncm2/ncm2'
Plug 'roxma/nvim-yarp'
Plug 'ncm2/ncm2-bufword'
Plug 'ncm2/ncm2-path'
Plug 'terryma/vim-multiple-cursors'
Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'sheerun/vim-polyglot'
call plug#end()

set background=dark

set hidden
set number
set mouse=a
set inccommand=split

let mapleader="\<space>"
nnoremap <leader>ev :vsplit ~/.config/nvim/init.vim<cr>
nnoremap <leader>sv :source ~/.config/nvim/init.vim<cr>


let g:multi_cursor_quit_key="/<q>"

nnoremap <c-p> :Files<cr>
nnoremap <c-f> :Ag<space>

"Deoplete"

let g:deoplete#enable_at_startup = 1

let g:python3_host_prog = expand('/Users/fsimoes/.pyenv/versions/3.8.11/bin/python3')
autocmd vimenter * ++nested colorscheme gruvbox
