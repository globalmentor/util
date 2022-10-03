@ECHO OFF
REM Maven Set Version by Garret Wilson
REM Copyright (c) 2018 GlobalMentor, Inc.

SETLOCAL

SET NEW_VERSION=%~1
IF "%NEW_VERSION%" == "" (
  GOTO usage
)

SET ALL=

SHIFT
:args
SET PARAM=%~1
SET ARG=%~2
IF "%PARAM%" == "--all" (
  SHIFT
  SET ALL=-DprocessAllModules
) ELSE IF "%PARAM%" == "" (
  GOTO endargs
) ELSE (
  ECHO Unrecognized option %1. 1>&2
  ECHO:
  GOTO usage
)
GOTO args
:endargs

CALL mvn versions:set -DnewVersion=%NEW_VERSION% -DgenerateBackupPoms=false %ALL%
GOTO :eof

:usage
ECHO mvn-set-ver
ECHO Usage: mvn-set-ver ^<new-version^> [--all]
ECHO Updates the version number(s) in a Maven POM and all child POMS.
ECHO If --all is specified, all submodules will be updated even if they are not children.
EXIT /B 1
