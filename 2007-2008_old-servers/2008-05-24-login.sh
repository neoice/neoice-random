#!/bin/bash

### START MAIN MENU ###
main_menu()
{
echo -e "\033[1mMake a selection\033[0m"

echo "1) screen                 5) hardline IRC"
echo "2) ssh to...              6) hardline terminal"
echo "3) #ev3                   7) activate tycho"
echo "4) f@h monitor            "
echo "*) just give me a fucking shell prompt"

echo -n "?: "
read CHOICE

case "$CHOICE" in
 1) screen
 exit 0;;

 2) ssh_menu
 exit 0;;

 3) screen -ls | grep ev3
     case "$?" in
      0) screen -D -r ev3;;
      1) screen -S ev3 irssi;;
     esac
 exit 0;;

 4) sudo fah-status
 exit 0;;

 5) screen -ls | grep kaizoku
     case "$?" in
      0) screen -D -r kaizoku;;
      1) screen -S kaizoku irssi --config=~/.irssi/netgamers;;
     esac
 exit 0;;

 6) telnet localhost 50069
 exit 0;;

 7) su eggdrop
 exit 0;;

 *) $CHOICE
 exit 0;;
esac
}
### END MAIN MENU ###

### START SSH MENU ###
ssh_menu()
{
echo -e "\n\033[1mSelect a host\033[0m"
echo "1) acheron.ham            "
echo "2) elysium.ham            "
echo "3) silenceisdefeat        "
echo "*) cancel"

echo -n "?: "
read CHOICE

case "$CHOICE" in

 1) screen -ls | grep acheron.ham
     case "$?" in
      0) screen -D -r acheron.ham;;
      1) screen -S acheron.ham ssh neoice@5.159.234.12;;
     esac
 exit 0;;

 2) screen -ls | grep elysium.ham
     case "$?" in
      0) screen -D -r elysium.ham;;
      1) screen -S elysium.ham ssh neoice@5.198.156.78;;
     esac
 exit 0;;

 3) screen -ls | grep silenceisdefeat
     case "$?" in
      0) screen -D -r silenceisdefeat;;
      1) screen -S silenceisdefeat ssh neoice@silenceisdefeat.org;;
     esac
 exit 0;;

 *) $CHOICE
 exit 0;; 
esac
}
### END SSH MENU ###

main_menu
