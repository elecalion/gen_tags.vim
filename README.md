# gen_tags.vim

  This plugin aim to simple the usage of [ctags](http://ctags.sourceforge.net/) and [gtags](http://www.gnu.org/software/global/) for Vim.<br/>
  It is used for generate and auto load exists tags.

  This plugin contains two Vim scripts.

  1. `gen_ctags.vim`

    Manage ctags db for project<br/>
    The generated ctags DB will be placed under `~/.cache/tags_dir/[foldername]`<br/>
    gen_ctags.vim will detect git root and use it as project root path.

  2. `gen_gtags.vim`

    [GNU Global](http://www.gnu.org/software/global/) use gtags-cscope with if_cscope interface in Vim.<br/>
    [GNU Global](http://www.gnu.org/software/global/) will generate **GTAGS**, **GRTAGS** and **GPATH** under the project folder.<br/>
    gen_gtags.vim will detect git root then generate GTAGS under the git root.

Generate ctags and update gtags will run in background.

If [vimproc](https://github.com/Shougo/vimproc.vim) was enabled [gen_tags.vim](https://github.com/jsfaint/gen_tags.vim) will use it.<br/>
It's good for Microsoft windows, because the CMD window is boring, even the command is running in background.

## Difference between ctags and gtags

  GNU global(aka gtags) is more powerful than ctags, which support definition, reference, calling, called, include, string and etc, but ctags only support definition.

  As we can use GNU global why did I still support ctags in this plugin?<br/>
  That's because GNU global only support 6 languages (C, C++, Yacc, Java, PHP4 and assembly) natively.<br/>
  ctags can support more languages(41 showed on the website).

  Actually global can support more languages with Pygments plugin parser, for more details please refer `PLUGIN_HOWTO.pygments` in global document.

## Installation

* Neobundle

  Add `NeoBundle 'jsfaint/gen_tags.vim'` to your vimrc<br/>
  Then launch `vim` and run `:NeobundleCheck`

  To install from command line: `vim +PluginInstall +qall`

* Vundle

  Add `Plugin 'jsfaint/gen_tags.vim'` to your vimrc<br/>
  Then launch `vim` and run `:PluginInstall`

  To install from command line: `vim +PluginInstall +qall`

* Traditional method

  Put two Vim script(`gen_tags.vim`, `gen_gtags.vim`) under `plugin` directory.

## gen_ctags.vim

### Commands

  * `:GenCtags`

    Generate ctags database

  * `:GenAll`

    Generate ctags and extend database

  * `:GenExt`

    Generate extend ctags for third-party library

  * `:EditExt`

    Edit an extend configuration file for this project, use for add third-party library ctags database

    e.g.: For libpcap under `e:\src\libpcap-1.3.0` add the following content to `ext.conf`

    ```
    e:/src/libpcap-1.3.0
    ```

  * `:ClearCtags`

    ```
    :ClearCtags      Remove tags files.
    :ClearCtags!     Remove tags files, ext.conf and the folder.
    ```

## gen_gtags.vim

  GTAGS support the third-party library by set an environment variable `GTAGSLIBPATH`<br/>
  But you can take a more straightforward way to do the same thing, by create a symbol link of the library

  * Linux/OS X

    ```
    ln -s /usr/include/ .
    ```

  * Windows

    ```
    mklink /J include C:\TDM-GCC-32\include
    ```

### Commands
  * `:GenGTAGS`

    Generate GTAGS

  * `:ClearGTAGS`

    Clear GTAGS files

### Key Mapping

  `ctrl+]` is the default mapping support by Vim for definition

  The following mapping is set for GTAGS find function which use cscope interface (`if_cscope`).
  ```
  Ctrl+\ c    Find functions calling this function
  Ctrl+\ d    Find functions called by this function
  Ctrl+\ e    Find this egrep pattern
  Ctrl+\ f    Find this file
  Ctrl+\ g    Find this definition
  Ctrl+\ i    Find files #including this file
  Ctrl+\ s    Find this C symbol
  Ctrl+\ t    Find this text string
  ```

## Variables

* `g:ctags_opts`

Set ctags options. The `-R` is set by default, so there is no need to add `-R` in `g:ctags_opts`.<br/>
The default `g:ctags_opts` is '', you need to set it in your vimrc :smile:

* `g:gtags_split`

Set gtags find display behavior. The default `g:gtags_split` is ''.<br/>
'' means don't split the display.<br/>
'h' means horizontal splitting.<br/>
'v' means vertical splitting.<br/>

----

Thanks for reading :)<br/>
If you like this plugin, please star it on github!

And one more thing, bug reports and pull-requests are greatly appreciated :)
