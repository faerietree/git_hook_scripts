#!/bin/bash

echo "====================="
echo "======= PREREQUISITES"
echo "The path to the repo to execute the command in and the remote denoting what to pull."

# Definitions:
# cwd := current working directory
# rel := relative
# dir := directory


function delay {
IFS=''
action='Continuing'
if [ ! -z $1 ]; then
	action=$1
fi
echo -e "Press [ENTER] to continue or [ESC] to abort"
echo ""
t=10
echo -e "\e[0K\r$action in $t seconds..."
for (( i=${t}; i>0; i--)); do

#	echo -en "\e[1A";  # amend line 1 before

	read -s -N 1 -t 1 key

	if [ "$key" = $'\e' ]; then
		echo -e "\nAborting"
		exit 0
	elif [ "$key" == $'\x0a' ] ;then
		echo -e "\nContinuing"
		break
	fi
done
}


echo ""
echo "====================="
echo "======= INPUT"
echo "Processing input ..."
remote='origin'
destination_repo='../tariffcalculator'
#branch='master'

# Parse the arguments given to this script:
while :
do
	echo $1
	# Note: Space is delimiter! => $1 is first, $2 is first argument.
	case $1 in

		-h | --help | -\?)
			# TODO Create help function to call?
			echo "Usage:"
			echo "<script> [OPTIONS]"
			echo "e.g. pull_from_remote.sh --remote='origin' --destination_repo=../tariffcalculator"
			exit 0  # This is not an error, User asked for help. Don't "exit 1".
			;;

		--remote=*)
			remote=${1#*=}
			shift
			;;

		--dest=* | --destination_repo=*)
			destination_repo=${1#*=}
			shift
			;;

		--)  # End of all options
			break
			;;

		-*)
			printf >&2 'WARN: Unknown option (ignored): %s\n' "$1"
			shift
			;;

		*)
			remaining_input=$1
			break
			;;

	esac
done


echo ""
echo "====================="
echo "======= PULL"
echo 'Pulling remote '$remote' into '$destination_repo
echo 'Path: '$(pwd)
if [ -d $destination_repo ]; then
	cd $destination_repo
	pwd
	git pull $remote master
	echo "*done*"
else
	echo "Nothing to do."
fi

git status


