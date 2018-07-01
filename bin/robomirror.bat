@ECHO OFF
REM Robomirror by Garret Wilson
REM Copyright (c) 2012 GlobalMentor, Inc.
REM Mirrors files using Robocopy, deleting orphaned files in the destination.
REM By default security, owner, and auditing information are not copied; they can be added using the /copyall argument.
REM Backup mode /b is also useful if NTFS restrictions must be overridden.
REM Both backup mode and copying security/owner/auditing information need full administrator permissions.
IF "%~1" == "" GOTO INSTRUCTIONS
IF "%~2" == "" GOTO INSTRUCTIONS
call robodupe %1 %2 /purge %3 %4 %5 %6 %7 %8 %9
GOTO END
:INSTRUCTIONS
ECHO Robodmirror by Garret Wilson
ECHO Copyright (c) 2012 GlobalMentor, Inc.
ECHO Mirrors files using Robocopy, deleting orphaned files in the destination.
ECHO Usage: robodupeall source destination [args]
ECHO Example: robomirror C:\temp D:\ (mirrors all files and directories from C:\temp to D:\temp)
ECHO Example: robomirror C:\ D:\ (mirrors all files and directories from C:\ to D:\)
:END