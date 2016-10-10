#!/bin/sh

#  Author : Martin Vassor
#  Usage : map.sh instance get key
#  Usage : map.sh instance put key value 
#  Usage : map.sh new
#  Usage : map.sh instance remove


# Args : 
#	$1 : map instance
#	$2 : key
# Returns : 
#	echo associated values if any and returns 0/1 if key present/absent
get() {
	grep "^$2" "$1" | cut -d ' ' -f2-

	[ "$(grep "^$2" "$1" | cut -d ' ' -f2-)" != "" ]
	exit $?
}

# Args : 
#	$1 : map instance
#	$2 : key
#	$3 : value
# Returns : 
#	0/1 in case of success/failure
put() {
	if [ "$2" = "" -o "$3" = "" ]; then 
		exit 1
	fi;
	delete "$1" "$2"
	echo "$2 $3" >> $1
	exit 0
}

#Args :
#	$1 : map instance
#	$2 : key to remove
# Action :
#	remove all tuples which key is $2
delete() {
	TEMP="$(mktemp /tmp/temp.XXXX)"
	sed "/^$2/d" "$1" > $TEMP
	cat "$TEMP" > "$1"
	rm "$TEMP"

# Do not exit, since it can be called from "put". Use backup exit.
}

# echo new instance name
new(){
	FILE="$(mktemp /tmp/map.XXXX)"
	echo "$FILE"
	exit 0;
}

# Args : 
#	$1 map instance to get the size
size() {
	wc -l "$1" | cut -d ' ' -f1
	exit 0;
}

# Args :
#	$1 map instance to remove
remove(){
	rm "$1"
	exit $?
}


if [ $# = "1" ]; then 
	"$1"
else 
	"$2" "$1" "$3" "$4"
fi

# Backup exit
exit 0;

: <<=cut
=pod

=head1 NAME

map.sh - A bash implementation of associative map

=head1 SYNOPSIS

C<map.sh instance operation [operation arguments]>
C<map.sh new>

=head1 OPERATIONS

=over 4

=item C<new> instanciate a new map and prints the instance key on stdout.

=item C<remove I<instance_key>> de-instanciate the instance refered by I<instance_key>.

=item C<get I<instance_key> I<key>> prints the value associated with the provided I<key>. Returns 0 if there exists such a I<key/value> pair, and non-0 otherwise (you have to check the return value before assuming anything on what have been printed).

=item C<put I<instance_key> I<key> I<value>> associate the given I<value> to the given I<key>. Remove any previous association.

=item C<delete I<instance_key> I<key>> remove any reference to the provided I<key>.

=back

=head1 DESCRIPTION

C<map.sh> implements a simple key-value map. At first, it is required to instanciate a new map using the C<new> operation, which prints the I<instance key>. Any other operation on this map should include this I<instance key>.

An instance is just a file (named I<map.XXXX> in /tmp/, with XXXX a random value). This file is deleted using the C<remove> operation. It is advised to use this operation instead of removing manually the I</tmp/map.XXXX> file, to avoid potential future problems if the implementation changes.

The file can be accessed otherwise for debug purposes.

=head1 Example

Create a new map: 
C<MY_MAP=$(./map.sh new)>

Add an element: 
C<./map.sh "$MY_MAP" put key1 value1>

Get an element:
C<./map.sh "$MY_MAP" get key1>

Remove an element:
C<./map.sh "$MY_MAP" delete key1>

Get the number of <key, value> tuples in the map:
C<./map.sh "$MY_MAP" size>

Deallocate the map:
C<./map.sh "$MY_MAP" remove>

=head1 AUTHOR

Martin Vassor, originally written for LPD, EPFL

=cut
