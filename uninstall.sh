#!/usr/bin/env bash

for folder in configs/*; do
    stow -D -v -t $HOME $folder \
        2> >(grep -v 'BUG in find_stowed_path? Absolute/relative mismatch' 1>&2) \
        2> >(grep -v 'Planning unstow of package' 1>&2) \
        2> >(grep -v 'stow dir path relative to target' 1>&2) \
        2> >(grep -v 'stow dir is' 1>&2) \
        2> >(grep -v 'Processing tasks' 1>&2) \
        2> >(grep -v 'did not exist to be unstowed' 1>&2) \
        2> >(grep -v 'firefox' 1>&2)
        # 2> >(grep -v 'UNLINK' 1>&2)
    # echo "[-] UNLINK :: $folder"
done
