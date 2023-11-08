#!/bin/bash
# Maven Perform Release by Garret Wilson
# Copyright © 2022-2023 GlobalMentor, Inc.
# Assumes the Maven project has a `publish` profile.

set -u

if [[ $(git status --porcelain) ]]; then
  echo "Git status must be clean before release." >&2
  exit 1
fi

mvn clean deploy -P publish || exit
mvn-tag-ver-release.sh || exit
ver=$(mvn-get-ver.sh) || exit

echo
echo "$(tput setaf 6)Project version ${ver} released.$(tput sgr0)"
