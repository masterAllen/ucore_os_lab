#! /bin/bash

if [[ $# -eq 1 && $1 =~ [2-8] ]]; then
  new=$1
  last=$(($1-1))
else
  echo "Usage: $0 <lab_number>"
  exit 1
fi

patchfile="lab$new/lab$last.patch"
> $patchfile

# diff ignoring vim-generated comments
git co master && cp -r "lab$last" "lab${last}_master" && git co c9a3c34 && \
  diff -r -u -P -B -I '^\s*(/\*.*\*/|$)' lab$last lab${last}_master > $patchfile

# perform patch
git co master && cd lab$new && patch -p1 -u < "lab$last.patch" && \
  cd .. && rm -rf lab${last}_master $patchfile
