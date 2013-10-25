let s:root_path = l:FindGitBranchRoot()
let s:pm_ext    = ".pm"

function! perl_file_of_package#get_paths(package_path)
    let l:package_path = a:package_path
    let s:list = []
    if exists("g:perl_file_of_package_perl_path")
      let l:script_perl = g:perl_file_of_package_perl_path
    else
      let l:script_perl = 'perl'
    endif

    "" read from @INC path
    let l:perlpath = split(system(l:script_perl . ' -e "print map { \$_ . qq{\n}} @INC"'), '\n')
    "" read from additional lib path
    if exists("g:perl_file_of_package_search_lib_dir")
      let s:search_lib_dir = g:perl_file_of_package_search_lib_dir
    else
      let s:search_lib_dir = [ 'lib', 'inc'  ]
    endif
    for i in range(0,len(s:search_lib_dir)-1)
      call add(l:perlpath,  printf('%s/%s', s:root_path, s:search_lib_dir[i]))
    endfor

    for i in range(0,len(l:perlpath)-1)
      let l:file_path = printf('%s/%s%s', l:perlpath[i], l:package_path, s:pm_ext)
      if (filereadable(l:file_path))
          call add(s:list, l:file_path)
          let l:files = split(system(printf('find %s/%s', l:perlpath[i] , l:package_path )), '\n')
          for s:file in l:files
              if (filereadable(s:file))
                  call add(s:list, s:file)
              endif
          endfor
      else
        let l:method_removed_package_path = substitute(l:package_path,'/[^(/)]*$','','g')
        let l:file_path = printf('%s/%s%s', l:perlpath[i], l:method_removed_package_path, s:pm_ext)
        if (filereadable(l:file_path))
          call add(s:list, l:file_path)
          let l:files = split(system(printf('find %s/%s', l:perlpath[i] , l:method_removed_package_path )), '\n')
          for s:file in l:files
              if (filereadable(s:file))
                  call add(s:list, s:file)
              endif
          endfor
        endif
      endif
    endfor
    return s:list
endfunction

function! perl_file_of_package#PerlFileOfPackage()
    let s:root_path = l:FindGitBranchRoot()
    let s:pm_ext    = ".pm"

    let s:save_iskeyword = &iskeyword
    setlocal iskeyword+=:
    let s:save_yank_anonymous_reg = @"

    try
        normal yiw
        let l:package_name = @"
        "" check procedure string
        if (l:package_name !~ '^[_A-Za-z0-9:]\+$')
            echo 'illegal expression'
            return
        endif

    finally
        "" back setting.
        let @" = s:save_yank_anonymous_reg
        let &iskeyword = s:save_iskeyword
    endt
    let l:package_path = substitute(l:package_name, '::','/','g')
    execute(printf("Unite perl_file_of_package:%s -input=%s", l:package_path, ''))
endfunction

function! l:FindGitBranchRoot()
    let l:cur_dir = expand("%:p")
    let s:search_root_file = '.git'

    while 1
        if l:cur_dir == ''
            return
        endif
        let l:cur_dir = substitute(l:cur_dir,'/[^(/)]*$','','g')
        if isdirectory(l:cur_dir . '/'. s:search_root_file)
            return l:cur_dir
        endif
    endwhile
    return ''
endfunction


