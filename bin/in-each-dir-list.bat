@ECHO OFF
REM In Each Directory List
REM Copyright (c) 2016 GlobalMentor, Inc.

IF [%1]==[] GOTO usage
IF [%2]==[] GOTO usage

ECHO Performing command in all directories in list %1...
FOR /F "tokens=*" %%R in (%1) DO (
	pushd %%R
	%2 %3 %4 %5 %6 %7 %8 %9
	popd
)
GOTO :eof

:usage
@ECHO In Each Directory List
@ECHO Executes a command on each directory listed in a file.
@ECHO Usage: in-each-dir-list ^<directory.lst^> ^<command^> [^<parameter^>]...
EXIT /B 1
