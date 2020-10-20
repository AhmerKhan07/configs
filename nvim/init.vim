filetype off                  " required
call plug#begin('~/.vim/plugged')

" let Vundle manage Vundle, required
" Plug 'VundleVim/Vundle.vim'
Plug 'justinmk/vim-sneak'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'junegunn/rainbow_parentheses.vim'
" Plug 'norcalli/nvim-colorizer.lua'
Plug 'rip-rip/clang_complete'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'justinmk/vim-syntax-extra'
Plug 'yuttie/comfortable-motion.vim'
Plug 'vim-airline/vim-airline'
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-commentary'
Plug 'vim-syntastic/syntastic'
Plug 'rafi/awesome-vim-colorschemes'
Plug 'kien/ctrlp.vim'
Plug 'arzg/vim-colors-xcode'
Plug 'airblade/vim-gitgutter'
Plug 'Raimondi/delimitMate'
Plug 'dense-analysis/ale'
Plug 'vim-scripts/Conque-Shell'
" Plug from http://vim-scripts.org/vim/scripts.html
" Plug 'L9'
" Git Plug not hosted on GitHub
Plug 'git://git.wincent.com/command-t.git'
Plug 'rstacruz/sparkup', {'rtp': 'vim/'}
Plug 'preservim/nerdtree'
call plug#end()
syntax enable
colorscheme molokai
set termguicolors
runtime! debian.vim

"lua require'plug-colorizer'
lua require'plug-treesitter'

set wildmenu
set number
set incsearch
set ignorecase
set nohlsearch
set tabstop=4
set softtabstop=0
set shiftwidth=4
set clipboard=unnamedplus
set splitright
set splitbelow
set smartcase
" set cursorline
set mouse=a
set path+=**

map<C-n> :NERDTreeToggle<cr>
" In insert or command mode, move normally by using Ctrl
inoremap <C-h> <Left>
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-l> <Right>
cnoremap <C-h> <Left>
cnoremap <C-j> <Down>
cnoremap <C-k> <Up>
cnoremap <C-l> <Right>
" let g:ycm_server_python_interpreter='/usr/bin/python3.7'
" inoremap ( ()<Esc>i
" inoremap < <><Esc>i
" inoremap [ []<Esc>i
" inoremap { {}<esc>i
inoremap " ""<esc>i
inoremap ' ''<esc>i

" Pressing zj and zk duplicate a single line below and above the cursor,
" respectively. This is pretty common functionality and simple to implement.
"
" Pressing zJ and zK duplicates a "block" of code, which is defined by indent.
" In the languages from the s:indent_based_languages list, a "hanging" indent
" is taken. Example:
"
"    def one(self):
"        pass
"
" For all other languages, a "closing" line is found and the block is taken to
" be that. Examples:
"
"    def foo
"      bar
"    end
"
"    <div class="footer">
"      Text
"    </div>
"

let s:indent_based_languages = ['python', 'coffee', 'haml', 'slim']

" Duplicate lines
nnoremap zj mzyyP`z
nnoremap zk mzyyP`zk

" Duplicate blocks
nnoremap zJ :call <SID>DuplicateBlock('below')<cr>
nnoremap zK :call <SID>DuplicateBlock('above')<cr>

function! s:DuplicateBlock(direction)
  if getline('.') =~ '^\s*$'
    return
  endif

  if index(s:indent_based_languages, &filetype) >= 0
    let block = s:OpenBlock(line('.'), a:direction)
  else
    let block = s:ClosedBlock(line('.'), a:direction)
  endif

  if empty(block)
    return
  endif

  let [start, end] = block
  let lines        = getbufline('%', start, end)

  " The conditions look swapped, but this actually has the indended effect.
  " Remember that the result buffer is the same in both cases, it's the cursor
  " position that matters.
  "
  if a:direction == 'below'
    call append(start - 1, lines + [''])
  else " a:direction == 'above'
    call append(end, [''] + lines)
  endif
endfunction

" A "block" defined by indentation in an indent-based language, without a
" closing tag.
function! s:OpenBlock(start, direction)
  let start_lineno = a:start
  let base_indent  = indent(start_lineno)
  let end_lineno   = start_lineno
  let next_lineno  = nextnonblank(start_lineno + 1)

  while end_lineno < line('$') && indent(next_lineno) > base_indent
    let end_lineno  = next_lineno
    let next_lineno = nextnonblank(end_lineno + 1)
  endwhile

  return [start_lineno, end_lineno]
endfunction

" A "block" defined by a closing tag, "end", curly bracket. Detected by
" another line at the same indent.
function! s:ClosedBlock(start, direction)
  let start_lineno = a:start
  let base_indent  = indent(start_lineno)
  let end_lineno   = nextnonblank(start_lineno + 1)

  while end_lineno < line('$') && indent(end_lineno) != base_indent
    let end_lineno = nextnonblank(end_lineno + 1)
  endwhile

  if indent(start_lineno) != indent(end_lineno)
    " we have an unfinished block, don't duplicate
    return []
  endif

  return [start_lineno, end_lineno]
endfunction

nnoremap d "_d
vnoremap d "_d
map ;q :q! <cr> 

map ;p   :w<cr>:term clear && python3.8 %<cr>
map ;c   :w<cr>:term clear && gcc % && ./a.out <cr>
map ;f   :w<cr>:term clear && lex % && gcc lex.yy.c -lfl && ./a.out sample.c<cr>
map ;s   :w<cr>:bot :term clear && gcc % && ./a.out sample.c <cr>
nnoremap <c-j> <c-w><c-j>
nnoremap <c-k> <c-w><c-k>
nnoremap <c-l> <c-w><c-l>
nnoremap <c-h> <c-w><c-h>
map <Down> <Nop>
map <up> <Nop>
map <right> <Nop>
map <left> <Nop>
map <c-w> dw
map ;w :w<cr>  
inoremap ;w <esc>:w <cr>
inoremap ;e <esc>
inoremap ;E <esc>
vmap ;e <esc> 
map esc <c-\><c-n>
command! MakeTags !ctags -R .

:autocmd InsertEnter,InsertLeave * set cul!
let g:deoplete#enable_at_startup = 1
noremap <silent> <c-b> :call smooth_scroll#up(&scroll*2, 10, 4)<CR>
noremap <silent> <c-f> :call smooth_scroll#down(&scroll*2, 10, 4)<CR>2
let g:comfortable_motion_no_default_key_mappings = 1
let g:comfortable_motion_impulse_multiplier = 7  " Feel free to increase/decrease this value.
nnoremap <silent> <C-d> :call comfortable_motion#flick(g:comfortable_motion_impulse_multiplier * winheight(0) * 2)<CR>
nnoremap <silent> <C-u> :call comfortable_motion#flick(g:comfortable_motion_impulse_multiplier * winheight(0) * -2)<CR>
nnoremap <silent> <C-f> :call comfortable_motion#flick(g:comfortable_motion_impulse_multiplier * winheight(0) * 4)<CR>
nnoremap <silent> <C-b> :call comfortable_motion#flick(g:comfortable_motion_impulse_multiplier * winheight(0) * -4)<CR>
let g:comfortable_motion_friction = 700
let g:comfortable_motion_air_drag = 15

let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1
let g:python3_host_prog = '/usr/local/bin/python3.8'
" let g:deoplete#enable_at_startup = 1

set undodir=~/.vim/undo
set undofile

" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
imap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
imap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of LS, ex: coc-tsserver
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>
let g:sneak#label = 1

" case insensitive sneak
let g:sneak#use_ic_scs = 1

" immediately move to the next instance of search, if you move the cursor sneak is back to default behavior
let g:sneak#s_next = 1

" remap so I can use , and ; with f and t
map gS <Plug>Sneak_,
map gs <Plug>Sneak_;

" Change the colors
highlight Sneak guifg=black guibg=#00C7DF ctermfg=black ctermbg=cyan
highlight SneakScope guifg=red guibg=yellow ctermfg=red ctermbg=yellow
