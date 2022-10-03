@ECHO OFF
REM Maven Prepare Release by Garret Wilson
REM Copyright (c) 2022 GlobalMentor, Inc.

CALL mvn-use-release-vers
CALL mvn-remove-ver-snapshot
CALL mvn-list-outdated-dependencies
