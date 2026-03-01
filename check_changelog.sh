#!/bin/bash

#
# Usage:
#   check_changelog.sh <file>
#
# Verifies that the passed in file adheres to the following changelog formatting rules:
#
#  - A line must be 99 characters or less (excluding newlines)
#  - No trailing spaces, unix-style newlines ('\n')
#  - Indentation using spaces only
#  - Version sections must be separated by a line that contains exactly 99 dash '-' characters
#  - The first line of a version section must start with "Version: ";
#    this must be followed by a dot-separated version number (like 1.2.3.4)
#  - The second line of a version section must start with "Date: ";
#    this must be followed by the ISO 8601 date (YYYY-MM-DD) of the latest version
#    If the version is not yet published, the date should be 0000-00-00
#  - Following this, there may be 1 or more category entries. Each category entry
#    must be indented by 2 spaces, only consist of alphabetic characters, and end with a colon ':'
#  - In each category, there may be 1 or more changelog entries.
#    Each changelog entry must start with '    - '. If the entry does not fit in one line,
#    it can be continued on the next line by indenting it by 6 spaces.
#
# The rules are based on https://lua-api.factorio.com/latest/auxiliary/changelog-format.html
#

set -e
state=0

line_n=0

while IFS= read line; do
	line_n=$(($line_n+1))

	if [[ $(echo "$line" | wc -c) -gt 100 ]]; then
		echo "Line too long (max 99 characters + newline)" &>2
		exit 1
	fi

	if   [[ ($state == 0 || $state == 5 || $state == 6) && "$line" == "$(printf '%99s' | tr ' ' '-')"                                                   ]]; then
		state=1
	elif [[  $state == 1                                && -n "$(echo "$line" | grep -E -e '^Version: [0-9]+\.[0-9]+(\.[0-9]+)?(\.[0-9]+)?(-[^ ]+)?$')" ]]; then
		state=2
	elif [[  $state == 2                                && -n "$(echo "$line" | grep -E -e '^Date: [0-9]{4}-[0-9]{2}-[0-9]{2}$')"                       ]]; then
		state=3
	elif [[ ($state == 3 || $state == 5 || $state == 6) && -n "$(echo "$line" | grep -E -e '^  [A-Za-z ]+:')"                                           ]]; then
		state=4
	elif [[ ($state == 4 || $state == 5 || $state == 6) && -n "$(echo "$line" | grep -E -e '^    - ')"                                                  ]]; then
		state=5
	elif [[ ($state == 5 || $state == 6)                && -n "$(echo "$line" | grep -E -e '^      ')"                                                  ]]; then
		state=6
	else
		echo "In line $line_n: " >&2
		if   [[ $state == 0 ]]; then
			echo "  Error: Version sections must be separated by exactly 99 dashes" >&2
		elif [[ $state == 1 ]]; then
			echo "  Error: Version lines must start with \"Version: \" and be followed by a version number" >&2
		elif [[ $state == 2 ]]; then
			echo "  Error: Date lines must start with \"Date: \" and be followed by a YYYY-MM-DD date" >&2
		elif [[ $state == 3 ]]; then
			echo "  Error: Changelog categories must be indented by 2 spaces and only have alphabetic characters and spaces" >&2
		elif [[ $state == 4 ]]; then
			echo "  Error: Changelog entries must start with \"    - \"" >&2
		elif [[ $state == 5 ]]; then
			echo "  Error: Changelog line continuations must be indented by 6 spaces" >&2
		elif [[ $state == 6 ]]; then
			echo "  Error: Changelog line continuations must be indented by 6 spaces" >&2
		fi
		exit 1
	fi
done < "$1"

if [[ $state != 6 && $state != 5 ]]; then
	exit 1
fi
