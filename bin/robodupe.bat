@ECHO OFF
REM Robodupe by Garret Wilson
REM Copyright (c) 2012-2018 GlobalMentor, Inc.
REM Duplicates files using Robocopy.
REM See https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/robocopy .

SETLOCAL

IF "%~1" == "" (
  GOTO usage
)

SET SOURCE=
SET SOURCE_UNQUOTED=
SET SOURCE_FILENAME=
SET DESTINATION=
SET DESTINATION_UNQUOTED=
SET DESTINATION_FILENAME=
SET FILES=

SET AUTO_DEST_SUBDIR=
SET DRY_RUN=
SET DRY_RUN_MESSAGE=
SET DEEP=
SET MIRROR=
SET MIRROR_MESSAGE=
SET MOVE=
SET OPERATION_MESSAGE=Copying

:args
REM "Raw" versions are to keep the user's source/destination quoting, preventing e.g. "A:\", which would consider the last quote as escaped.
SET PARAM=%~1
SET PARAM_RAW=%1
SET PARAM_FILENAME=%~nx1
SET ARG=%~2

IF "%PARAM%" == "--auto-dest-subdir" (
  SET AUTO_DEST_SUBDIR=true
  SHIFT
) ELSE IF "%PARAM%" == "--deep" (
  SET DEEP=/e
  SHIFT
) ELSE IF "%PARAM%" == "--dry-run" (
  SET DRY_RUN=/l
  SET DRY_RUN_MESSAGE=^(dry run^)
  SHIFT
) ELSE IF "%PARAM%" == "--mirror" (
  SET MIRROR=/mir
  SET MIRROR_MESSAGE=^(mirror^)
  SHIFT
) ELSE IF "%PARAM%" == "--move" (
  SET MOVE=true
  SET OPERATION_MESSAGE=Moving
  SHIFT
) ELSE IF "%PARAM%" == "" (
  GOTO endargs
) ELSE (
  IF "%SOURCE_UNQUOTED%" == "" (
    SET SOURCE=%PARAM_RAW%
    SET SOURCE_UNQUOTED=%PARAM%
    SET SOURCE_FILENAME=%PARAM_FILENAME%
    SHIFT
  ) ELSE IF "%DESTINATION_UNQUOTED%" == "" (
    SET DESTINATION=%PARAM_RAW%
    SET DESTINATION_UNQUOTED=%PARAM%
    SET DESTINATION_FILENAME=%PARAM_FILENAME%
    SHIFT
  ) ELSE (
    SET FILES=%FILES% "%PARAM%"
    SHIFT
  )
)
GOTO args
:endargs

IF "%SOURCE_UNQUOTED%" == "" (
  ECHO ERROR: Missing source argument. 1>&2
  EXIT /B 2
)

IF "%DESTINATION_UNQUOTED%" == "" (
  ECHO ERROR: Missing destination argument. 1>&2
  EXIT /B 2
)

IF EXIST %DESTINATION% (
  IF "%MIRROR%" == "" (
    SET AUTO_DEST_SUBDIR=true
  )
)

SET DESTINATION_AUTO_SUBDIR="%DESTINATION_UNQUOTED%\%SOURCE_FILENAME%"
IF "%AUTO_DEST_SUBDIR%" == "true" (
  IF NOT "%SOURCE_FILENAME%" == "" (
    SET DESTINATION=%DESTINATION_AUTO_SUBDIR%
  )
)

IF "%MOVE%" == "true" (
  IF NOT "%FILES%" == "" (
    ECHO ERROR: Move not supported for individual files. 1>&2
    EXIT /B 3
  )
)

IF "%FILES%" == "" (
  SET DEEP=/e
)

ECHO %OPERATION_MESSAGE% from %SOURCE% to %DESTINATION% %FILES% %MIRROR_MESSAGE% %DRY_RUN_MESSAGE% ...

REM /copy:DAT Copy file data, attributes, and timestamps.
REM /dcopy:DAT Copy directory data, attributes, and timestamps.
REM /e Copy subdirectories.
REM /it Include files with modified attributes ("tweaked").
REM /l Dry run: listing only; no modifications.
REM /mir Mirror: deletes orphaned destination directories and overwrites security settings.
REM /tee Write status to console
robocopy %SOURCE% %DESTINATION% %FILES% /copy:DAT /dcopy:DAT %DEEP% /it %DRY_RUN% %MIRROR% /tee /xd "$RECYCLE.BIN" "System Volume Information"

REM If the source is the root directory and the destination is not, remove the hidden and system attributes of the destination.
SET OLD_ERRORLEVEL=%ERRORLEVEL%
IF "%SOURCE_FILENAME%" == "" (
  IF NOT "%DESTINATION_FILENAME%" == "" (
    attrib -s -h %DESTINATION%
    SET ERRORLEVEL=%OLD_ERRORLEVEL%
  )
)

IF %ERRORLEVEL% LSS 0 GOTO :eof
IF %ERRORLEVEL% GTR 3 GOTO :eof

REM Remove the source if move is requested.
IF "%MOVE%" == "true" (
  ECHO Removing source %SOURCE% ...
  IF "%DRY_RUN%" == "" (
    rd /s /q %SOURCE%
    ECHO Source removal successful.
  )
)
GOTO :eof

:usage
ECHO Robodupe by Garret Wilson
ECHO Copyright (c) 2012-2018 GlobalMentor, Inc.
ECHO Duplicates directories and files using Robocopy.
ECHO:
ECHO Usage: robodupe ^<source^> ^<destination^> [^<file^>...] [--auto-dest-subdir] [--deep] [--dry-run] [--mirror] [--move] [^</opt^>...]
ECHO source: The path to the source directory.
ECHO destination: The path to the destination directory.
ECHO file: Optional file(s) to include; accepts wildcards.
ECHO     If files are present, no subdirectories are copied unless --deep is specified.
ECHO /opt: Optional Robocopy options and/or arguments such as /xd ….
ECHO --auto-dest-subdir: Automatically appends the source subdirectory to the destination directory.
ECHO     Defaults to enabled if destination exists, unless --mirror is specified.
ECHO --deep: Forces copying of subdirecties.
ECHO     Defaults to enabled unless files are present.
ECHO --dry-run: Files will only be listed; no copying or modification will occur.
ECHO --mirror: Missing source files and directories will be removed from the destination
ECHO     Uses the literal destination with no added subdirectory unless --auto-dest-subdir is specified.
ECHO --move: Removes source directory; currently not supported for individual files.
ECHO:
ECHO * By default security, owner, and auditing information are not copied; they can be added using the /copyall argument.
ECHO * Backup mode /b is also useful if NTFS restrictions must be overridden.
ECHO * Both backup mode and copying security/owner/auditing information need full administrator permissions.
ECHO:
ECHO Examples:
ECHO   robodupe A:\ B:\
ECHO     Duplicates all files and directories from A:\ to B:\.
ECHO:
ECHO   robodupe A:\foo B:\
ECHO     Duplicates all files and directories from A:\foo\ to B:\foo\.
ECHO:
ECHO   robodupe A:\foo B:\bar
ECHO     Duplicates all files and directories from A:\foo\ to B:\bar\foo\ if B:\bar\ exists.
ECHO     Duplicates all files and directories from A:\foo\ to B:\bar\ if B:\bar\ does not exist.
ECHO:
ECHO   robodupe A:\foo B:\bar --mirror
ECHO     Duplicates all files and directories from A:\foo\ to B:\bar\, removing extra files from the destination.
ECHO:
ECHO   robodupe A:\foo B:\bar --mirror --auto-dest-subdir
ECHO     Duplicates all files and directories from A:\foo\ to B:\bar\foo\, removing extra files from the destination.
ECHO:
ECHO   robodupe A:\foo B:\bar --move
ECHO     Duplicates all files and directories from A:\foo\ to B:\bar\foo\ if B:\bar exists.
ECHO     Duplicates all files and directories from A:\foo\ to B:\bar\ if B:\bar\ does not exist.
ECHO     Removes the directory tree A:\foo\.
EXIT /B 1
