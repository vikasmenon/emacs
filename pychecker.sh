#!/bin/bash
pyflakes $1
echo "## pyflakes above, pep8 below ##"
pep8 --repeat $1
pylint $1
true