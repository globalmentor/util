#!/bin/bash
# Git Merge Repo
# Copyright © 2018-2025 GlobalMentor, Inc.

set -u
shopt -s extglob # necessary for excluding subdirectory during a Git wildcard move

usage() {
  echo 'git-merge-repo' >&2
  echo 'Usage: git-merge-repover <repo-url> [--subdir [<subdir>]] --msg-prefix <msg-prefix> [--repo-branch <repo-branch>] [--dry-run]' >&2
  echo 'Merges the history from another repository into the current branch.' >&2
  echo 'If `--repo-branch` is not given, the repository branch with the same name as the current branch is used.' >&2
  echo '<subdir> defaults to the last segment of the repo path, without an extension.' >&2
  echo 'If given <msg-prefix> is prepended to each commit log message; quote if spaces are desired.' >&2
  echo >&2
  echo 'Example: git-merge-repo https://github.com/example/test.git' >&2
  echo 'Merges the `https://github.com/example/test.git` repository into the current branch.' >&2
  echo >&2
  echo 'Example: git-merge-repo https://github.com/example/test.git --subdir --msg-prefix "EXAMPLE-123: "' >&2
  echo 'Merges the `https://github.com/example/test.git` repository into the current branch' >&2
  echo '  placing it in the `test` subdirectory with a prefix for the commit messages.' >&2
  echo >&2
  echo 'Example: git-merge-repo https://github.com/example/test.git --subdir example-test' >&2
  echo 'Merges the `https://github.com/example/test.git` repository into the current branch' >&2
  echo '  placing it in the `example-test` subdirectory.' >&2
}

args=()
dryRun=0
msgPrefix=""
repoBranch=""
subdir="/" # '.' is a special value meaning "unspecified; use current directory", while '' will mean "use default from repo name"
while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run) dryRun=1; shift;;
    --msg-prefix) shift; msgPrefix="$1"; shift;;
    --repo-branch) shift; repoBranch="$1"; shift;;
    --subdir)
        shift
        subdir='' # indicate a subdir will be specified; now let's see if one is given
        if [[ $# -gt 0 ]] && [[ "$1" != "--"* ]]; then
          subdir="$1"
          shift
        fi
        ;;
    --help) usage; exit 0;;
    --) shift; while [ $# -gt 0 ]; do args+=("$1"); shift; done; break;;
    --*) echo "$(tput bold)Bad parameter: $1$(tput sgr0)" >&2; usage; exit 1 ;;
    *) args+=("$1"); shift;;
  esac
done

if [[ ${#args[@]} -ne 1 ]]; then
  echo "$(tput bold)Incorrect number of arguments: ${#args[@]}$(tput sgr0)" >&2
  usage
  exit 1
fi

branch=$(git branch --show-current) || exit 1
repoUrl=${args[0]}
repoFilename=${repoUrl##*/}
repoName=${repoFilename%%.*}
if [[ "$repoBranch" == "" ]]; then
  repoBranch="$branch"
fi
if [[ "$subdir" == "" ]]; then
  subdir="$repoName"
fi

echo "Destination branch: $branch"
echo "Source Repository URL: <$repoUrl>"
echo "Source Repository Branch: $repoBranch"
echo "Source Repository name: $repoName"
if [[ "$subdir" != "/" ]] then
	echo "Subdirectory: \`$subdir\`"
fi
if [[ "$msgPrefix" != "" ]] then
	echo "Commit message prefix: \"$msgPrefix\""
fi
if (( $dryRun )); then
  echo "(dry run)"
fi

if [[ $(git status --porcelain) ]]; then
  echo "Git status must be clean before preparing for release." >&2
  exit 1
fi

echo "Retrieving history from repository <${repoUrl}> ..."
if (( !$dryRun )); then
  git remote add git-merge-repo-origin "${repoUrl}" || exit 1
  git fetch git-merge-repo-origin || exit 1
fi

if [[ "$subdir" == "/" ]] then
  echo "Merging history from repository <${repoUrl}> ..."
  if (( !$dryRun )); then
    git merge "git-merge-repo-origin/${repoBranch}" --allow-unrelated-histories -m "${msgPrefix}Merged in history of repository \`${repoName}\`." || exit 1
  fi
else
  echo "Moving history from repository <${repoUrl}> into subdirectory \`${subdir}\` ..."
  if (( !$dryRun )); then
    git checkout -b git-merge-repo "git-merge-repo-origin/${repoBranch}" || exit 1
    mkdir "$subdir"
    git mv !("${subdir}") "${subdir}" || exit 1
    git commit -m "${msgPrefix}Moved \`${repoName}\` repository history to subdirectory \`${subdir}\`." || exit 1
    git checkout "$branch" || exit 1
  fi
  echo "Merging history from repository <${repoUrl}> ..."
  if (( !$dryRun )); then
    git merge git-merge-repo --allow-unrelated-histories -m "${msgPrefix}Merged in history of repository \`${repoName}\`." || exit 1
    git branch -D git-merge-repo || exit 1
  fi
fi
git remote rm git-merge-repo-origin || exit 1
