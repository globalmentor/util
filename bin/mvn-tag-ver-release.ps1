#!/usr/bin/env pwsh
# Maven Tag Version Release by Garret Wilson
# Copyright © 2022 GlobalMentor, Inc.

$ver = mvn-get-ver
git tag v${ver} -m "Released version ${ver}."
