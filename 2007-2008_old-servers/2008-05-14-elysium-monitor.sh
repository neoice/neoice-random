BANNER='Current host is: '
HOSTNAME='ELYSIUM'

while [ 1 ]

do

clear; echo $BANNER$HOSTNAME
w
sleep 5

clear; echo $BANNER$HOSTNAME
cat /var/folding/foldingathome/CPU1/unitinfo.txt | sed -n '2,6p'
sleep 5

top -b -n 1 | sed -n '1,24p'
sleep 5

done
