#!/usr/bin/env pwsh
# Maven Perform Release by Garret Wilson
# Copyright © 2022 GlobalMentor, Inc.
# Assumes the Maven project has a `publish` profile.

$ErrorActionPreference = "Stop"

if (git status --porcelain) {
  throw "Git status must be clean before release."
}

mvn clean deploy -P publish
if ($LASTEXITCODE) {
  throw "Maven did not deploy successfully."
} 
mvn-tag-ver-release
$ver = mvn-get-ver

Write-Host "`nProject version ${ver} released.`n" -ForegroundColor Cyan
