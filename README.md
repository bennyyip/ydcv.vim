# vim-youdao
ydcv in Vim, with Vim8 async api.

---
## Dependency
* ydcv

## Usage
* In normal mode, run `:Ydcv` will translate the word under cursor
* In visual mode, run `:Ydcv` will translate the select word or sequence
* Furthermore, you can translate just use command `:Ydcv word-want-to-translate`

For convinent usage, use key map is nessasary, just like:
```vim
nnoremap <leader>oy :<c-u>Ydcv<CR>
xnoremap <leader>oy :<c-u>Ydcv<CR>
```

## See Also
https://github.com/vimers/vim-youdao  
https://github.com/farseerfc/ydcv-rs  
https://github.com/felixonmars/ydcv
