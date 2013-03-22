# rcon.py

this script was written on my first day learning Python. I already had
experience in BASIC, C/C++, PHP and probably Bash. I do not recall
precisely, but I believe it was also the first time I did any kind of
network programming.

after this program, I fell in love with Python. I was completely blown away
that a novice programmer and complete Python newbie could produce a fully
functional network client in a few hours **on the first day**.

the earliest version I can find has an mtime of 2008-12-05, but hints in
rcon_cron.sh indicate it is even older than that.

the `header` logic was stolen from some sort of PHP rcon script. today, I
would probably just `tcpdump` and reverse engineer the protocol that way.

# rcon_cron.sh

this appears to be a cronjob written to dynamically change the map rotation
based on the current player count of the quake3arena server. the earliest
mtime I found for this script is 2008-09-18. it depends on `rcon.py`, so
clearly, `rcon.py` was written even earlier, probably by a few months.

I may never know when `rcon.py` originated, but I have a few historical
server backups that I can use to research.

# quake-sudo.sh

`quake-sudo` was a script I deployed at one point to allow SSH users to
`su - quake3` and then attach to the console via `screen`. I know it was
deployed on thule-p, but this particular copy was actually found stashed
away as `test.sh` with an mtime of 2008-10-19.

today, I set `/usr/bin/screen` to be +setuid, to enable multiuser screen
sharing via `screen -x`. I believe this also allows `screen -r` after
switching users with `su`. I have not needed this feature in years, so I
am not positive how I would implement it today.

as indicated in the code, `quake-sudo` is a HUGE security risk and should
only be used if you know what you're doing and accept the risks involved.
even in 2008, I knew that this was a security hole!
