#!/bin/bash
# Maven Tag Version Release by Garret Wilson
# Copyright © 2022-2023 GlobalMentor, Inc.

set -u

ver=$(mvn-get-ver.sh) || exit
git tag v${ver} -m "Released version ${ver}."
