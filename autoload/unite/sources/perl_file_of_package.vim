" Variables  "{{{
call unite#util#set_default('g:unite_source_perl_file_of_package_max_candidates', 100)
"}}}

function! unite#sources#perl_file_of_package#define() "{{{
  return unite#util#has_vimproc() ?
    \  s:perl_file_of_package_source : []
endfunction "}}}

let s:perl_file_of_package_source = {
    \ 'name' : 'perl_file_of_package',
    \ 'description' : 'candidates files of package.',
    \ 'action_table' : {},
    \ 'max_candidastes' : g:unite_source_perl_file_of_package_max_candidates,
    \ 'hooks' : {},
    \}

function! s:perl_file_of_package_source.hooks.on_init(args, context)
endfunction

function! s:perl_file_of_package_source.gather_candidates(args, context)
    let candidates = []
    let linenr = 1
    let l:package_path = a:args[0]
    let paths = perl_file_of_package#get_paths(l:package_path)

    for line in paths
        call add(candidates, {
            \ 'word' : line,
            \ 'kind' : 'jump_list',
            \ 'action__line' : linenr,
            \ 'action__path' : line,
            \ })

        let linenr += 1
    endfor

    return candidates
endfunction
