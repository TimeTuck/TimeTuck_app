#! /bin/sh
# Kills Flask server

if [ -z $1 ]
then
	echo 'Enter Port Number. 5000?'
else
	kill `lsof -t -i :$1`
fi
