#!/bin/bash
# Maven Remove Version Snapshot by Garret Wilson
# Copyright © 2022-2023 GlobalMentor, Inc.

set -eu

mvn versions:set -DremoveSnapshot -DgenerateBackupPoms=false
