@ECHO OFF
REM Maven Use Release Versions by Garret Wilson
REM Copyright (c) 2022 GlobalMentor, Inc.

CALL mvn versions:use-releases -DprocessParent -DgenerateBackupPoms=false
