# vim-fortran-fpm

**THIS IS IN VERY ALPHA STAGE AND PROBABLY DOES NOT WORK**

## WHat is it

It is a set of files making working with [fortran package manager](https://fpm.fortran-lang.org/) projects in vim easier.

## How to install

### Vim-plug

This is the recommeded way. The right incantation is `Plug "avysk/vim-fortran-fpm`.

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

The plugin includes a bunch of functions which will be autoloaded upon the first use. Just use `:call fortran#fpm#FooBar`. I recommend binding calls to some keys.

The following table lists all defined functions roughly in the order they are meant to be used.
