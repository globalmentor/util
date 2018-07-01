@ECHO OFF
REM Robodupeall by Garret Wilson
REM Copyright (c) 2012 GlobalMentor, Inc.
REM Duplicates files using Robocopy, copying all information; this requires full administrator permissions.
IF "%1" == "" GOTO INSTRUCTIONS
IF "%2" == "" GOTO INSTRUCTIONS
call robodupe %1 %2 /b /copyall %3 %4 %5 %6 %7 %8 %9
GOTO END
:INSTRUCTIONS
ECHO Robodupeall by Garret Wilson
ECHO Copyright (c) 2012 GlobalMentor, Inc.
ECHO Duplicates files using Robocopy, copying all information.
ECHO Must be run as administrator.
ECHO Usage: robodupeall source destination [args]
ECHO Example: robodupeall C:\temp D:\ (duplicates all files and directories from C:\temp to D:\temp)
ECHO Example: robodupeall C:\ D:\ (duplicates all files and directories from C:\ to D:\)
:END