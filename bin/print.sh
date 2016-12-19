#!/bin/sh -

if [ -z "$2" ]; then
	printf "$1 "
else
	i=0
	len=`expr 89 - $1`
	while [ $i -lt $len ]
	do
		printf "."
		sleep .0015
		i=$[$i + 1]
	done
	case $2 in
		"Disabled")
			printf "[\033[1;37m$2\033[0m]\n"	# Print in black
			;;
		"Done")
			printf "[  \033[1;32m$2\033[0m  ]\n"	# Print in green
			;;
		"Enable")
			printf "[ \033[1;32m$2\033[0m ]\n"	# Print in green
			;;
		"Pass"|"Skip")
			printf "[  \033[1;36m$2\033[0m  ]\n"	# Print in cyan
			;;
		"Required")
			printf "[\033[0;31m\x1b[5m$2\x1b[25m\033[0m]\n"	# Print in red with blink
			;;
		*)
			printf "["
			i=0
			j=`expr 4 - ${#2} / 2`
			while [ $i -lt $j ]
			do
				printf " "
				i=$[$i + 1]
			done
			printf "$2"
			i=0
			while [ $i -lt $j ]
			do
				printf " "
				i=$[$i + 1]
			done
			printf "]"
			;;
	esac
fi

# \033[0;34m: Blue
# \033[1;30m: Gray
# \033[0;35m: Purple
# \033[0;33m: Yellow

