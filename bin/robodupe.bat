@ECHO OFF
REM Robodupe by Garret Wilson
REM Copyright (c) 2012 GlobalMentor, Inc.
REM Duplicates files using Robocopy.
REM By default security, owner, and auditing information are not copied; they can be added using the /copyall argument.
REM Backup mode /b is also useful if NTFS restrictions must be overridden.
REM Both backup mode and copying security/owner/auditing information need full administrator permissions.
IF "%~1" == "" GOTO INSTRUCTIONS
IF "%~2" == "" GOTO INSTRUCTIONS
SET SOURCE=%~1
SET DESTINATION=%~2
REM Add last source path segment to destination if present.
IF "%~nx1" == "" GOTO COPY
SET DESTINATION=%DESTINATION%\%~nx1
:COPY
ECHO Copying %SOURCE% to %DESTINATION% ...
robocopy %SOURCE% %DESTINATION% /e /it /dcopy:T /tee %3 %4 %5 %6 %7 %8 %9 /xd "$RECYCLE.BIN" "System Volume Information"
REM If the source is the root directory and the destination is not, remove the hidden and system attributes of the destination.
IF NOT "%~nx1" == "" GOTO END
IF "%~nx2" == "" GOTO END
REM Save the old errorlevel from Robocopy while we run attrib.
SET ROBOERRORLEVEL=%ERRORLEVEL%
attrib -s -h %DESTINATION%
SET ERRORLEVEL=%ROBOERRORLEVEL%
GOTO END
:INSTRUCTIONS
ECHO Robodupe by Garret Wilson
ECHO Copyright (c) 2012 GlobalMentor, Inc.
ECHO Duplicates files using Robocopy.
ECHO Usage: robodupe source/root parent/destination [args]
ECHO Example: robodupe C:\temp D:\ (duplicates all files and directories from C:\temp to D:\temp)
ECHO Example: robodupe C:\ D:\ (duplicates all files and directories from C:\ to D:\)
:END