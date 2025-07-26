#!/bin/bash
# Maven Prepare Develop by Garret Wilson
# Copyright © 2023 GlobalMentor, Inc.

set -u

usage() {
  echo 'mvn-prepare-develop' >&2
  echo 'Usage: mvn-prepare-develop <new-version> [--all]' >&2
  echo 'Updates the version number(s) in a Maven POM and all child POMS to the'
  echo '    `-SNAPSHOT` version of the new version and commits the change.' >&2
  echo 'If `--all` is specified, all submodules will be updated even if they are not children.' >&2
}

args=()
all=""
while [ $# -gt 0 ]; do
  case "$1" in
    --all) all=-all; shift;;
    --help) usage; exit 0;;
    --) shift; while [ $# -gt 0 ]; do args+=("$1"); shift; done; break;;
    --*) echo "$(tput bold)Bad parameter: $1$(tput sgr0)" >&2; usage; exit 1;;
    *) args+=("$1"); shift;;
  esac
done

if [[ ${#args[@]} -ne 1 ]]; then
  echo "$(tput bold)Incorrect number of arguments: ${#args[@]}$(tput sgr0)" >&2
  usage
  exit 1
fi

if [[ $(git status --porcelain) ]]; then
  echo "Git status must be clean before preparing for development." >&2
  exit 1
fi

oldVer=$(mvn-get-ver.sh) || exit
if [[ $oldVer == *-SNAPSHOT ]]; then
  echo "Only non \`-SNAPSHOT\` versions can be prepared for development; current version is $oldVer." >&2
  exit 1
fi

ver=${args[0]}
snapshotVer=$ver-SNAPSHOT
mvn-set-ver.sh $snapshotVer $all || exit
git commit -am "Prepared project for v${ver} development." || exit

echo
echo "$(tput setaf 6)Project version ${ver} prepared for development.$(tput sgr0)"
