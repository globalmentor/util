@ECHO OFF
REM Robomove by Garret Wilson
REM Copyright (c) 2012 GlobalMentor, Inc.
REM Moves files using Robocopy.
REM By default security, owner, and auditing information are not copied; they can be added using the /copyall argument.
REM Backup mode /b is also useful if NTFS restrictions must be overridden.
REM Both backup mode and copying security/owner/auditing information need full administrator permissions.
IF "%~1" == "" GOTO INSTRUCTIONS
IF "%~2" == "" GOTO INSTRUCTIONS
call robodupe %*
IF %ERRORLEVEL% GTR 2 ECHO Copy error %ERRORLEVEL% & GOTO END
IF %ERRORLEVEL% EQU 1 ECHO Copy successful & GOTO REMOVE
IF %ERRORLEVEL% EQU 0 echo No change & GOTO REMOVE
GOTO END
:REMOVE
ECHO Removing source %1 ...
rd /s /q %1
ECHO Source removal successful
GOTO END
:INSTRUCTIONS
ECHO Robomove by Garret Wilson
ECHO Copyright (c) 2012 GlobalMentor, Inc.
ECHO Moves files using Robocopy.
ECHO Usage: robodmove source/root parent/destination [args]
ECHO Example: robomove C:\temp D:\ (moves all files and directories from C:\temp to D:\temp)
ECHO Example: robomove C:\ D:\ (moves all files and directories from C:\ to D:\)
:END