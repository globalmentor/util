#!/usr/bin/env pwsh
# Maven Prepare Release by Garret Wilson
# Copyright © 2022 GlobalMentor, Inc.

$ErrorActionPreference = "Stop"

if (git status --porcelain) {
  throw "Git status must be clean before preparing for release."
}

$prereleaseVer = mvn-get-ver
if (!$prereleaseVer.EndsWith("-SNAPSHOT")) {
  throw "Only ``-SNAPSHOT`` versions can be prepared for release; current version is ${prereleaseVer}."
}

mvn-use-release-vers
mvn-remove-ver-snapshot
$ver = mvn-get-ver
git commit -am "Prepared project for v${ver} release."
mvn-list-outdated-dependencies

Write-Host "`nProject version ${ver} prepared for release.`n" -ForegroundColor Cyan
