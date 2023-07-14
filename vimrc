"" use space key as Leader key
:let mapleader="\<Space>"

"" make arrow keys, Home, End navigate *display lines*
"" for logical lines there's j, k, 0, $
map <Home> g<Home>
map <End> g<End>
map <Up> gk
map <Down> gj
inoremap <Home> <C-O>g<Home>
inoremap <End> <C-O>g<End>
inoremap <Up> <C-O>gk
inoremap <Down> <C-O>gj

"" windows
map <F6> <c-w><c-w>

"" tabs
set showtabline=0
map <F7> :tabp<CR>
map <F8> :tabn<CR>
set tabpagemax=100

"" use OS clipboard
"" for persistence: sudo apt install parcellite
set clipboard=unnamedplus

"" remember cursor position, but not when editing Git/Subversion commit
"" messages (expand("%:t") is current filename)
autocmd BufReadPost * if expand("%:t") != "COMMIT_EDITMSG" && expand("%:t") != "svn-commit.tmp" && line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\" zz" | endif

"" building
set autowrite

"" ruler - nobody cares about bytes
set rulerformat=%l,%v%=%P

"" commands to paste as lines or as characters
"" http://vim.wikia.com/wiki/Unconditional_linewise_or_characterwise_paste
function! Paste(regname, pasteType, pastecmd)
  let reg_type = getregtype(a:regname)
  call setreg(a:regname, getreg(a:regname), a:pasteType)
  exe 'normal "'.a:regname . a:pastecmd
  call setreg(a:regname, getreg(a:regname), reg_type)
endfunction
nmap <Leader>lP :call Paste(v:register, "l", "P")<CR>
nmap <Leader>lp :call Paste(v:register, "l", "p")<CR>
nmap <Leader>cP :call Paste(v:register, "v", "P")<CR>
nmap <Leader>cp :call Paste(v:register, "v", "p")<CR>

"" start visual mode with the terminator of the current line highlighted
nmap <Leader>v $vlol
nmap <Leader><C-v> $<C-v>lol

"" delete into blackhole
nmap <Leader>d "_d
nmap <Leader>b "_

"" LaTeX section jumping
"" http://vim.wikia.com/wiki/Section_jump_in_Latex
noremap <buffer> <silent> ]] :<c-u>call TexJump2Section( v:count1, '' )<CR>
noremap <buffer> <silent> [[ :<c-u>call TexJump2Section( v:count1, 'b' )<CR>
function! TexJump2Section( cnt, dir )
  let i = 0
  let pat = '^\s*\\\(part\|chapter\|\(sub\)*section\|paragraph\)\>\|\%$\|\%^'
  let flags = 'W' . a:dir
  while i < a:cnt && search( pat, flags ) > 0
    let i = i+1
  endwhile
  let @/ = pat
endfunction

" leave insert mode quickly
 if ! has('gui_running')
   set ttimeoutlen=10
   augroup FastEscape
     autocmd!
     au InsertEnter * set timeoutlen=0
     au InsertLeave * set timeoutlen=1000
   augroup END
 endif

"" cursorline in insert mode
:autocmd InsertEnter * set cul
:autocmd InsertLeave * set nocul

"" When pasting in visual mode, yank the replaced text to the blackhole register.
"" This way, the pasted text can easily be pasted a second time.
"" http://vim.wikia.com/wiki/Replace_a_word_with_yanked_text
xnoremap p "_dP

" Escape/unescape & < > HTML entities in range (default current line).
function! HtmlEntities(line1, line2, action)
  let search = @/
  let range = 'silent ' . a:line1 . ',' . a:line2
  if a:action == 0  " must convert &amp; last
    execute range . 'sno/&lt;/</eg'
    execute range . 'sno/&gt;/>/eg'
    execute range . 'sno/&amp;/&/eg'
  else              " must convert & first
    execute range . 'sno/&/&amp;/eg'
    execute range . 'sno/</&lt;/eg'
    execute range . 'sno/>/&gt;/eg'
  endif
  nohl
  let @/ = search
endfunction
command! -range -nargs=1 Entities call HtmlEntities(<line1>, <line2>, <args>)
noremap <silent> <Leader>h :Entities 0<CR>
noremap <silent> <Leader>H :Entities 1<CR>

" make
nmap <Leader>m :make!<CR>

"" ten left fingers
map q: :q

"" wordmotion
let g:wordmotion_prefix = '<Space>'

"" vimtex
let g:tex_flavor = 'latex'

"" disable search-as-you-type
:set noincsearch
