@ECHO OFF
REM Git ForEach
REM Copyright (c) 2015 GlobalMentor, Inc.

IF [%1]==[] GOTO usage
IF [%2]==[] GOTO usage

ECHO Performing Git command in all repositories in %1...
FOR /F "tokens=*" %%R in (%1) DO (
	pushd %%R
	git %2 %3 %4 %5 %6 %7 %8 %9
	popd
)
GOTO :eof

:usage
@ECHO Git ForEach
@ECHO Executes a Git command on each repository listed in a file.
@ECHO Usage: git-foreach ^<repositories.lst^> ^<git-command^> [^<parameter^>]...
EXIT /B 1
