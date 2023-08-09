#!/bin/bash
# Maven Use Release Versions by Garret Wilson
# Copyright © 2022-2023 GlobalMentor, Inc.

set -eu

mvn versions:use-releases -DprocessParent -DgenerateBackupPoms=false
