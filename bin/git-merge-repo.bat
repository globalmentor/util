@ECHO OFF
SETLOCAL
REM Git Merge Repo
REM Copyright (c) 2018 GlobalMentor, Inc.

SET REPO_PATH=%1

IF "%REPO_PATH%" == "" (
	GOTO usage
)
SET REPO_NAME=%~n1
SET SUBDIR=
SET MSG_PREFIX=

SHIFT
:args
SET PARAM=%~1
SET ARG=%~2
IF "%PARAM%" == "--subdir" (
	SHIFT
	IF NOT "%ARG%" == "" (
		IF NOT "%ARG:~0,2%" == "--" (
			SET SUBDIR=%ARG%
			SHIFT
		) ELSE (
			SET SUBDIR=%REPO_NAME%
		)
	) ELSE (
		SET SUBDIR=%REPO_NAME%
	)
) ELSE IF "%PARAM%" == "--msgprefix" (
	SHIFT
	IF NOT "%ARG%" == "" (
		SET MSG_PREFIX=%ARG%
		SHIFT
	) ELSE (
		ECHO Missing message prefix. 1>&2
		ECHO:
		GOTO usage
	)
) ELSE IF "%PARAM%" == "" (
	GOTO endargs
) ELSE (
	ECHO Unrecognized option %1. 1>&2
	ECHO:
	GOTO usage
)
GOTO args
:endargs

ECHO Repository path: %REPO_PATH%
ECHO Repository name: %REPO_NAME%
IF NOT "%SUBDIR%" == "" (
	ECHO Subdirectory: %SUBDIR%
)
IF NOT "%MSG_PREFIX%" == "" (
	ECHO Commit message prefix: `%MSG_PREFIX%`
)

ECHO Retrieving history from repository %REPO_PATH%...
git remote add git-merge-repo %REPO_PATH%
git fetch git-merge-repo
IF NOT "%SUBDIR%"=="" GOTO subdir
ECHO Merging history from repository %REPO_PATH%...
git merge git-merge-repo/master --allow-unrelated-histories -m "%MSG_PREFIX%Merged history of repository %REPO_NAME%."
git remote rm git-merge-repo
GOTO :eof

:subdir
ECHO Moving history from %REPO_PATH% into subdirectory %SUBDIR%...
git checkout -b git-merge-repo git-merge-repo/master
mkdir %SUBDIR%
FOR %%F IN (*) DO IF NOT %%F == %SUBDIR% git mv %%F %SUBDIR%
FOR /D %%D IN (*) DO IF NOT %%D == %SUBDIR% git mv %%D %SUBDIR%
git commit -m "%MSG_PREFIX%Moved %REPO_NAME% repository history to subdirectory %SUBDIR%."
git checkout master
ECHO Merging history from repository %REPO_PATH%...
git merge git-merge-repo --allow-unrelated-histories -m "%MSG_PREFIX%Merged history of repository %REPO_NAME%."
git remote rm git-merge-repo
git branch -d git-merge-repo
GOTO :eof

:usage
ECHO Git Merge Repo
ECHO Merges the history from another repository into master.
ECHO Usage: git-merge-repo ^<repo-url^> [--subdir [^<subdir^>]] [--msgprefix ^<msgprefix^>]
ECHO If --subdir is present, content is moved into the subdirectory before merging.
ECHO ^<subdir^> defaults to the last segment of the repo path.
ECHO If present ^<msgprefix^> is prepended to each commit log message; quote if spaces desired.
ECHO This command assumes the Git repository is on the `master` branch.
EXIT /B 1
