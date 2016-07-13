#!/bin/sh
#svn2git-all.sh <sourcedump> <sourcepaths.lst>
#Copyright (c) 2015 GlobalMentor, Inc.
#Converts a list of paths in a given Subversion dump file to Git.
#  <sourcedump>: The name of the source Subversion dump file.
#  <sourcepaths.lst>: The file containing paths path to convert to Git,
#     each excluding all other paths and making it the root path.
#  output: path-base-name.git: Converted Git repository.
#Requires: svn2git.sh
set -e
while read -r sourcepath; do
  echo
  echo
  echo
  echo \*\*\* Converting $sourcepath ...
  ./svn2git.sh $1 $sourcepath
done < $2
