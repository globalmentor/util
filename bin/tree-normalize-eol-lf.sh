#!/bin/sh
#tree-normalize-eol-lf.sh
#Copyright (c) 2015 GlobalMentor, Inc.
#Recursively converts EOLs of common text types to Unix LF.
set -e
find . -type f -iregex ".*\(^2F^2FEN\|\.classpath\|\.css\|\.guisetheme\|\.htm\|\.html\|\.java\|\.js\|\.log\|\.lst\|\.md\|\.project\|\.php\|\.properties\|\.sql\|\.svg\|\.turf\|\.txt\|\.vcf\|\.xhtml\|\.xml\)" -not -path "./git/*" | while read file; do dos2unix $file; done
