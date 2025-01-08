" Install vim-plug if not already installed
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Define plugins
call plug#begin('~/.vim/plugged')
" Colorscheme
Plug 'bluz71/vim-moonfly-colors'     " Moonfly theme
" Fuzzy finder
Plug 'ctrlpvim/ctrlp.vim'
" Python LSP and completion
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
call plug#end()

" Leader key configuration
let mapleader = ' '

" Basic settings
set clipboard=unnamedplus  " Use system clipboard
set number                 " Show line numbers
set noswapfile            " Disable swap file
set breakindent           " Enable break indent
set ignorecase            " Case-insensitive searching
set smartcase             " Smart case searching
set signcolumn=yes        " Keep signcolumn on
set updatetime=250        " Decrease update time
set timeoutlen=300        " Timeout length
set splitright            " Split windows right
set splitbelow            " Split windows below
set incsearch             " Show matches as you type
set cursorline            " Show cursor line
set scrolloff=15          " Keep 15 lines above/below cursor
set hlsearch              " Highlight search results
set termguicolors         " Enable true colors support
set background=dark       " Set dark mode

" Colorscheme configuration
let g:moonflyCursorColor = 1
let g:moonflyTerminalColors = 1
let g:moonflyUnderlineMatchParen = 1
colorscheme moonfly

" Key mappings
" Clear search highlighting
nnoremap <Esc> :nohlsearch<CR>

" Diagnostic mappings
nnoremap [d :LspPreviousDiagnostic<CR>
nnoremap ]d :LspNextDiagnostic<CR>
nnoremap <leader>e :LspDocumentDiagnostics<CR>
nnoremap <leader>q :LspDocumentDiagnostics<CR>

" Window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Window resizing
nnoremap <C-w>h <C-w><
nnoremap <C-w>l <C-w>>
nnoremap <C-w>k <C-w>+
nnoremap <C-w>j <C-w>-

" Insert current date
nnoremap :curdate "=strftime("%d-%m-%Y")<CR>P

" Highlight yanked text
augroup highlight_yank
    autocmd!
    au TextYankPost * silent! lua vim.highlight.on_yank{higroup="IncSearch", timeout=200}
augroup END

" Source LSP configuration
if filereadable(expand('~/.vim/config/lsp.vim'))
    source ~/.vim/config/lsp.vim
else
    echom "Warning: ~/.vim/config/lsp.vim not found!"
endif

" Enable LSP debug messages
let g:lsp_log_verbose = 1
let g:lsp_log_file = expand('~/vim-lsp.log')

" CtrlP settings
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
