
#firware_file is the first command line argument
firmware_file=$1

#pru_number is the second
pru_number=$2

# if pru_number is not 0 neither 1 or firmware_file is not readable
if [[ $pru_number != 0 ]] && [[ $pru_number != 1 ]] || [[ ! -r $firmware_file ]]
then
	echo
	echo "Usage:"
	echo "$0 <pru_number> <firmware_file>"
	echo
	echo "Where:"
	echo "    pru_number is 0 or 1"
	echo "    firmware_file is the firmware file path"
else
	# othrerwise
	# pru_name is the "pretty" name of the PRU (if PRU0 or PRU1)
	pru_name="PRU$pru_number"
	# firmware_location is the location of the firmware file that pru_name loads
	firmware_location="/lib/firmware/am335x-pru$pru_number-fw"
	# remoteproc is the pru_name respective remoteproc directory (either remotproc1 or remoteproc2)
	remoteproc="/sys/class/remoteproc/remoteproc$(($pru_number+1))"

	# if remoteproc is not readable
	if [[ -r $remoteproc/state ]]
	then
		# pru_state is either offline or running
		pru_state=$(cat $remoteproc/state)
	else
		# otherwise
		# no can do
		echo "State of $pru_name ($remoteproc/state) does not exist!"
		# i'm out!
		exit
	fi

	echo

	echo "---------- $pru_name choosed ----------"
	echo
	echo
	echo "- - - - -  Stopping PRU  - - - - -"
	# if pru is already offline
	if [[ $pru_state = "offline" ]]
	then
		# doesn't need to stop it
		echo "$pru_name already stopped!"
	else
		# otherwise
		# stop it!
		echo "Stopping $pru_name"
		echo "command: echo stop > $remoteproc/state"
		# stop_result stores both stdout and stderr of the stop command for pru_name
		stop_result=$((echo stop > $remoteproc/state) 2>&1)
		# if there's some error
		if [[ -n "$stop_result" ]]
		then
			# $pru_name could not be stopped!
			echo "*** Could not stop $pru_name ***"
		fi
	fi
	echo
	echo
	echo "- - - - - Loading firmware - - - - -"
	echo "Loading firmware file $(basename $firmware_file)"
	echo "command: sudo cp $firmware_file $firmware_location"
	# "installing" pru's firmware to the firmware_location
	sudo cp $firmware_file $firmware_location
	# just a sec to calm things down a bit
	sleep 1
	echo
	echo
	echo "- - - - -   Starting PRU   - - - - -"
	echo "Starting $pru_name"
	echo "command: echo start > $remoteproc/state"
	# start_result stores both stdout and stderr of the start command for pru_name
	start_result=$((echo start > $remoteproc/state) 2>&1)
	# if there's some error
	if [[ -n "$start_result" ]]
	then
		# $pru_name could not be started!
		echo "*** Could not start $pru_name ***"
	fi

	echo
	echo "----------     DONE!     ----------"
fi