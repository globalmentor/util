#!/bin/bash
#In Each Directory
#Copyright (c) 2017 GlobalMentor, Inc.
#see https://stackoverflow.com/a/41666956/421049

declare -a dirs

for arg in "$@"; do
  [[ "$arg" != "--do" ]] || break
  dirs+=("$arg")
  shift
done

if
  [[ "${1-}" = "--do" ]]
then
  shift
else
  echo "Error: you must separate the directory list from the command(s) using '--do'."
  exit 1;
fi

for dir in "${dirs[@]-}"; do
  pushd "$dir"
  "$@"
  popd
done
