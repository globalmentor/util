@ECHO OFF
REM Maven Remove Version Snapshot by Garret Wilson
REM Copyright (c) 2022 GlobalMentor, Inc.

CALL mvn versions:set -DremoveSnapshot -DgenerateBackupPoms=false
