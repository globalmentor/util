@ECHO OFF
REM In Each Directory
REM Copyright (c) 2016 GlobalMentor, Inc.

IF [%1]==[] GOTO usage
IF [%2]==[] GOTO usage

ECHO Performing command inside all directories %1...
FOR /D %%D in (%1) DO (
echo %%D
	pushd %%D
	%2 %3 %4 %5 %6 %7 %8 %9
	popd
)
GOTO :eof

:usage
@ECHO In Each Directory
@ECHO Executes a command inside each directory that matches some glob.
@ECHO Usage: in-each-dir ^<dir-glob^> ^<command^> [^<parameter^>]...
EXIT /B 1
