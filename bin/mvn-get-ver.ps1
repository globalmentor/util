#!/usr/bin/env pwsh
# Maven Get Version by Garret Wilson
# Copyright © 2022 GlobalMentor, Inc.
# Requires `org.apache.maven.plugins:maven-help-plugin:3.1.0` or later.

mvn help:evaluate -Dexpression="project.version" --quiet -DforceStdout


