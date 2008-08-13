#!/bin/bash

if [ $# -ne '2' ]; then
  echo -e "\nUsage: Compare a test-expected-* file and a test-results-* file."
  echo -e "$0 : < Expected testsuite results > < Testsuite results >\n";
  exit 1
fi;

REGRESSIONS=$(diff -wBI '^#.*' $1 $2 | sed -e '/^>/!d;s/^> //g')
if [ -n "$REGRESSIONS" ] ; then
  echo "Encountered regressions that don't match expected failures:"
  echo "$REGRESSIONS"
  exit 1
else
  echo "Passed regression testing. No new failures, no changed error values."
  exit 0
fi

