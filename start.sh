#!/bin/bash

COIN=${COIN:=BCN}
export POOL=${POOL:="$(cat .coins | grep $COIN | cut -f2)"}
export PORT=${PORT:="$(cat .coins | grep $COIN | cut -f3)"}
export ALGORITHM=${ALGORITHM:="$(cat .coins | grep $COIN | cut -f4)"}
export WALLET=${WALLET:="$(cat .coins | grep $COIN | cut -f5)"}
export PASSWORD=${PASSWORD:=x}
export CPUS=$(grep -c ^processor /proc/cpuinfo)

if [ -z "$POWER" ]
then
	export THREADS=${THREADS:=3}
else
	case "$POWER" in
		x-1)
			export THREADS="$((CPUS-=1))"
			;;
		x-2)
			export THREADS="$((CPUS-=2))"
			;;
		x | full)
			export THREADS=$CPUS
			;;
	esac
fi

echo -e "\nStart mining $COIN at $POOL:$PORT as $WALLET using $ALGORITHM\n\n"

./cpuminer -a $ALGORITHM -o stratum+tcp://$POOL:$PORT -u $WALLET -p $PASSWORD -t $THREADS

