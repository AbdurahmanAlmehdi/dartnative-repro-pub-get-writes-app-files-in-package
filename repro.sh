#!/bin/sh
# Runs `dn pub get` in this Dart-only package and lists the files it creates.
set -e
cd "$(dirname "$0")"
dn pub get
echo
echo "--- files dn pub get added to the package (git status):"
git status --short --untracked-files=all
