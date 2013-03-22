#!/bin/bash
#
# change/add explicit paths where needed
# before use!

# read last player count
PREV_PLAYERCOUNT=`tail -n 1 player.hist`

# fetch and record current player count
CUR_PLAYERCOUNT=`~/rcon.py 'status' | grep -c "\^7"`
echo $CUR_PLAYERCOUNT >> player.hist

# nothing has changed so do nothing
if [[ $CUR_PLAYERCOUNT == $PREV_PLAYERCOUNT ]]; then
	exit
fi

# to avoid overloading
sleep 2

# server empty!
if [[ $CUR_PLAYERCOUNT == 0 ]]; then
	echo "server empty"
fi

# the meat
# still in small bracket
if [[ $CUR_PLAYERCOUNT -lt 8 ]] && [[ $PREV_PLAYERCOUNT -lt 8 ]]; then
	exit
fi

# still in medium bracket
if [[ $CUR_PLAYERCOUNT -ge 8 ]] && [[ $CUR_PLAYERCOUNT -lt 12 ]] && [[ $PREV_PLAYERCOUNT -ge 8 ]] && [[ $PREV_PLAYERCOUNT -lt 12 ]]; then
	exit
fi

# still in large bracket
if [[ $CUR_PLAYERCOUNT -ge 12 ]] && [[ $PREV_PLAYERCOUNT -ge 12 ]]; then
	exit
fi

# bracket must have changed
# so change map according to current bracket
if [[ $CUR_PLAYERCOUNT -lt 8 ]]; then
	rcon.py "exec smallmaps.cfg"
	exit
fi

if [[ $CUR_PLAYERCOUNT -lt 12 ]]; then
	rcon.py "exec mediummaps.cfg"
	exit
fi

if [[ $CUR_PLAYERCOUNT -ge 12 ]]; then
	rcon.py "exec largemaps.cfg"
	exit
fi
