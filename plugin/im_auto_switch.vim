" vim-im-auto-switch
" Auto switch input source for Vim / MacOS using im-select

if exists('g:loaded_im_auto_switch')
  finish
endif
let g:loaded_im_auto_switch = 1

" ==============================
" Default config
" ==============================

if !exists('g:im_auto_switch_enabled')
  let g:im_auto_switch_enabled = 1
endif

if !exists('g:im_auto_switch_english')
  let g:im_auto_switch_english = 'com.apple.keylayout.ABC'
endif

if !exists('g:im_auto_switch_last')
  let g:im_auto_switch_last = g:im_auto_switch_english
endif

if !exists('g:im_auto_switch_updatetime')
  let g:im_auto_switch_updatetime = 1000
endif

if !exists('g:im_auto_switch_use_cursorhold')
  let g:im_auto_switch_use_cursorhold = 1
endif

" Optional:
" let g:im_auto_switch_im_select_path = '/usr/local/bin/im-select'
if !exists('g:im_auto_switch_im_select_path')
  let g:im_auto_switch_im_select_path = 'im-select'
endif

" ==============================
" Internal helpers
" ==============================

function! s:Enabled() abort
  return get(g:, 'im_auto_switch_enabled', 1)
endfunction

function! s:CommandExists() abort
  return executable(g:im_auto_switch_im_select_path)
endfunction

function! s:GetInputSource() abort
  if !s:CommandExists()
    return ''
  endif

  return trim(system(g:im_auto_switch_im_select_path))
endfunction

function! s:SetInputSource(source) abort
  if !s:CommandExists()
    return
  endif

  if empty(a:source)
    return
  endif

  call system(g:im_auto_switch_im_select_path . ' ' . shellescape(a:source))
endfunction

function! s:IsInsertLikeMode() abort
  let l:mode = mode()
  return l:mode ==# 'i' || l:mode ==# 'R'
endfunction

" ==============================
" Core functions
" ==============================

function! im_auto_switch#save_and_set_english() abort
  if !s:Enabled()
    return
  endif

  let g:im_auto_switch_last = s:GetInputSource()

  if g:im_auto_switch_last !=# g:im_auto_switch_english
    call s:SetInputSource(g:im_auto_switch_english)
  endif
endfunction

function! im_auto_switch#set_english() abort
  if !s:Enabled()
    return
  endif

  call s:SetInputSource(g:im_auto_switch_english)
endfunction

function! im_auto_switch#restore_last_input() abort
  if !s:Enabled()
    return
  endif

  let l:current_input_source = s:GetInputSource()

  if l:current_input_source !=# g:im_auto_switch_last
    call s:SetInputSource(g:im_auto_switch_last)
  endif
endfunction

function! im_auto_switch#save_input_if_insert() abort
  if !s:Enabled()
    return
  endif

  if s:IsInsertLikeMode()
    let g:im_auto_switch_last = s:GetInputSource()
  endif
endfunction

function! im_auto_switch#smart_focus_switch() abort
  if !s:Enabled()
    return
  endif

  let l:current_system_im = s:GetInputSource()

  if s:IsInsertLikeMode()
    if l:current_system_im !=# g:im_auto_switch_last
      call im_auto_switch#restore_last_input()
    endif
  else
    if l:current_system_im !=# g:im_auto_switch_english
      call s:SetInputSource(g:im_auto_switch_english)
    endif
  endif
endfunction

" ==============================
" User commands
" ==============================

command! ImAutoSwitchEnable  let g:im_auto_switch_enabled = 1
command! ImAutoSwitchDisable let g:im_auto_switch_enabled = 0
command! ImAutoSwitchEnglish call im_auto_switch#set_english()
command! ImAutoSwitchRestore call im_auto_switch#restore_last_input()

" ==============================
" Setup
" ==============================

if g:im_auto_switch_enabled
  let &updatetime = g:im_auto_switch_updatetime
endif

augroup VimInputAutoSwitch
  autocmd!
  autocmd FocusLost   * call im_auto_switch#save_input_if_insert()
  autocmd InsertLeave * call im_auto_switch#save_and_set_english()
  autocmd InsertEnter * call im_auto_switch#restore_last_input()
  autocmd FocusGained * call im_auto_switch#smart_focus_switch()

  if get(g:, 'im_auto_switch_use_cursorhold', 1)
    autocmd CursorHoldI * call im_auto_switch#save_input_if_insert()
  endif

  " NOTE:
  " CmdlineLeave can be triggered while insert-mode IM state is still relevant.
  " Enable manually only if you really want this behavior.
  "
  " autocmd CmdlineLeave * call im_auto_switch#set_english()
augroup END
