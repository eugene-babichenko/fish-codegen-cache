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

You can install it with your favourite package manager by pointing to this
repository:

    fisher install eugene-babichenko/fish-codegen-cache
