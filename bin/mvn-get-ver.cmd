@ECHO OFF
REM Maven Get Version by Garret Wilson
REM Copyright (c) 2022 GlobalMentor, Inc.
REM Requires `org.apache.maven.plugins:maven-help-plugin:3.1.0` or later.

CALL mvn help:evaluate -Dexpression="project.version" --quiet -DforceStdout
