**perl_file_of_package.vim**
========================

a unite sourse of file list under package name on current cursor

Dependencies
============

this plugin need unite.vim

Installation
============

* locate this plugin

locate this autoload directory's file  to ~/.vim/autoload/
or if you use Neobundle.vim, write this line to your .vimrc
```vim
NeoBundle 'nakatakeshi/perl_file_of_package.vim'
```
* add key mapping

this autoload plugin give function perl_file_of_package#PerlFileOfPackage().
so add mapping setting like this line.
```vim
nnoremap ,uf :<C-u>call perl_file_of_package#PerlFileOfPackage()<CR>
```

Variables
============

`g:perl_file_of_package_perl_path`
this plugin get @INC (list of include path) using perl command.
if you use another perl command like `/path/to/another/perl` ,  use this variable.
default is 'perl'.

`g:perl_file_of_package_search_lib_dir`
this plugin add include path for search  under root_path . $some_directory
if you add some $some_directory, set this variable.
this variable needs to be array.
default is ['lib', 'inc']

How to use
============

if your vim current cursor on some package name of perl file,
when you type ,uf( if you set mapping this), then this plugin show unite source about files that under package name on your cursor.

