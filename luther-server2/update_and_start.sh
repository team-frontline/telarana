#!/bin/bash
# author: Dulaj

# shellcheck disable=SC2092
# shellcheck disable=SC2006
if ! `git status | grep -q "nothing to commit"`; then
  echo have diffs
else
  echo no diffs
  git pull
  node server.js
fi
