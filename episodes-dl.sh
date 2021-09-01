#!/bin/bash

prog_name=${0##*/}

ERR_NO_CSV_FILE=100
ERR_ARG=200

YOUTUBE_DL_EXEC=${YOUTUBE_DL_EXEC:-yt-dl}
csv_file=episodes.csv
remaining=9999

usage () {
	echo "usage: $prog_name [OPTION]... [FILE]"
	echo "Download videos listed in episodes.csv or FILE."
	echo "Skip videos already present."
	echo
	echo "-h, --help         display this help and exit"
	echo "-n, --count=NUM    download at most NUM videos"
}

err_msg () {
	local message=$1
	echo "[$prog_name] $message" >&2
}

is_nat_number () {
	local input_string=$1
	[[ $input_string =~ ^[0-9]+$ ]]
}

validate_args_to_count_option_or_die () {
	local NUM=$1
	if [[ -z "$NUM" ]]; then
		err_msg "--count or -n requires non empty argument"
		exit $ERR_ARG
	fi
	if ! is_nat_number "$NUM"; then
		err_msg "argument to --count or -n must be a natural number"
		exit $ERR_ARG
	fi
}

while :; do
	case $1 in
		-h|-\?|-help|--help)
			usage
			exit
			;;
		-n|--count)
			count_arg="$2"
			validate_args_to_count_option_or_die "$count_arg"
			remaining="$count_arg"
			shift
			;;
		--count=?*)
			count_arg=${1#*=}  # remove everything up to first '='
			validate_args_to_count_option_or_die "$count_arg"
			remaining="$count_arg"
			;;
		--count)
			err_msg "--count requires non empty argument"
			exit $ERR_ARG
			;;
		-?*)
			err_msg "Unknown option (ignored): $1"
			;;
		*)
			break
	esac
	shift
done

if [[ ! -f "$csv_file" ]]
then
	err_msg "No '$csv_file' in the current directory."
	exit $ERR_NO_CSV_FILE
fi

strip_header () {
	local fname=${1:--}
	tail +2 "$fname"
}

while IFS=, read url basename;
do
	[[ $remaining -eq 0 ]] && break
	
	if [[ -e "$basename.mp4" ]]
	then
		err_msg "File '$basename.mp4' exists. Skipping."
		continue
	fi
	"$YOUTUBE_DL_EXEC" -o "$basename.%(ext)s" $url
	let remaining--
done < <(strip_header "$csv_file")
