#!/bin/sh

SHORT_OPTS="t:"
LONG_OPTS="tenants:"
if [ "$#" -le 0  ]; then
	echo "usage: invalid command line argument"
	exit 3
fi

if [ $1 == 'provision' ] || [ $1 == 'migrate' ]; then
	ACTION=$1
	shift

	ARGS=$(getopt -o "${SHORT_OPTS}" -l "${LONG_OPTS}" --name "$0" -- "$@") || { usage >&2; exit 2; }
	eval set -- "$ARGS"

	while [ "$#" -gt 0 ]; do
		case "$1" in
			(--tenants|-t)
				TENANTS=($2)
				shift 2
				;;

			(--)
				shift
				break
				;;

			(*)
				echo "usage: invalid command line argument"
				exit 3
				;;
	esac
	done

	TENANTS+=("$@")
	if [ $ACTION == "provision" ]; then
		. ./provision.sh config.txt
	elif [ $ACTION == "migrate" ]; then
		. ./migrate.sh config.txt
	fi

	exit 0
fi
echo "usage: invalid command line argument"
exit 1
