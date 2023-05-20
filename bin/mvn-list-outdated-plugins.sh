#!/bin/bash
# Maven List Outdated Plugins by Garret Wilson
# Copyright © 2023 GlobalMentor, Inc.

set -eu

mvn versions:display-plugin-updates
