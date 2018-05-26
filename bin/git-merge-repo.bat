@ECHO OFF
REM Git Merge Repo
REM Copyright (c) 2018 GlobalMentor, Inc.

IF [%1]==[] GOTO usage

SET REPO_NAME=%~n1
ECHO Retrieving history from repository %1...
git remote add git-merge-repo %1
git fetch git-merge-repo
IF NOT [%2]==[] GOTO subdir
ECHO Merging history from repository %1...
git merge git-merge-repo/master --allow-unrelated-histories -m "Merged history of repository %REPO_NAME%."
git remote rm git-merge-repo
GOTO :eof

:subdir
ECHO Moving history from %1 into subdirectory %2...
git checkout -b git-merge-repo git-merge-repo/master
mkdir %2
FOR %%F IN (*) DO IF NOT %%F == %2 git mv %%F %2
FOR /D %%D IN (*) DO IF NOT %%D == %2 git mv %%D %2
git commit -m "Moved %REPO_NAME% repository history to subdirectory %2."
git checkout master
ECHO Merging history from repository %1...
git merge git-merge-repo --allow-unrelated-histories -m "Merged history of repository %REPO_NAME%."
git remote rm git-merge-repo
git branch -d git-merge-repo
GOTO :eof

:usage
@ECHO Git Merge Repo
@ECHO Merges the history from another repository into master.
@ECHO Usage: git-merge-repo ^<repo-url^> [^<subdir^>]
@ECHO If ^<subdir^> is present, content is moved into the subdirectory before merging.
@ECHO This command assumes Git is on the `master` branch.
EXIT /B 1
