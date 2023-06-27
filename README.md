# vim-fortran-fpm

## What is it

It is a set of files making working with [fortran package manager](https://fpm.fortran-lang.org/) projects in vim easier.

## How to install

### Vim-plug

This is the recommeded way. The right incantation is `Plug "avysk/vim-fortran-fpm"`.

### Manually

Make sure you have directories `autoload` and `compiler` in your vim directory. Copy plugin files there.

## Customization

You can use global variables from the following table to customize plugin behavior.

| variable                         | meaning                                             | default value |
| :------------------------------- | :-------------------------------------------------- | :------------ |
| `g:vim_fortran_fpm_fpm`          | The name of fpm tool                                | `fpm`         |
| `g:vim_fortran_fpm_gfortran`     | The name of gfortran                                | `gfortran`    |
| `g:vim_fortran_fpm_failure_hl`   | Highligt group for failure pop-ups                  | `WarningMSG`  |
| `g:vim_fortran_fpm_failure_time` | The amount of time in ms to show failure pop-up for | `5000`        |
| `g:vim_fortran_fpm_success_hl`   | Highligt group for success pop-ups                  | `Comment`     |
| `g:vim_fortran_fpm_success_time` | The amount of time in ms to show success pop-up for | `1000`        |

**Note**: if you are using Intel Fortran, you do not need neither GNU Fortran nor a correct name for it.

## What is supported

The following two compilers are supported: GNU Fortran (gfortran) and Intel Fortran (ifort). If you are using Intel, do not forget to set `FPM_FC` environmental variable.

## What is included

### Compiler definition

The plugin inculdes `gfortran_fpm.vim` compiler definiton, which defines the correct `errorformat` for doing builds with fpm. Please notice the following:

- `gfortran.vim` version 0.1.4, included in vim distribution, defines wrong `errorformat` and does not work with gfortran at all;
- `fpm` prefers to treat warnings as errors so you will never get warning messages from `fpm build`, only errors.

### Autoloaded functions

The plugin includes a bunch of functions which will be autoloaded upon the first use. Just use `:call fortran#fpm#FooBar()`. I recommend binding calls to some keys.

The following table lists all defined functions roughly in the order they are meant to be used.

| name                           | purpose                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| :----------------------------- | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `fortran#fpm#CheckTools`       | Checks that `fpm` is available. Checks that the fortran compiler, defined in `FPM_FC` environment variable is available (if it is empty, searches for `gfortan`). Returns 1 if checks were successful and 0 if not.                                                                                                                                                                                                                                                                                                                                                |
| `fortran#fpm#Setup`            | Sets the proper `makeprg` and `errorformat`. Required for most other things to work.                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| `fortran#fpm#EditToml`         | Opens `fpm.toml` in the new tab for editing. If the tab with it is already opened, switches to it.                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| `fortran#fpm#RunTests`         | Runs `fpm test` and opens a popup, informiting if the tests passed or failed. If the tests failed, the output of `fpm test` is in `g:vim_fortran_failed_tests`. While `makeprg` is set to fpm, I did not have any success with `:make test`. Teach me how to use it, if you know.                                                                                                                                                                                                                                                                                  |
| `fortran#fpm#SetRunArgs`       | Asks for arguments which have to be passed to the program when it is run or debugged. The value is stored in `g:vim_fortran_fpm_run_args`.                                                                                                                                                                                                                                                                                                                                                                                                                         |
| `fortran#fpm#Run(release)`     | Run fpm project; if the passed value is true, then in the release mode. For convenience, you probably want to use the next two functions. _Note:_ if you are using Windows, and you do not want console window with the run program close immediately when the program finishes, you might want to put `read(*, *)` in the very end of the program, so it wants for Enter before exiting.                                                                                                                                                                          |
| `fortran#fpm#RunDebugTarget`   | Run the debug version of the project.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
| `fortran#fpm#RunReleaseTarget` | Run the release version of the project.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| `fortran#fpm#StartDebugging`   | Runs the built-in termdebug plugin on the project. _Note 1_: you need termdebug loaded, so `:packadd termdebug` had to be run before. 8Note 2:* termdebug uses gdb, so obviously you need to have it installed. *Note 3:* you will need to build the project (`:make build`) before you can debug it. *note 4:* the arguments, set via `fortran#fpm#SetRunArgs`, will NOT be used. *Note 5:\* For me vim's `:Run` command to start a debugger does not work after `:Arguments` is used. Either type `r` in a debugger window or use `:TermDebugSendCommand("run")` |

## Example setup

I use the following function as autocommand for `fortran` filetype. Notice that you need to edit it.

```vimscript
function! <SID>FortranSetup()
        let g:vim_fortran_fpm_failure_hl = <something>
        let g:vim_fortran_fpm_success_hl = <something else>

        if !fortran#fpm#CheckTools()
                return 0
        endif

        call fortran#fpm#Setup()

        return 1

endfunction

augroup Fortran
        autocmd!
        autocmd FileType fortran ++once call <SID>FortranSetup()
augroup END
```

## Important note

**Working on multiple fpm projects simultaneously is not supported.**
