#!/bin/bash
# checking type of user with $USER environment variable 
# note: this script requires "root" access

if [[ $USER == root ]]; then
	if [[ $1 == --help ]]; then
		echo "just run this script"
	fi
	echo "process ..."
	
	# find files with .iso suffix in your system  
	find $HOME -type f -name "*.iso" 2> /dev/null | nl
	read -p 'select your iso file with number : ' num_iso 
	OPT=$(find $HOME -name "*.iso" 2> /dev/null | awk "NR==$num_iso {print}" )
	
	# find your block device (e.g. sda|sdb|sdc|etc) in /dev/ directory 
	ls /dev/ | grep -Eo "sd[a-z]" | uniq | nl
	read -p 'select your disk with number : ' num_disk
	ARG=$(echo -n '/dev/' ; ls /dev/ | grep -Eo "sd[a-z]" | uniq | awk "NR==$num_disk {print}")

	# asking question from user for start/stop process 
	echo -e "\niso : $OPT\ndevice : $ARG\n"
	read -p 'start process? [y,n]: ' ans_usr

	# if user press y[es] key , script will be launched
	if [ $ans_usr == y ]; then 

		# format your device with mkfs.fat -F32 (vfat) command 
		echo "FORMAT $ARG ..."
		mkfs.fat -F32 -I $ARG 1> /dev/null
		
		# write .iso file value on your block device with cp command 
		echo "write $OPT ON $ARG ..."
		cp $OPT $ARG

		echo -e "\ncompleted"

	# if user pess n[o] key , script will not be launched
	else
		echo "exit"	
	fi
else
	# error messege if you try launching script without super user access
	echo "you don't have access : Permission denied"
fi
