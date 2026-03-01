#!/bin/bash
# can we have a comment what this files does? It seems, it just breaks the built ...


set -e
state=0

while IFS= read line; do
	if [[ $(echo "$line" | wc -c) -gt 1000 ]]; then
		echo "exit: More than 1000 bytes/line"
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
	elif [[ ($state == 5 || $state == 6)                && -n "$(echo "$line" | grep -E -e '^      [^ ]')"                                              ]]; then
		state=6
	else
		echo "Lint check exit status 1"
		exit 1
	fi
done < "$1"

echo "exit status $(state)"

if [[ $state != 6 && $state != 5 ]]; then
	exit 1
fi
