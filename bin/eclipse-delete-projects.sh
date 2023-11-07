#!/bin/bash
# Eclipse Delete Projects by Garret Wilson
# Copyright © 2023 GlobalMentor, Inc.

set -u

usage() {
  echo 'eclipse-delete-projects' >&2
  echo 'Usage: eclipse-delete-projects <project-dir>' >&2
  echo 'Recursively deletes all Eclipse project and project metadata files.' >&2
}

if [[ $# -ne 1 ]]; then
  echo "$(tput bold)Incorrect number of arguments: $#$(tput sgr0)" >&2
  usage
  exit 1
fi

find "$1" -type f -name '.project' -delete || exit
find "$1" -type f -name '.classpath' -delete || exit
find "$1" -type d -name '.settings' -exec rm -r {} +
