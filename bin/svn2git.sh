#!/bin/sh
#svn2git.sh <sourcedump> [<sourcepath>]
#Copyright (c) 2015 GlobalMentor, Inc.
#Converts a path in a given Subversion dump file to Git.
#  <sourcedump>: The name of the source Subversion dump file.
#  [<sourcepath>]: The optional repository path to convert to Git, excluding all other paths and making it the root path.
#  output: path-base-name.git: Converted Git repository.
#Recommended files: authors.txt
#Optional files added to repository: .gitattributes, .gitignore, authors.txt, contributors.txt
#Requires: svndumpsanitizer, subgit, git
sourcedump=$1
sourcepath=$2
workpath=$PWD
set -e
#
# sanitize the Subversion dump if a sourcepath was given
#
if [ -n "$sourcepath" ]; then
  repo=$(basename $sourcepath)
  cleandump=${repo}.dump
  svndumpsanitizer --drop-empty --add-delete --infile $sourcedump --outfile $cleandump --include $sourcepath
else
  repo=$(basename $sourcedump)
  repo=${repo%.*}
  cleandump=${repo}.temp.dump
  cp $sourcedump $cleandump
fi
#
# create Subversion repository
#
svnadmin create ${repo}-svn
svnadmin load ${repo}-svn < $cleandump
#
# convert Subversion repository to Git
# if sourcepath was given, use that as the single directory;
# otherwise attempt to detect layout
#
if [ -n "$sourcepath" ]; then
  subgit configure --svn-url file://${workpath}/${repo}-svn --layout directory ${repo}.git
else
  subgit configure --svn-url file://${workpath}/${repo}-svn ${repo}.git
fi
#turn of EOL processing during conversion
git config -f ${repo}.git/subgit/config translate.eols false
if [ -f authors.txt ];
then
  cp authors.txt ${repo}.git/subgit
fi
subgit install ${repo}.git
subgit uninstall --purge ${repo}.git
rm -rf ${repo}-svn
rm $cleandump
#
# normalize eols
#
pushd ${repo}.git
eval git filter-branch --tree-filter '${workpath}/tree-normalize-eol-lf.sh' -- --all
popd
#
# clone to repo-git
#
git clone ${repo}.git ${repo}-git
pushd ${repo}-git
#
# redefine root if sourcepath was given
#
if [ -n "$sourcepath" ]; then
  git mv ${sourcepath}/* .
  git commit -m "Redefined the root of the repository after conversion from Subversion."
  git push
fi
#
# add .gitattributes and/or .gitignore
#
if [ -f ../.gitattributes ] || [ -f ../.gitignore ]; then
  if [ -f ../.gitattributes ]; then
    cp ../.gitattributes .
    git add .gitattributes
  fi
  if [ -f ../.gitignore ]; then
    cp ../.gitignore .
    git add .gitignore
  fi
  git commit -m "Added default Git files."
  git push
fi
#
# add contributors.txt
#
if [ -f ../contributors.txt ]; then
  cp ../contributors.txt .
  git add contributors.txt
  git commit -m "Added contributors file."
  git push
fi
#
# remove repo-git
#
popd
rm -rf ${repo}-git
