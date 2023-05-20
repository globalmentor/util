#!/bin/bash
# Maven Set Version by Garret Wilson
# Copyright © 2023 GlobalMentor, Inc.

set -eu

usage() {
  echo 'mvn-set-ver' >&2
  echo 'Usage: mvn-set-ver <new-version> [--all]' >&2
  echo 'Updates the version number(s) in a Maven POM and all child POMS.' >&2
  echo 'If --all is specified, all submodules will be updated even if they are not children.' >&2
  exit 1
}

args=()
all=""
while [ $# -gt 0 ]; do
  case "$1" in
    --all*)
      all=-DprocessAllModules
      shift
      ;;
    --help)
      usage
      exit 0
      ;;
    --)
      shift
      while [ $# -gt 0 ]; do args+=("$1"); shift; done;
      break;
      ;;
    --*)
      echo "**Bad parameter: $1**" >&2
      usage
      exit 1
      ;;
    *)
      args+=("$1");
      shift
      ;;
  esac
done

if [[ ${#args[@]} -ne 1 ]]; then
  echo "**Incorrect number of arguments: ${#args[@]}**" >&2
  usage
  exit 1
fi

mvn versions:set -DnewVersion=${args[0]} -DgenerateBackupPoms=false $all
