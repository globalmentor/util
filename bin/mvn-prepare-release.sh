#!/bin/bash
# Maven Prepare Release by Garret Wilson
# Copyright © 2022-2023 GlobalMentor, Inc.

set -eu

if [[ $(git status --porcelain) ]]; then
  echo "Git status must be clean before preparing for release." >&2
  exit 1
fi

prereleaseVer=$(mvn-get-ver.sh)
if [[ $prereleaseVer != *-SNAPSHOT ]]; then
  echo "Only \`-SNAPSHOT\` versions can be prepared for release; current version is $prereleaseVer." >&2
  exit 1
fi

mvn-use-release-vers.sh
mvn-remove-ver-snapshot.sh
ver=$(mvn-get-ver.sh)
git commit -am "Prepared project for v${ver} release."

echo
echo "$(tput setaf 6)Project version ${ver} prepared for release.$(tput sgr0)"
