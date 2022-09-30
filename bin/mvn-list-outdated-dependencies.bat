@ECHO OFF
REM Maven List Outdated Dependencies by Garret Wilson
REM Copyright (c) 2022 GlobalMentor, Inc.

CALL mvn versions:display-dependency-updates
