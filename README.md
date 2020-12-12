# `codegen-cache`

It is a simple `fish` function to cache the output of commands until an
executable is update. Then the code is re-generated and cached again.

Its inital purpose is to make faster `config.fish` files. This is the
comparison for some vere slow command generating an alias:

```
# time thefuck --alias
# output omitted

Executed in  109.07 millis    fish           external
   usr time   88.49 millis  195.00 micros   88.30 millis
   sys time   19.92 millis   67.00 micros   19.86 millis
```

and with `codegen-cache` after the caching have been done:

```
# time codegen-cache thefuck --alias
# output omitted

Executed in    5.62 millis    fish           external
   usr time    5.02 millis    1.82 millis    3.20 millis
   sys time    2.55 millis    1.00 millis    1.55 millis
```

## Usage

Just run `codegen-cache yourcommand` to get the output of a command cached.

You can get help with `codegen-cache -h`.

Note that currently there is no option to track changes in the environment
variables or configuration files for the command being run. If you change any
of those and the change is not reflected in the cache, you can forcibly reset
the cache entry: `codegen-cache -e yourcommand`.

## Installation

You can install it with your favourite package manager by pointing to this
repository:

    fisher install eugene-babichenko/fish-codegen-cache
