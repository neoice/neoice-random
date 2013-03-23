#!/bin/bash
# neoice.net debian install
#

# boot from debian net install CD
# guided -> SEPARATE /usr, /var, /home partitions!
# use us.debian network mirror
# install standard system
# install boot loader

apt-get -y install ssh

# the first boot
/sbin/shadowconfig on

### START /ETC/SECURETTY ###
echo "\
# neoice.net /etc/securetty
# list of terminals on which root is allowed to login.
# see securetty(5) and login(1).
# root should have physical access!
console

# Standard consoles
tty1
tty2

# for people with serial port consoles
ttyS0

# for devfs
tts/0
" | tee /etc/securetty
### END /ETC/SECURETTY ###

### START /ETC/ISSUE ###
clear > /etc/issue

echo -en "\n"						 | tee -a /etc/issue
echo -en '\E[1;31m'"\033[1mDebian GNU/Linux 4.0\033[0m " | tee -a /etc/issue
echo -en '\E[1;34m'"\033[1m"				 | tee -a /etc/issue
echo -n  "(\r)"						 | tee -a /etc/issue
echo -en "\033[0m"'\E[36m'				 | tee -a /etc/issue
echo -n  " \n "						 | tee -a /etc/issue
echo -en "\033[0m"					 | tee -a /etc/issue
echo -n  "\l "						 | tee -a /etc/issue
echo -en "\n\n"						 | tee -a /etc/issue
### END /ETC/ISSUE ###

### START /ETC/APT/SOURCES.LIST ###
echo "\
# neoice.net /etc/apt/sources.list
# deb cdrom:[Debian GNU/Linux 4.0 r0 _Etch_ - Official i386 NETINST Binary-1 20070407-11:29]/ etch contrib main

deb http://ftp.us.debian.org/debian/ etch main
deb-src http://ftp.us.debian.org/debian/ etch main

deb http://security.debian.org/ etch/updates main contrib
deb-src http://security.debian.org/ etch/updates main contrib
" | tee /etc/apt/sources.list
### END /ETC/APT/SOURCES.LIST ###

apt-get -y update
apt-get -y upgrade
apt-get -y dist-upgrade

# admin tools
apt-get -y install sudo zip unzip screen nmap

### START /ETC/SUDOERS ###
echo "\
# neoice.net /etc/sudoers
#
# This file MUST be edited with the 'visudo' command as root.
# See the man page for details on how to write a sudoers file.

# Debian default / good measure
Defaults        env_reset

# think before you type
Defaults        lecture=always
Defaults        verifypw=all

# strict logging! big brother loves you
Defaults        logfile=/var/log/sudoers
Defaults        log_host
Defaults        mail_always
Defaults        mailto='root@localhost'

# prevents 'sudo sudo /bin/sh'
Defaults        !root_sudo

# just for fun :D
Defaults        insults

# Host alias specification
# User alias specification

# Cmnd alias specification
Cmnd_Alias      STAFF = /usr/bin, /usr/sbin

# User privilege specification
root    ALL=(ALL) ALL

# admin accounts
neoice  ALL = PASSWD: ALL

# staff" | tee /etc/sudoers
### END /ETC/SUDOERS ###

# zap any other bash profile
find / -name ".bashrc" -exec rm {} \;
find / -name ".profile" -exec rm {} \;
find / -name ".bash_profile" -exec rm {} \;

### START /ETC/BASH.BASHRC ###
### note the escapes quotes \"
echo "\
# neoice.net /etc/bash.bashrc
# a good administrative bashrc

# test for an interactive shell
# from gentoo /etc/bash/bashrc
if [[ \$- != *i* ]] ; then
        # Shell is non-interactive.  Be done now!
        return
fi

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# lame default prompt in case something breaks
export PS1='\h:\w\$ '

# set a fancy prompt (non-color, unless we know we want color)
case \$TERM in
   xterm-color | linux | screen*)
      case \$EUID in
         # RED / YELLOW for root
         0) PS1='\[\033[01;31m\]\u@\h\[\033[00m\]\[\033[01;33m\]:\w\[\033[00m\]\\\$ ' ;;

         # green / blue for users
         *) PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\\\$ ' ;;
      esac ;;
   *)
      PS1='\h:\w\$ ' ;;
esac

# comprehensive colorized 'ls' with file flags
eval \`dircolors -b\`
export LS_OPTIONS='--color=auto -aF'
alias ls='ls \$LS_OPTIONS'

# color grep
alias grep='grep --color=auto'

# Some more alias to avoid making mistakes:
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias hamachi='hamachi -c /etc/hamachi'
alias pico='nano -w' # pico for life!

# responsible umask
umask 022

# debian updates (non-default)
alias updates='apt-get update; apt-get upgrade'
alias apt-get='apt-get --purge'" | tee /etc/bash.bashrc /etc/profile
### END /ETC/BASH.BASHRC ###

# zap excess debian stuffs
apt-get -y remove --purge acpid mutt tcsh mtools telnet

# user stuff, non-default
apt-get -y install irssi naim

# basic dev stuff
apt-get -y install gcc make clisp

# hamachi vpn
adduser --group --system hamachi
wget http://files.hamachi.cc/linux/hamachi-0.9.9.9-20-lnx.tar.gz
tar -xvf hamachi-0.9.9.9-20-lnx.tar.gz
cd hamachi-0.9.9.9-20-lnx
make install
modprobe tun
echo "tun" | tee -a /etc/modules
tuncfg
chmod 760 /var/run/tuncfg.sock
chgrp hamachi /var/run/tuncfg.sock
hamachi-init -c /etc/hamachi
### START HAMACHI INIT.D SCRIPT ###
echo "\
#!/bin/sh

hamachi_start() {
  echo 'Starting hamachi...'
  /sbin/tuncfg
  /usr/bin/hamachi -c /etc/hamachi start
  /bin/chmod 760 /var/run/tuncfg.sock
  /bin/chgrp hamachi /var/run/tuncfg.sock
}

hamachi_stop() {
  echo 'Stopping hamachi...'
  killall tuncfg
  /usr/bin/hamachi -c /etc/hamachi stop
}

hamachi_restart() {
  hamachi_stop
  sleep 1
  hamachi_start
}

case \$1 in
'start')
  hamachi_start
  ;;
'stop')
  hamachi_stop
  ;;
'restart')
  hamachi_restart
  ;;
*)
  hamachi_start
esac
" | tee /etc/init.d/hamachi
### END HAMACHI INIT.D SCRIPT ###
chmod +x /etc/init.d/hamachi
update-rc.d hamachi defaults

# lighttpd web daemon
apt-get -y install lighttpd

mkdir /etc/web_status
### START WEB_STATUS.SH ###
### note all the escapes ###
echo "\
#!/bin/bash
HOST='neoice.net'
USER='statusuploader' # WRITE ONLY ACCESS TO neoice.net/status
PASSWD='PASSWORD_REDACTED' # RANDOM PASSWORD
HOSTNAME=\`cat /etc/hostname\`
FILEPATH=/etc/webstatus
FILE=\$FILEPATH\$HOSTNAME\".html\"
FOLDING=\$FILEPATH\$HOSTNAME\"_folding.html\"

sed -e 's/$/\<br>\&nbsp;\&nbsp;\&nbsp;/' /var/folding/foldingathome/CPU1/unitinfo.txt > \$FILEPATH\$FOLDING

date > \$FILEPATH\$FILE
echo \"<br>&nbsp;&nbsp;\" >> \$FILEPATH\$FILE
uptime >> \$FILEPATH\$FILE

cd \$FILEPATH

ftp -n \$HOST <<END_SCRIPT
quote USER \$USER
quote PASS \$PASSWD
put \$FILE
put \$FOLDING
quit
END_SCRIPT
exit 0" | tee /etc/cron.hourly/web_status
### END WEB_STATUS.SH ###
chmod +x /etc/cron.hourly/web_status
















# ventrilo server, non-default
# adduser --group --system ventrilo
### COPY INIT.D SCRIPT
# update-rc.d ventrilo defaults 70



###
# SAMBA CONFIGURATION NEEDS ADDRESSED
###
# apt-get install samba
# use "smbpasswd -U <main admin>" to change the Samba password



