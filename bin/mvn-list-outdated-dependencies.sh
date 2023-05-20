#!/bin/bash
# Maven List Outdated Dependencies by Garret Wilson
# Copyright © 2023 GlobalMentor, Inc.

set -eu

mvn versions:display-dependency-updates
