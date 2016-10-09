#!/bin/sh
# Author: Martin Vassor
# Description: An implementation of the list abstract data type.
# Creation date: 09-10-2016
# Last modified: Sun Oct  9 21:23:32 2016
# Known bugs: 

print_help() {
	echo "Usage: $0"
}

# Creates a new list.
new() {
	FILE="$(mktemp /tmp/list.XXXX)"
	echo "$FILE"
	exit 0;
}

# Args: 
#	$1: list instance
# Returns: 
#	0: if the list is empty
#	non-0: otherwise
isEmpty() {
	wc -l $1 | cut -d ' ' -f 1
}

# Args:
#	$1: list instance
#	$2: The element to add
# Action: 
#	Add element $2 at the end of the list $1
append() {
	echo "$2" >> "$1"
}

# Args:
#	$1: list instance
#	$2: index of the element to get
# Action: 
#	Display the n-th element
getAtIndex() {
	head -n "$(echo "$2 1 +p" | dc)" "$1" | tail -n 1
}

# Args: 
#	$1: list instance
#	$2: index to remove
# Action: 
#	Remove element at index n.
delete() {
	TMP="$(mktemp /tmp/tmplist.XXXX)"
	LINE="$(wc -l $1 | cut -d ' ' -f 1)"
	TAIL_LINE="$(echo "$LINE $2 - 1 - p" | dc)"
	head -n $2 $1 >> "$TMP"
	tail -n "$TAIL_LINE" $1 >> "$TMP"
	cat "$TMP" > $1
	rm "$TMP"
}

# Args: 
#	$1: list instance
#	$2: command to execute
# Action:
#	For each element, execute the command provided with the element on standard input
iterate() {
	for i in $(seq 0 $( echo $(wc -l "$1" | cut -d ' ' -f 1) 1 - p | dc)); do 
		LINE="$(getAtIndex $1 $i)"
		echo "$LINE" | "$2"
	done;
}

# Args: 
#	$1: list to remove
remove() {
	rm "$1"
	exit $?
}

if [ $# = "1" ]; then 
	"$1"
else 
	"$2" "$1" "$3"
fi

: <<=cut

=pod

=head1 NAME

=head1 SYNOPSIS

=head1 AUTHOR

=cut
