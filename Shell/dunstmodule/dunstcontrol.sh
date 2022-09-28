#!/bin/bash

CTL=$(which dunstctl)
if [ ${#CTL} -lt 1 ] 
then
	echo dunstctl não encontrado ou sem which
	exit 1
fi

pausar(){
$CTL set-paused toggle
}

status(){

	status=$($CTL is-paused)
	if [ "$status" = "false" ]
	then
		echo 
	elif [ "$status" = "true" ]
	then
		echo 
	else
		echo ""
	fi

}

case $1 in
	1)
		pausar
	;;
	*)
		status
	;;
esac
