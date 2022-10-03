@ECHO OFF
REM Maven List Outdated Plugins by Garret Wilson
REM Copyright (c) 2022 GlobalMentor, Inc.

CALL mvn versions:display-plugin-updates
