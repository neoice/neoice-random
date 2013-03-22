###
# quake-sudo
# allow user to access the quake3arena server output.
###

#!/bin/bash
echo -e "\E[1;31mPlease read this script and have a rough idea of what it does.\E[0m\n"

# the current tty is listed in an env
echo -e "\E[1mchanging current tty permissions...\E[0m"
# change its permissions to add _WORLD_ read/write
# this is a BAD idea. you generally DONT want anyone
# to be able to write your tty.
chmod 626 $SSH_TTY

# switch to the quake3 user and attach to the server output
su -c "screen -d -r q3a" quake3

# since we're no longer the quake3 user, reset the
# tty permissions.
echo -e "\E[1mreverting tty permissions...\E[0m"
chmod 620 $SSH_TTY
